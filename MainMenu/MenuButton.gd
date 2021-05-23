extends Button

onready var audio = $AudioStreamPlayer

func _on_Button_mouse_entered():
	
	audio.play(0)
