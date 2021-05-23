extends Spatial

onready var popup = $Popup

var player_collision = false

func _on_PlayerScanner_body_entered(body):
	
	player_collision = true
	popup.visible = true


func _on_PlayerScanner_body_exited(body):
	
	player_collision = false
	popup.visible = false
	
func _input(event):
	
	if event.is_action_pressed("interact") and player_collision:
		Events.emit_signal("warp_new_map")
