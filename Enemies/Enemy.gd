extends KinematicBody

onready var health_bar = $Healthbar

export onready var max_hp = 123 setget _set_max_hp
onready var hp = 0 setget _set_hp

# USED WITH NAV 
var path = []
var path_ind = 0
const speed = 10
const gravity = Vector3.DOWN * 100
#onready var nav = get_parent().get_parent().get_parent()

var colliding = false
var target = null

func _ready():
	
	_set_max_hp(max_hp)
	_set_hp(max_hp)
	
	Events.connect("enemy_damaged", self, "_on_enemy_damaged")
	
func _on_enemy_damaged(amount, body):
	if body == self:
		_set_hp(-amount)
	
func _set_max_hp(amount):
	max_hp = amount
	health_bar._set_max_hp(amount)
	
func _set_hp(amount):
	hp += amount
	health_bar._set_hp(amount)
	if hp <= 0:
		self.queue_free()

func move_to(target_pos):
#	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_ind = 0
	
func _physics_process(delta):
	
	if colliding:
		var target_pos = target.global_transform.origin
		target_pos.y = 0
		look_at(target_pos, Vector3.UP)
		var motion = -global_transform.basis.z * speed + gravity
		move_and_slide(motion, Vector3.UP)

#	if colliding:
#		var init_pos = global_transform.origin
#		var target_pos = target.global_transform.origin
#		target_pos.y = 0
#		path = nav.get_simple_path(global_transform.origin, target_pos)
#		path_ind = 0
#		#move_to(target.global_transform.origin)
#
#		var move_dis = speed * delta
#
#		for point in range(path.size()):
#			var dis_to_next_point = init_pos.distance_to(path[0])
#			if move_dis <= dis_to_next_point:
#				look_at(target_pos, Vector3.UP)
#				var motion = -global_transform.basis.z * speed
#				move_and_slide(motion, Vector3.UP)
#				break
#			move_dis -= dis_to_next_point
#			init_pos = path[0]
#			path.remove(0)
		
	
#	if path_ind < path.size():
#		var move_vec = (path[path_ind] - global_transform.origin)
#		if move_vec.length() < 0.1:
#			path_ind += 1
#		else:
#			move_and_slide((move_vec.normalized() * move_speed), Vector3(0,1,0))

func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		target = body
		colliding = true
		#move_to(body.global_transform.origin)


func _on_Area_body_exited(body):
	if body.is_in_group("player"):
		colliding = false
		#move_to(body.global_transform.origin)	
