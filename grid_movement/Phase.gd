
extends Node

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
func _process(delta):
	pass

func reset():
	for characters in get_tree().get_nodes_in_group("characters"):
		characters.set_opacity(1)
		character.set_fixed_process(true)
		character.set_process(true)