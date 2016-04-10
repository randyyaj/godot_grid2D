
extends KinematicBody2D

#Imported classes
var TileDB = preload('TileDB.gd')
var Cell = preload('Cell.gd')
var CellSet = preload('CellSet.gd')

#Constants
const TILE_WIDTH=16
const TILE_HEIGHT=16
const TILE_SIZE=Vector2(TILE_WIDTH,TILE_HEIGHT)

#Export variables to control on the scene editor/inspector
export var movement = 0

#Member variables
var tileDB
var tilemap
var hit
var close 

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	tilemap = get_node('../TileMap')
	tileDB = TileDB.new()
	hit = false
	close = []

func _fixed_process(delta):
	update() #Runs _draw() function

func _draw():
	#Draws squares from the closed list
	if hit==true:
		for location in close:
			draw_rect(Rect2(location.get_pos()-get_pos(), TILE_SIZE), Color(1,1,0,0.75))
			draw_lines(location.get_pos()-get_pos())

func show_moveable_areas():
	"""
	Function calculates the amount a character can move based on tile cost
	"""
	var open = []
	var cell_set = CellSet.new()
	
	#Insert initial position into open list
	open.append(Cell.new(-1, get_pos(), get_pos()))
		
	while !open.empty():
		var current_location = open[0]
		
		if (current_location.get_cost() < movement):
			for neighbor in get_neighbors(current_location.get_pos()):
				var new_cost = current_location.get_cost() + get_tile_from_pos(neighbor).get_cost()
				var cell = Cell.new(new_cost, neighbor, current_location.get_pos())
				
				#print('Index: ', cell_set.index_of(cell), ',' , cell.to_string())
				
				if !cell_set.contains(cell):
					open.append(cell)
					cell_set.add(cell)
					
			close.append(current_location)
		open.pop_front()
		
		#print(cell_set.size())
		
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
	
func _input(event):
	"""
	Tracks events being executed. In this case if a character is clicked on.
	"""
	if event.type == InputEvent.MOUSE_BUTTON and event.is_pressed() and !event.is_echo():
		if tilemap.world_to_map(event.pos) == tilemap.world_to_map(get_pos()):
			hit = !hit
			show_moveable_areas()
		else:
			hit = false
			
	#if event.type == InputEvent.MOUSE_BUTTON and event.is_pressed() and !event.is_echo():
	#	print(get_tile(event.pos).get_name())
	
			
			