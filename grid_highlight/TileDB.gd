
extends Node

#Database to store tiles and their data

#Member variables
var Tile = preload('Tile.gd')
var tile_db

func _ready():
	pass
	
func set_tile_db(tile_db):
	self.tile_db = tile_db

func get_tile(tile_id):
	return self.tile_db[tile_id]

func get_tile_from_pos(tilemap, pos):
	"""
	Helper function ro retrieve 
	@param tilemap the tilemap object to use for searching
	@param pos the position to search on for the tile
	"""
	var world_coord = tilemap.world_to_map(pos)
	var tile = null
	var cell_id = tilemap.get_cellv(world_coord)
	
	for key in tile_db:
		if (tile_db[key].cell_id == cell_id):
			tile = tile_db[key]
		
	return tile
	
func _init():
	tile_db = {
		"INVALID": Tile.new(-1, "Invalid", 9999999, {}), 
		"FLOOR": Tile.new(0, "Floor", 1, {}), 
		"WALL": Tile.new(1, "Wall", 9999999, {})
	}