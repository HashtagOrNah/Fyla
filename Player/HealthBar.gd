extends ProgressBar

onready var hp_text = $HPText

func _on_HealthBar_mouse_entered():
#	percent_visible = false
	hp_text.append_bbcode("[center]" + str(value) + "/" + str(max_value) + "[/center]")

func _on_HealthBar_mouse_exited():
#	percent_visible = true
	hp_text.text = ""
