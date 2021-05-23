extends Area

var DMG = 50

func _on_Blades_body_entered(body):
	Events.emit_signal("player_damaged", DMG)
