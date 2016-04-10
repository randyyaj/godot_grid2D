
extends Node

#Base Class for Cell object so we can do compares and what not.

var cost
var position
var parent

func get_cost():
	return self.cost

func set_cost(cost):
	self.cost = cost

func get_pos():
	return self.position

func set_pos(position):
	self.position = position
	
func get_parent():
	return self.parent

func set_parent(parent):
	self.parent = parent
	
func equals(other):
	if (self.position == other.get_pos()):
		return true
	return false

func to_string():
	return str('Cell: [cost: ', self.cost, ', position: ', self.position, ', parent: ', self.parent, ']')