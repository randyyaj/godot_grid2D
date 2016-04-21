
extends Node

var player_phase
var enemy_phase
var other_phase

func _ready():
	set_process(true)
	player_phase = true
	enemy_phase = false
	other_phase = false
	
func _process(delta):
	if player_phase:
		reset()

func reset_phase(group_name):
	for character in get_tree().get_nodes_in_group(group_name):
		character.set_opacity(1)
		character.set_input_process(true)
		character.set_fixed_process(true)
		character.set_process(true)

func reset_player():
	reset_phase("player")

func reset_enemy_phase():
	reset_phase("enemy")
	
func reset_other_phase():
	reset_phase("other")