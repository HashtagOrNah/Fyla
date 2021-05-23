extends Control

var main_menu = load("res://MainMenu/MainMenu.tscn")

func _on_MainMenu_pressed():
	
	Saving.save_game()
	get_tree().change_scene_to(main_menu)
	get_parent().queue_free()

func _on_Return_pressed():
	visible = false
