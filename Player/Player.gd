extends KinematicBody

onready var camera = $CameraPos/Camera
onready var cam_pos = $CameraPos
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

# PLAYER SHOP STATS

var gem_mult_cost = 10
var gem_mult_curr = 1

var blast_radius_cost = 50
var blast_radius_curr = 1

var map_size_cost = 10
var map_size_curr = 10

var speed = 10
var speed_cost = 5

var gems_spawned = 1
var gems_spawned_cost = 10

# PLAYER RESOURCES
var beat_game = 0
var gem_count = 0 setget _set_gem_count

# CAM SHAKE

var cam_shaking : float = 0.0
var shake_time : float = 1.0
var amplitude = 0.2
# PLAYER STATS

export var accel = 15
var gravity = 20


var zoom = 0
var velocity = Vector3()
var direction = Vector3()
var last_look = Vector3()

func _ready():
	
	UI._ready()
	
	cam_pos.set_as_toplevel(true)
	
	Events.connect("cam_shake", self, "_on_cam_shake")
	Events.connect("game_end", self, "_on_game_end")
	Events.connect("gem_collected", self, "_on_gem_collected")
	Events.connect("player_damaged", self, "_on_player_damaged")
	
func _physics_process(delta):
	
	camera_follow_player()
	look_at_cursor(delta)
	
	velocity = velocity.linear_interpolate(direction.normalized() * speed, accel * delta)
	velocity.y += -gravity
	if gravity != 0:
		gravity -= 10
	velocity = move_and_slide(velocity, Vector3.UP)
	
	if cam_shaking:
		print(cam_shaking)
		cam_shaking = cam_shaking - shake_time*delta
		var h = rand_range(amplitude, -amplitude)
		var v = rand_range(amplitude, -amplitude)
		var zoom = rand_range(58, 64)
		camera.fov = floor(zoom)
		camera.h_offset = h
		camera.v_offset = v
		if cam_shaking <= 0:
			cam_shaking = 0.0
			camera.h_offset = 0
			camera.v_offset = 0
			camera.fov = 60.5
		
		#camera.h_offset = (0.1*cam_shaking) * amplitude

func _on_cam_shake():

	if !cam_shaking:
		cam_shaking = 0.2
	
func _on_gem_collected(value):
	_set_gem_count(value*gem_mult_curr)

func _set_gem_count(value):
	UI.gem_count = value
	gem_count += value
	
func _input(event):
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP and zoom > 0:
				camera.translate_object_local(camera.get_transform().basis.xform(Vector3(0,5,0)))
				zoom -= 1
			elif event.button_index==BUTTON_WHEEL_DOWN and zoom < 5:
				camera.translate_object_local(camera.get_transform().basis.xform(Vector3(0,-5,0)))
				zoom += 1
		
	if Input.is_action_pressed("drop_bomb"):
		Events.emit_signal("bomb_dropped", player_pos.global_transform.origin, blast_radius_curr, gems_spawned)
	
	if Input.is_action_pressed("hubwarp"):
		Events.emit_signal("warp_hub")
	
	if Input.is_action_pressed("test"):
		Events.emit_signal("cam_shake")
	
	direction.z = -(Input.get_action_strength("forward") - Input.get_action_strength("backward"))
	direction.x = -(Input.get_action_strength("left") - Input.get_action_strength("right"))
	
func camera_follow_player():
	var player_pos = global_transform.origin
	cam_pos.global_transform.origin = player_pos
		
func look_at_cursor(delta):
	
	var mouse_pos = get_viewport().get_mouse_position()
	var viewport_size = get_viewport().size
	viewport_size = Vector2(viewport_size.x/2, viewport_size.y/2)

	mouse_pos = Vector3(mouse_pos.x-viewport_size.x, translation.y, mouse_pos.y-viewport_size.y)
	var adjusted_pos = last_look.linear_interpolate(mouse_pos, 10 * delta)
	look_at(adjusted_pos, Vector3.UP)
	last_look = adjusted_pos

func _on_game_end():
	
	$Control.visible = false

func save():
	var save_dict = {
		"save_type" : "player",
		"profile_name" : profile_name,
		"gem_count" : gem_count,
		"last_save" : OS.get_datetime(),
		"map_size_curr" : map_size_curr,
		"map_size_cost" : map_size_cost,
		"gem_mult_cost" : gem_mult_cost,
		"gem_mult_curr" : gem_mult_curr,
		"blast_radius_cost" : blast_radius_cost,
		"blast_radius_curr" : blast_radius_curr,
		"speed" : speed,
		"speed_cost" : speed_cost,
		"gems_spawned" : gems_spawned,
		"gems_spawned_cost" : gems_spawned_cost,
		"beat_game" : beat_game
	}
	return save_dict
