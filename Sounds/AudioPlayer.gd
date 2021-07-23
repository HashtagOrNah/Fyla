extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	Events.connect("gem_collected", self, "_on_gem_collected")
	Events.connect("toggle_audio", self, "_on_toggle_audio")

func _on_gem_collected(_value):
	$Gem.play()
	
func _on_toggle_audio():
	$AudioStreamPlayer.playing = !$AudioStreamPlayer.playing

