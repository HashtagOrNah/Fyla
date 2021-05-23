extends Control

onready var gem_count_text = $MarginContainer/HBoxContainer/Right/HBoxContainer/Right/GridContainer/Gem/Label

var gem_count = 0 setget _set_gem_count

func _set_gem_count(value):
	
	gem_count += value
	gem_count_text.text = String(gem_count)
