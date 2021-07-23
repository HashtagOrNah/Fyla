class_name GridFunctions
extends GridMap

export var player : PackedScene
export var bomb : PackedScene
export var exit : PackedScene
export var gem : PackedScene
export var gem_blue : PackedScene
export var gem_green : PackedScene
export var hub : PackedScene

export var test : bool

onready var return_menu = $ReturnMenu

enum {GRASS, ROCK, P_SPAWN, USED, CRYSTAL, UNBREAKABLE, P_EXIT, CRYSTAL_GREEN, CRYSTAL_BLUE}

var player_spawn_pos = Vector3()
var exit_pos

var rng = RandomNumberGenerator.new()
var player_node : Object

func _ready():
	
	if test:
		spawn_player(grab_player_spawn())

	Events.connect("bomb_dropped", self, "_on_bomb_dropped")
	Events.connect("bomb_exploded", self, "_on_bomb_exploded")
	Events.connect("warp_new_map", self, "_on_warp_new_map")
	Events.connect("warp_hub", self, "_on_warp_hub")
	
func _input(event):
	
	if event.is_action_pressed("pause"):
		return_menu.visible = !return_menu.visible

func _on_warp_new_map():
	pass

func _on_warp_hub():
	pass
	
func _on_bomb_exploded(bomb_pos, blast, gems_spawned):
	
	var map_pos = world_to_map(bomb_pos)
	set_cell_item(map_pos.x, 1, map_pos.z, -1)
	var pos_x = map_pos.x-blast
	var pos_z = map_pos.z-blast
	var radius = blast*2 + 1
	for x in radius:
		for z in radius:
			var temp_x = pos_x
			var temp_z = pos_z
			break_block(temp_x+x, 1, temp_z+z, gems_spawned)

func _on_bomb_dropped(player_pos, blast, gems_spawned):
	
	var new_pos = world_to_map(player_pos)
	if get_cell_item(new_pos.x, new_pos.y, new_pos.z) == USED:
		return
	var new_bomb = bomb.instance()
	set_cell_item(new_pos.x, new_pos.y, new_pos.z, USED)
	new_bomb.translation = map_to_world(new_pos.x, 1, new_pos.z)
	new_bomb.blast = blast
	new_bomb.gems_spawned = gems_spawned
	add_child(new_bomb)
	
func break_block(x,y,z, gems_spawned = 0):
	
	var cell_type = get_cell_item(x,y,z)
	
	if cell_type != UNBREAKABLE and cell_type != USED:
		set_cell_item(x, y, z, -1) 

		if cell_type == CRYSTAL:
			for _i in gems_spawned:
				var inst = spawn_instance(Vector3(x,y-1,z), gem)
				var z_impulse = rng.randi_range(-10,10)
				var x_impulse = rng.randi_range(-10,10)
				inst.apply_central_impulse(Vector3(x_impulse,0,z_impulse))
		elif cell_type == CRYSTAL_BLUE:
			for _i in gems_spawned:
				var inst = spawn_instance(Vector3(x,y-1,z), gem_blue)
				var z_impulse = rng.randi_range(-10,10)
				var x_impulse = rng.randi_range(-10,10)
				inst.apply_central_impulse(Vector3(x_impulse,0,z_impulse))
		elif cell_type == CRYSTAL_GREEN:
			for _i in gems_spawned:
				var inst = spawn_instance(Vector3(x,y-1,z), gem_green)
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
	if inst_type != gem and inst_type != gem_blue and inst_type != gem_green:
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
