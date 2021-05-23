class_name GridFunctions
extends GridMap

onready var enemy = load("res://Enemies/Enemy.tscn")
onready var player = load("res://Player/Player.tscn")
onready var bomb = load("res://Abilities/Drop Bomb/Bomb.tscn")
onready var exit = load("res://Obstacles/Exit Portal/ExitPortal.tscn")
onready var gem = load("res://Abilities/Gem/Gem.tscn")

onready var return_menu = $ReturnMenu

enum {GRASS, ROCK, P_SPAWN, USED, CRYSTAL, UNBREAKABLE, P_EXIT}

var player_spawn_pos = Vector3()
var exit_pos

var rng = RandomNumberGenerator.new()
var player_node : Object

func _ready():

	Events.connect("bomb_dropped", self, "_on_bomb_dropped")
	Events.connect("bomb_exploded", self, "_on_bomb_exploded")
	Events.connect("warp_new_map", self, "_on_warp_new_map")
	
func _input(event):
	
	if event.is_action_pressed("pause"):
		return_menu.visible = true

func _on_warp_new_map():
	pass
	
func _on_bomb_exploded(bomb_pos):
	
	var map_pos = world_to_map(bomb_pos)
	set_cell_item(map_pos.x, 1, map_pos.z, -1)
	var pos_x = map_pos.x-1
	var pos_z = map_pos.z-1
	for x in 3:
		for z in 3:
			var temp_x = pos_x
			var temp_z = pos_z
			break_block(temp_x+x, 1, temp_z+z)

func _on_bomb_dropped(player_pos):
	
	var new_pos = world_to_map(player_pos)
	if get_cell_item(new_pos.x, new_pos.y, new_pos.z) == USED:
		return
	var new_bomb = bomb.instance()
	set_cell_item(new_pos.x, new_pos.y, new_pos.z, USED)
	new_bomb.translation = map_to_world(new_pos.x, 1, new_pos.z)
	add_child(new_bomb)
	
func break_block(x,y,z):
	
	var cell_type = get_cell_item(x,y,z)
	
	if cell_type != UNBREAKABLE and cell_type != USED:
		set_cell_item(x, y, z, -1) 
		
		if cell_type == CRYSTAL:
			var rand_amount = rng.randi_range(1,5)
			for _i in rand_amount:
				var inst = spawn_instance(Vector3(x,y-1,z), gem)
				var z_impulse = rng.randi_range(-10,10)
				var x_impulse = rng.randi_range(-10,10)
				inst.apply_central_impulse(Vector3(x_impulse,0,z_impulse))
			
func grab_player_spawn():

	return get_used_cells_by_id(P_SPAWN)[0]

# Instance the player
func spawn_player(cell_pos : Vector3):
	
	var player_inst = spawn_instance(cell_pos, player)
	Saving.load_player_data(player_inst)
	player_node = player_inst
	
# Instance the exit portal
func spawn_exit(cell_pos : Vector3):
	
	spawn_instance(cell_pos, exit)

# Given a cell position and the loaded scene, it will instance the object there
func spawn_instance(cell_pos : Vector3, inst_type):
	
	var inst = inst_type.instance()
	var cellPos = cell_pos
	if inst_type != gem:
		set_cell_item(cellPos.x, cellPos.y+1, cellPos.z, USED)
	cellPos = map_to_world(cellPos.x, cellPos.y+1, cellPos.z)
	inst.translation = cellPos
	add_child(inst)
	return inst

# returns an array of the cell positions of the given cell type
func get_used_cells_by_id(id):
	
	var arr = []
	var cells = get_used_cells()
	
	for i in cells:
		if(get_cell_item(i.x,i.y,i.z) == id):
			arr.append(i)
			
	return arr
