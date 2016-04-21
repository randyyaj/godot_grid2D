
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

#Member variables
var tileDB
var tilemap
var hit
var close 
var path
var is_active
var character_menu
var next
var next_counter

func _ready():
	add_to_group ("characters", true)
	set_process_input(true)
	set_fixed_process(true)
	set_process(true)
	
	tilemap = get_node('../TileMap')
	tileDB = TileDB.new()
	hit = false
	is_active = false	
	close = []
	path = []
	next = null
	next_counter = 0
	
	character_menu = CharacterMenu.new()
	add_child(character_menu)

func _fixed_process(delta):
	update() #Runs _draw() function

func _process(delta):
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
			
			if (get_pos() == path[path.size()-1].get_pos()):
				next_counter = 0
				show_character_menu()
				path.clear()

func show_character_menu():
	#TODO Need action menu to run sequentially to update the characters paths
	#character_menu.set_process_input(true)
	character_menu.set_pos(get_pos()+Vector2(24,0))
	character_menu.toggle_wait_button(true)
	character_menu.toggle_cancel_button(true)
	#if character is near enemy and can attack
	#character_menu;.
	character_menu.show()
	character_menu.set_original_location(path[0].get_pos())
	#character_menu.grab_focus()
	#character_menu.show_modal(true)
	#print('PATH CLEARED')
	#path.clear()
	#set_process_input(false)

func _draw():
	#Draws squares from the closed list
	if hit==true:
		for location in close:
			#draw_rect(Rect2(location.get_pos()-get_pos(), TILE_SIZE), Color(1,1,0,0.75))
			draw_rect(Rect2(location.get_pos()-get_pos(), TILE_SIZE), Color(0,255,255,0.75))
			draw_lines(location.get_pos()-get_pos())
			
		for i in path:
			draw_rect(Rect2(i.get_pos()-get_pos(), TILE_SIZE), Color(1,1,0,0.75))
		

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
		
func draw_lines(pos):
	"""
	Function draws outline around rectangles
	"""
	draw_line(pos, pos+Vector2(0,16), Color(0,0,0), 1)
	draw_line(pos, pos+Vector2(16,0), Color(0,0,0), 1)
	draw_line(pos+Vector2(16,16), pos+Vector2(16,0), Color(0,0,0), 1)
	draw_line(pos+Vector2(16,16), pos+Vector2(0,16), Color(0,0,0), 1)

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
	
func is_moving():
	return is_active

func follow_mouse(mouse_pos):
	
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
		
		#---TODO Prevent collision Invalid call. Nonexistent function 'get_pos' in base 'Nil'.
		#---TODO only one character can move at a time
		path.invert()
		next = path[0]
	else:
		path.clear()
	
func _input(event):
	"""
	Tracks events being executed. In this case if a character is clicked on.
	"""
	if event.type == InputEvent.MOUSE_BUTTON and event.is_pressed() and !event.is_echo():
		if tilemap.world_to_map(event.pos) == tilemap.world_to_map(get_pos()):
			var other_unit_moving = false
			
			for node in get_tree().get_nodes_in_group("characters"):
				if (node.is_moving()):
					other_unit_moving = true
					
			if (!other_unit_moving):
				hit = !hit
				close.clear()
				path.clear()
				show_moveable_areas()
			
		else:
			hit = false
			
			if (character_menu.is_visible()): #TODO USE MODAL
				#character_menu.hide()
				if (path.size() > 0):
					move_to(path[0].get_pos())
					path.clear()
			
			if (path.size() > 0):
				is_active = true
						
			close.clear()
		
	if (event.type==InputEvent.MOUSE_MOTION and hit):
		follow_mouse(tilemap.map_to_world(tilemap.world_to_map(event.pos)))
		#print("Mouse Motion at: ", tilemap.map_to_world(tilemap.world_to_map(event.pos)))
			
	#if event.type == InputEvent.MOUSE_BUTTON and event.is_pressed() and !event.is_echo():
	#	print(get_tile(event.pos).get_name())
	
			
			