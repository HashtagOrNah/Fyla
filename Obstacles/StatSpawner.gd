extends Node

export var spawn_interval = 5
onready var item_spawned = load("res://Pickups/StatPickup.tscn")
onready var pos = $Position3D

var child_up = false

func _physics_process(delta):
	
	if not child_up:
		var newIns = item_spawned.instance()
		add_child(newIns)
		newIns.global_transform.origin = pos.global_transform.origin
		child_up = true
