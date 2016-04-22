
extends KinematicBody2D

#Imported classes
var TileDB = preload('TileDB.gd')
var Cell = preload('Cell.gd')
var CellSet = preload('CellSet.gd')
var CharacterMenu = preload('CharacterMenu.gd')

#Constants
const TILE_WIDTH=16
const TILE_HEIGHT=16
const TILE_SIZE=Vector2(TILE_WIDTH,TILE_HEIGHT)
const MOVE_SPEED=4 #MUST BE DIVIDABLE BY THE TILE SIZE and BASE 2 Where MAX_SPEED==TILE_SIZE ex: 0.25, .5, 1, 2, 4, 8, 16

#Export variables to control on the scene editor/inspector
export var movement = 0
export var group_name = "characters"
export var is_recruitable = false
export var attack_range = 1

#Member variables
var tileDB
var tilemap
var hit
var close 
var path
var attackable_areas
var is_active
var is_selectable
var is_enemy_nearby
var character_menu
var next
var next_counter
var original_position

#Character specific var
var character_name
var health
var strength
var speed
#var sprite_sprite regions

func __init(dictionary):
	self.character_name = dictionary['group_name']
	self.character_name = dictionary['character_name']
	self.health = dictionary['health']
	self.strength = dictionary['strength']
	self.speed = dictionary['speed']
	self.is_recruitable = dictionary['is_recruitable']

func _ready():
	add_to_group("characters", true)
	add_to_group(group_name)
	set_process_input(true)
	set_fixed_process(true)
	set_process(true)
	
	tilemap = get_node('../TileMap')
	tileDB = TileDB.new()
	hit = false
	is_active = false
	is_enemy_nearby = false
	is_selectable = true
	close = []
	path = []
	attackable_areas = []
	next = null
	next_counter = 0
	
	character_menu = CharacterMenu.new()
	add_child(character_menu)

func _fixed_process(delta):
	update() #Runs _draw() function

func _process(delta):
	#Control movment
	if (is_active):
		if (path.size() > 0):
			if (get_pos() != next.get_pos()):
				if (get_pos().x < next.get_pos().x):
					move(MOVE_SPEED * Vector2(1,0))
					
				if (get_pos().x > next.get_pos().x):
					move(MOVE_SPEED * Vector2(-1,0))
					
				if (get_pos().y < next.get_pos().y):
					move(MOVE_SPEED * Vector2(0,1))
					
				if (get_pos().y > next.get_pos().y):
					move(MOVE_SPEED * Vector2(0,-1))
			else:
				if (next_counter < path.size()-1):
					next_counter+=1
					next = path[next_counter]
			
			#Checks if the character has stopped moving and prompts the character menu
			if (get_pos() == path[path.size()-1].get_pos()):
				#print(get_z())
				#set_z(-1)
				original_position = path[0].get_pos()
				next_counter = 0
				check_proximity()
				show_character_menu()
				path.clear()

func show_character_menu():
	set_process_input(false)
	"""
	Shows a character action menu
	"""
	character_menu.set_pos(get_pos()+Vector2(24,0))
	character_menu.toggle_info_button(true)
	character_menu.toggle_item_button(true)
	character_menu.toggle_wait_button(true)
	character_menu.toggle_cancel_button(true)
	character_menu.show()

func _draw():
	if (hit):
		#Draws squares from the closed list
		for location in close:
			#draw_rect(Rect2(location.get_pos()-get_pos(), TILE_SIZE), Color(1,1,0,0.75))
			draw_rect(Rect2(location.get_pos()-get_pos(), TILE_SIZE), Color(0,255,255,0.75))
			#Draw lines around squares	
			draw_lines(location.get_pos()-get_pos())
		
		#Draw mouse areas
		for i in path:
			draw_rect(Rect2(i.get_pos()-get_pos(), TILE_SIZE), Color(1,1,0,0.75))
	
	if (is_enemy_nearby):
		for location in attackable_areas:
			draw_rect(Rect2(location-get_pos(), TILE_SIZE), Color(1,0,0,0.75))
			draw_lines(location-get_pos())
			
			

func show_moveable_areas():
	"""
	Function calculates the amount a character can move based on tile cost
	"""
	var open = []
	var cell_set = CellSet.new()
	
	#Insert initial position into open list
	open.append(Cell.new(-1, get_pos(), null))
		
	while !open.empty():
		var current_location = open[0]
		var is_location_occupied = false
		
		if (current_location.get_pos() != get_pos()):
			for node in get_tree().get_nodes_in_group("characters"):
				if (node.get_pos() == current_location.get_pos()):
					is_location_occupied = true
			
		if (current_location.get_cost() < movement && !is_location_occupied):
			for neighbor in get_neighbors(current_location.get_pos()):
				var new_cost = current_location.get_cost() + get_tile_from_pos(neighbor).get_cost()
				var cell = Cell.new(new_cost, neighbor, current_location)
				
				if !cell_set.contains(cell):
					open.append(cell)
					cell_set.add(cell)
					
			close.append(current_location)
		open.pop_front()

func show_attackable_areas():
	pass
		
func check_proximity():
	#TODO Check against attack range
	character_menu.toggle_attack_button(false)
	character_menu.toggle_recruit_button(false)
	character_menu.toggle_trade_button(false)
	is_enemy_nearby = false
	attackable_areas = []
	var neighbors = []
	
	attackable_areas = get_attackable_areas(get_pos())
	
	for neighbor in get_attackable_areas(get_pos()):
		if (group_name == "player"):
			for character in get_tree().get_nodes_in_group("enemy"):
				if (character.get_pos() == neighbor):
					character_menu.toggle_attack_button(true)
					is_enemy_nearby = true
			
			for character in get_tree().get_nodes_in_group("other"):
				if (character.get_pos() == neighbor):
					if (character.is_recruitable):
						character_menu.toggle_recruit_button(true)
						
			for character in get_tree().get_nodes_in_group("player"):
				if (character.get_pos() == neighbor):
					if (character.is_recruitable):
						character_menu.toggle_trade_button(true)
		
		if (group_name == "other"):
			for character in get_tree().get_nodes_in_group("enemy"):
				if (character.get_pos() == neighbor):
					character_menu.toggle_attack_button(true)
					is_enemy_nearby = true
					
		if (group_name == "enemy"):
			for character in get_tree().get_nodes_in_group("player"):
				if (character.get_pos() == neighbor):
					character_menu.toggle_attack_button(true)
					is_enemy_nearby = true
					
			for character in get_tree().get_nodes_in_group("other"):
				if (character.get_pos() == neighbor):
					character_menu.toggle_attack_button(true)
					is_enemy_nearby = true

func draw_lines(pos):
	"""
	Function draws outline around rectangles
	"""
	draw_line(pos, pos+Vector2(0,16), Color(0,0,0), 1)
	draw_line(pos, pos+Vector2(16,0), Color(0,0,0), 1)
	draw_line(pos+Vector2(16,16), pos+Vector2(16,0), Color(0,0,0), 1)
	draw_line(pos+Vector2(16,16), pos+Vector2(0,16), Color(0,0,0), 1)

func get_attackable_areas(pos):
	var neighbors = []
	
	for i in range(1,attack_range+1):
		if (attack_range > 1 and i < attack_range):
			neighbors.append(Vector2(pos.x + TILE_WIDTH*i, pos.y + TILE_HEIGHT*i))
			neighbors.append(Vector2(pos.x + TILE_WIDTH*i, pos.y - TILE_HEIGHT*i))
			neighbors.append(Vector2(pos.x - TILE_WIDTH*i, pos.y + TILE_HEIGHT*i))
			neighbors.append(Vector2(pos.x - TILE_WIDTH*i, pos.y - TILE_HEIGHT*i))
		
		neighbors.append(Vector2(pos.x + TILE_WIDTH*i, pos.y))
		neighbors.append(Vector2(pos.x - TILE_WIDTH*i, pos.y))
		neighbors.append(Vector2(pos.x, pos.y + TILE_HEIGHT*i))
		neighbors.append(Vector2(pos.x, pos.y - TILE_HEIGHT*i))
	
	return neighbors

func get_neighbors(pos):
	"""
	Function to get the neighboring cells based of of grid size
	"""
	var neighbors = []
	neighbors.append(Vector2(pos.x + TILE_WIDTH, pos.y))
	neighbors.append(Vector2(pos.x - TILE_WIDTH, pos.y))
	neighbors.append(Vector2(pos.x, pos.y + TILE_HEIGHT))
	neighbors.append(Vector2(pos.x, pos.y - TILE_HEIGHT))
	return neighbors

func get_tile_from_pos(pos):
	"""
	Decorator function to retrieve tile from a given position
	@See class TileDB.gd
	"""
	return tileDB.get_tile_from_pos(tilemap, pos)
	
func is_active():
	"""
	Returns if a character is currently active or moving
	"""
	return is_active

func follow_mouse(mouse_pos):
	"""
	Function draws square where mouse position is and keeps track of where the character can move
	"""
	var current = null
	
	for i in close:
		if (i.get_pos() == mouse_pos):
			current = i
	
	if (current != null):
		path.clear()
		path.append(current)
		
		while current.get_pos() != get_pos():
		   current = current.get_parent()
		   path.append(current)
		
		path.invert()
		next = path[0]
	else:
		path.clear()
	
func _input(event):
	"""
	Tracks events being executed. In this case if a character is clicked on.
	"""
	if (event.type == InputEvent.MOUSE_BUTTON and event.is_pressed() and !event.is_echo()):
		if (tilemap.world_to_map(event.pos) == tilemap.world_to_map(get_pos())):
			var other_unit_moving = false
			
			for character in get_tree().get_nodes_in_group("characters"):
				if (character.is_active()):
					other_unit_moving = true
					
			if (!other_unit_moving):
				hit = !hit
				close.clear()
				path.clear()
				show_moveable_areas()
				
				if (!hit):
					show_character_menu()
		else:
			hit = false
 
			#Character is still active if it can move
			if (path.size() > 0):
				is_active = true
			
			is_enemy_nearby = false
			attackable_areas.clear()
			
			close.clear()
	
	#Draws squares following the mouse position
	if (event.type==InputEvent.MOUSE_MOTION and hit):
		follow_mouse(tilemap.map_to_world(tilemap.world_to_map(event.pos)))
	
func set_group(group_name):
	self.group_name = group_name
	
func end_turn():
	set_process(false)
	set_process_input(false)
	set_fixed_process(false) #Commented controls draw events