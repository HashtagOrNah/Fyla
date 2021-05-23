extends Control


var title_screen = load("res://MainMenu/MainMenu.tscn")
onready var tile_map_gen = load("res://MapGen/TileMapGen.tscn")
var empty_grid_map = load("res://Map Setup/EmptyMap.tscn")
onready var view_map = $"MainMargins/MarginFit/MainContent/ButtonMargins/Buttons And Map/ViewportContainer/Viewport"
var width = 10
var height = 10

var new_map : TileMap
var new_grid_map
var r_seed = 0

func _ready():
	
	new_map = tile_map_gen.instance()
	new_map.gen_random_map(width, height, r_seed)
	view_map.add_child(new_map)

func _on_BackButton_pressed():
	get_tree().change_scene_to(title_screen)

func _on_GenMap_pressed():
	
	new_map.gen_random_map(width, height, r_seed)

func _on_Height_value_changed(value):
	height = value


func _on_Width_value_changed(value):
	width = value


func _on_Play_Map_pressed():
	
	new_grid_map = empty_grid_map.instance()
	get_tree().get_root().add_child(new_grid_map)
	get_tree().change_scene_to(new_grid_map)
	new_grid_map.tile_to_grid(new_map)
