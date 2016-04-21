
extends Node

func _ready():
	set_process_input(true)
	set_process(true)

func _input(event):
	"""
	Tracks tile stats
	"""
		
	if (event.type==InputEvent.MOUSE_MOTION):
		follow_mouse(tilemap.map_to_world(tilemap.world_to_map(event.pos)))
		#print("Mouse Motion at: ", tilemap.map_to_world(tilemap.world_to_map(event.pos)))
			
	#if event.type == InputEvent.MOUSE_BUTTON and event.is_pressed() and !event.is_echo():
	#	print(get_tile(event.pos).get_name())

