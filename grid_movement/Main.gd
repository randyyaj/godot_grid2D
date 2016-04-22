
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
	if (player_phase):
		if (!has_active_units("player")):
			reset_enemy_phase()
			player_phase = false
			enemy_phase = true
		
	if (enemy_phase):
		if (!has_active_units("enemey")):
			if (get_tree().has_group("other")):
				reset_other_phase()
				enemy_phase = false
				other_phase = true
			else:
				reset_player_phase()
				enemy_phase = false
				player_phase = true
				
	if (get_tree().has_group("other")):
		if (other_phase):
			if (!has_active_units("other")):
				reset_player_phase()
				other_phase = false
				player_phase = true

func has_active_units(group_name):
	var counter = 0
	
	for character in get_tree().get_nodes_in_group(group_name):
		if (character.is_selectable):
			counter+=1
	
	if (counter > 0):
		return true
	
	return false
	
func reset_phase(group_name):
	for character in get_tree().get_nodes_in_group(group_name):
		character.set_opacity(1)
		character.set_process_input(true)
		character.set_fixed_process(true)
		character.set_process(true)
		character.is_selectable = true

func reset_player_phase():
	reset_phase("player")

func reset_enemy_phase():
	reset_phase("enemy")
	
func reset_other_phase():
	reset_phase("other")