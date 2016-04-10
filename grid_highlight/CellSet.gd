
extends Node

#Shitty implementation of a Set for storing cells.

#Member variables
var Cell = preload('Cell.gd')
var set

func add(cell):
	if (!self.contains(cell)):
		set.push_back(cell)

func clear():
	set.clear()

func contains(cell):
	for i in range(0, set.size()):
		if (set[i].equals(cell)):
			return true
			
	return false

func get_cell(cell):
	for i in set:
		if (i.equals(cell)):
			return i
	
	return null
			
func index_of(cell):
	for i in range(0, set.size()):
		if (set[i].equals(cell)):
			return i
			
	return -1

func empty():
	set.empty()

func remove(cell):
	for i in set:
		if (i.equals(cell)):
			set.remove(i)

func size():
	return set.size()
	
func to_string():
	var string_value="["
	
	for cell in set:
		string_value += cell.to_string() + ", \n"
		
	return string_value + "]"

func _init():
	self.set = []