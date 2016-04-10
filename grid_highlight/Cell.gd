
extends "BaseCell.gd"

#Cell object extends BaseCell used to capture cell information for area movement calculation

func _ready():
	pass

func _init(cost, position, parent):
	self.cost = cost
	self.position = position
	self.parent = parent