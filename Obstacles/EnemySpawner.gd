extends Node

export var spawn_interval = 5
onready var item_spawned = load("res://Enemies/Enemy.tscn")
onready var pos = $Position3D
onready var timer = $Timer

var enemy_count = 0

func _physics_process(delta):
	
	enemy_count = get_child_count() - 3
	
	if enemy_count < 20 and timer.is_stopped():
		enemy_count += 1
		var newIns = item_spawned.instance()
		add_child(newIns)
		newIns.global_transform.origin = pos.global_transform.origin
		timer.start()
