extends Spatial

var blast : int
var gems_spawned : int

# Called when the node enters the scene tree for the first time.
func _ready():
	
	yield(get_tree().create_timer(0.5), "timeout")
	Events.emit_signal("cam_shake")
	Events.emit_signal("bomb_exploded", global_transform.origin, blast, gems_spawned)
	self.queue_free()
