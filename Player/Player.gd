extends KinematicBody

onready var camera = $CameraPos/Camera
onready var cam_pos = $CameraPos
onready var health_bar = $Control/HealthBar
onready var anim_player = $AnimationPlayer
onready var attack_hitbox = $Attack/CollisionShape
onready var player_pos = $PlayerCenter
onready var UI = $Control

enum {
	IDLE,
	MOVING,
	ATTACKING,
}
# PLAYER NAME
var profile_name : String = "test"
var last_save 

# PLAYER RESOURCES
var gem_count = 0 setget _on_gem_collected

# PLAYER STATS
var map_width = 10
var map_height = 10

export var speed = 10
export var damage = 30
export var max_hp = 135 setget _set_max_hp
var hp = max_hp setget _set_hp

var velocity = Vector3()
var direction = Vector3()

var wait_time = 60

func _ready():
	
	UI._ready()
	
	cam_pos.set_as_toplevel(true)
	
	Events.connect("gem_collected", self, "_on_gem_collected")
	Events.connect("player_damaged", self, "_on_player_damaged")
	
	_set_hp(max_hp)
	_set_max_hp(max_hp)
func _physics_process(delta):
	
	camera_follow_player()
	look_at_cursor()

	velocity = Vector3.ZERO
	velocity = (direction.normalized() * speed)

	velocity = move_and_slide(velocity, Vector3.UP)
	
func _on_gem_collected(value):
	UI.gem_count = value
	gem_count += value
	
func _on_player_damaged(damage):
	_set_hp(-damage)

func _set_max_hp(amount):
	max_hp = amount
	health_bar.max_value = amount
	
func _set_hp(amount):
	hp = amount
	health_bar.value = amount
	
func _input(event):
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				camera.translate_object_local(camera.get_transform().basis.xform(Vector3(0,5,0)))
			elif event.button_index==BUTTON_WHEEL_DOWN:
				camera.translate_object_local(camera.get_transform().basis.xform(Vector3(0,-5,0)))
		
	if Input.is_action_pressed("drop_bomb"):
		Events.emit_signal("bomb_dropped", player_pos.global_transform.origin)
	
	if Input.is_action_just_pressed("test"):
		health_bar.value -= 10
	
	direction.z = -(Input.get_action_strength("forward") - Input.get_action_strength("backward"))
	direction.x = -(Input.get_action_strength("left") - Input.get_action_strength("right"))
	
func camera_follow_player():
	var player_pos = global_transform.origin
	cam_pos.global_transform.origin = player_pos
		
func look_at_cursor():
	
	var mouse_pos = get_viewport().get_mouse_position()
	var viewport_size = get_viewport().size
	viewport_size = Vector2(viewport_size.x/2, viewport_size.y/2)

	mouse_pos = Vector3(mouse_pos.x-viewport_size.x, translation.y, mouse_pos.y-viewport_size.y)

	look_at(mouse_pos, Vector3.UP)

func _on_Sword_body_entered(body):
	Events.emit_signal("enemy_damaged", damage, body)

func _on_AnimationPlayer_animation_finished(anim_name):
	
	match anim_name:
		"Attack":
			attack_hitbox.disabled = true
			
func save():
	var save_dict = {
		"save_type" : "player",
		"profile_name" : profile_name,
		"gem_count" : gem_count,
		"last_save" : OS.get_datetime(),
		"map_width" : map_width,
		"map_height" : map_height
	}
	return save_dict
