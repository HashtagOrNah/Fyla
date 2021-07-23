extends RigidBody

onready var gem = $CollisionShape/Gem2
onready var rng = RandomNumberGenerator.new()
var gem_mat
var int_rate
export var blue = false
export var green = false

func _ready():
	
	rng.randomize()
	gem_mat = gem.get_surface_material(0)
	int_rate = rng.randf_range(0.05,0.1)/2
	
func _process(delta):
	
	gem_mat.emission_energy += int_rate
	if gem_mat.emission_energy <= 0 or gem_mat.emission_energy >= 3:
		int_rate = int_rate * -1

func _on_Area_body_entered(body):
	
	if !blue and !green:
		Events.emit_signal("gem_collected", 5)
	elif blue:
		Events.emit_signal("gem_collected", 10)
	else:
		Events.emit_signal("gem_collected", 15)
	self.queue_free()
