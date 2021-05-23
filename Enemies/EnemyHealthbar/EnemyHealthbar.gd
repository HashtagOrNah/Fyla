extends Spatial

onready var health_bar = $Viewport/TextureProgress

var bar_max_hp setget _set_max_hp
var bar_hp setget _set_hp

func _set_max_hp(amount):
	health_bar.max_value = amount
	
func _set_hp(amount):
	health_bar.value += amount


	
