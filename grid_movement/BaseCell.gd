
extends Node

#Base Class for Cell object so we can do compares and what not.

var cost
var position
var parent
var f_cost
var g_cost
var h_cost

func get_cost():
	return self.cost

func set_cost(cost):
	self.cost = cost
	
func get_fcost():
	return self.cost

func set_fcost(cost):
	self.cost = cost
	
func get_gcost():
	return self.cost

func set_gcost(cost):
	self.cost = cost
	
func get_hcost():
	return self.cost

func set_hcost(cost):
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