extends GridMap

onready var player = load("res://Player/Player.tscn")
var gem = load("res://Abilities/Gem/Gem.tscn")

var tile_map = load("res://MapGen/TileMapGen.tscn")
var empty_map = load("res://Map Setup/EmptyMap.tscn")

onready var return_menu = $ReturnMenu
onready var portal_tooltip = $Portal/Popup

enum {CRYSTAL, VINE, WALL, EXIT, GRASS, P_SPAWN}

var player_spawn_pos = Vector3()
var exit_pos
var is_in_exit = false
var player_node : Object

var rng = RandomNumberGenerator.new()

func _ready():

	player_spawn_pos = grab_player_spawn()
	spawn_player()
	
	
func _input(event):
	
	if event.is_action_pressed("pause"):
		return_menu.visible = true
		
	if event.is_action_pressed("interact") and is_in_exit:
		warp_new_map()
		
func warp_new_map():
	Saving.save_game()
	
	var gen_map = tile_map.instance()
	gen_map.gen_random_map(player_node.map_width, player_node.map_height, 0)
	
	var grid_map = empty_map.instance()
	get_tree().get_root().add_child(grid_map)
	get_tree().change_scene_to(grid_map)
	grid_map.tile_to_grid(gen_map)

# Returns the cell pos of the spawn point
func grab_player_spawn():
	return get_used_cells_by_id(P_SPAWN)[0]

# Instance the player
func spawn_player():
	
	var inst = player.instance()
	var cellPos = player_spawn_pos
	cellPos = map_to_world(cellPos.x, cellPos.y+1, cellPos.z)
	inst.translation = cellPos
	add_child(inst)
	Saving.load_player_data(inst)
	player_node = inst
	
# returns an array of the cell positions of the given cell type
func get_used_cells_by_id(id):
	
	var arr = []
	var cells = get_used_cells()
	
	for i in cells:
		if(get_cell_item(i.x,i.y,i.z) == id):
			arr.append(i)
			
	return arr

func _on_Portal_body_entered(body):
	is_in_exit = true
	portal_tooltip.visible = true
	
func _on_Portal_body_exited(body):
	is_in_exit = false
	portal_tooltip.visible = false
