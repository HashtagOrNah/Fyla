extends GridFunctions

var MAP = load("res://MapGen/TileMapGen.tscn")
var new_map
var r_seed = 0

var width : int
var height : int

var grass_tiles
var rock_tiles
var player_spawn

var TEST = false
# Called when the node enters the scene tree for the first time.
func _ready():
	
	if TEST:
		new_map = MAP.instance()
		new_map.gen_random_map(width, height, r_seed)
		tile_to_grid(new_map)
	
func _input(event):
	
	if event.is_action_pressed("test"):
		for i in get_children():
			i.free()
		clear()
		TEST = true
		_ready()

func _on_warp_new_map():
	Saving.save_game()
	for i in get_children():
		if i.name == "ReturnMenu" or i.name == "WorldEnv":
			continue
		i.queue_free()
	clear()
	new_map = MAP.instance()
	new_map.gen_random_map(width, height, r_seed)
	tile_to_grid(new_map)

func tile_to_grid(tile_map):
	
	width = tile_map.width
	height = tile_map.height
	r_seed = tile_map.rng.seed
	rng.seed = r_seed

	draw_edge()

	grass_tiles = tile_map.get_used_cells_by_id(tile_map.GRASS)
	rock_tiles = tile_map.get_used_cells_by_id(tile_map.ROCK)


	draw_tile_group(grass_tiles, 0, GRASS)
	draw_tile_group(rock_tiles, 1, ROCK)
	player_spawn_pos = draw_tile(tile_map.player_spawn_room.center, 0, P_SPAWN)
	exit_pos = draw_tile(tile_map.exit_location, 0, P_EXIT)

	spawn_player(player_spawn_pos)
	spawn_exit(exit_pos)

func draw_edge():

	for x in range(width+2):
		for z in range(height+2):
			set_cell_item(x-1, 1, height, UNBREAKABLE)
			set_cell_item(width, 1, z-1, UNBREAKABLE)
			set_cell_item(-1, 1, z-1, UNBREAKABLE)
			set_cell_item(x-1, 1, -1, UNBREAKABLE)
			
func draw_tile(pos : Vector2, cell_height, tile_type) -> Vector3:
	
	set_cell_item(pos.x, cell_height, pos.y, tile_type)
	return Vector3(pos.x, cell_height, pos.y)

func draw_tile_group(pos_arr, height, tile_type):
	
	for cell_pos in pos_arr:
		
		if tile_type == ROCK:
			set_cell_item(cell_pos.x, height - 1, cell_pos.y, GRASS)
			
			if rng.randi_range(1,50) == 1:
				set_cell_item(cell_pos.x, height, cell_pos.y, CRYSTAL)
				continue
		
		set_cell_item(cell_pos.x, height, cell_pos.y, tile_type)
