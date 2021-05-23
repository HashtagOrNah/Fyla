class_name Room
extends TileMap

var dimensions : Vector2 setget _set_dimensions
var tile_map_pos : Vector2
var center : Vector2
var connected

func _set_dimensions(vec : Vector2):
	
	dimensions = vec

	center = Vector2(tile_map_pos.x+floor(vec.x/2), tile_map_pos.y+floor(vec.y/2))
	
	connected = false
