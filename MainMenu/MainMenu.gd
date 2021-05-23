extends Control

var map_select = load("res://MainMenu/WorldSelect.tscn")
var profile_select = load("res://MainMenu/PlayerSelect.tscn")

func _on_ExitGame_pressed():
	get_tree().quit()


func _on_PlayGame_pressed():
	get_tree().change_scene_to(map_select)

func _on_ProfileSelect_pressed():
	get_tree().change_scene_to(profile_select)