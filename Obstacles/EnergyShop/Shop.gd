extends Spatial

var main_menu = load("res://MainMenu/MainMenu.tscn")

func _ready():
	
	Events.connect("beat_game", self, "_on_beat_game")
	$AnimationPlayer.play("PylonBob")

func _on_beat_game():
	
	Events.emit_signal("game_end")
	get_tree().paused = true
	$Camera.current = true
	$AnimationPlayer.play("BeatGame")

func activate_text():
	
	$Camera/Control/RichTextLabel.visible = true

func activate_text2():
	$Camera/Control/Text2.visible = true
	
func finished_anim():
	
	Saving.save_game()
	get_tree().change_scene_to(main_menu)
	get_tree().paused = false
	#get_parent().queue_free()
	
