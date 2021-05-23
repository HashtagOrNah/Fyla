extends Room

var rng = RandomNumberGenerator.new()

enum {GRASS, ROCK, P_SPAWN, P_EXIT}
enum min_max {MIN, MAX}

var player_spawn_room : Room
var exit_location : Vector2

var width = 50
var height = 50

var room_count = 0

var max_room_width = 10
var max_room_height = 10

var min_room_width = 5
var min_room_height = 5

var corridor_width = 3

var TEST = false

func _ready():
	
	if TEST:
		gen_random_map(width, height, 0)
		
func _input(event):

	if event.is_action_pressed("backward"):
		gen_random_map(width, height, 0)
	
func gen_random_map(map_width, map_height, r_seed):
	
	clear()
	if r_seed == 0:
		rng.randomize()
	else:
		rng.seed = r_seed
	width = map_width
	height = map_height
	init_terrain_gen()
	if room_count == 0:
		room_count = floor(sqrt(width+height))*2
	var rooms = gen_room_points()

	draw_rooms(rooms)
	create_path(rooms)
	pick_player_spawn(rooms)
	farthest_from_spawn(rooms)
	
func farthest_from_spawn(rooms):
	
#	var far_room = player_spawn_room
	var far_room = calculate_room_distance(player_spawn_room, rooms, min_max.MAX, 1)
	exit_location = far_room.center
	
	if far_room.center == player_spawn_room.center:
		set_cell(far_room.center.x+1, far_room.center.y, P_EXIT)
		return
	set_cellv(far_room.center, P_EXIT)

# Initialize all the grass for the given width and height
func init_terrain_gen():
	
	for x in range(width):
		for y in range(height):
			
			set_cell(x,y, ROCK)

# Calculates a list of vector2's within the height
# and width for the number given: room_num
func gen_room_points():
	
	var rooms_arr = []

	for _i in range(room_count):
		var x = rng.randi_range(1, width-min_room_width)
		var y = rng.randi_range(1,height-min_room_height)
		
		var new_room = Room.new()
		new_room.tile_map_pos = Vector2(x,y)
		new_room.dimensions = gen_room(new_room.tile_map_pos)
#		print("Dimensions: ", new_room.dimensions)
		rooms_arr.append(new_room)
		
	return rooms_arr

# Draw the rooms from the vector2 room points
func gen_room(room):
	
	var rand_width = rng.randi_range(min_room_width, max_room_width)
	if rand_width + room.x > width-1:
		rand_width = width-room.x-2
	
	var rand_height = rng.randi_range(min_room_height, max_room_height)
	if rand_height + room.y > height-1:
		rand_height = height-room.y-2

	return Vector2(rand_width,rand_height)
#		draw_room(rand_width, rand_height, room)

func pick_player_spawn(rooms):
	
	var index = rng.randi_range(0, rooms.size()-1)
	var room = rooms[index].center
	player_spawn_room = rooms[index]
	set_cellv(room, P_SPAWN)
	
# draws the room onto a tilemap with the given width and height
func draw_rooms(rooms):
	
	for room in rooms:
		for x in room.dimensions.x:
			for y in room.dimensions.y:
				
				set_cell(x+room.tile_map_pos.x,y+room.tile_map_pos.y,GRASS)
			
# Draws a path onto the tilemap between two room points
func create_path(rooms):

	var room = rooms[0]
	var room_num = 0
	while true:
		room.connected = true
		var closest_room = calculate_room_distance(room, rooms, min_max.MIN, 0)
		draw_path(room.center, closest_room.center)
		room = closest_room
		room_num += 1
		if room_num == rooms.size()-1:
			return
		
func draw_path(room1, room2):
	
	var dis_height = abs(room1.y - room2.y)+2
	var dis_width = abs(room1.x - room2.x)+2
	var down = -1
	var right = -1
	
	if room1.x > room2.x:
		right = 1
	if room2.y > room1.y:
		down = 1
		
	for x in dis_width:
		set_cell((x*right)+room2.x,room2.y, GRASS)
		set_cell((x*right)+room2.x,room2.y+(1*down), GRASS)
		set_cell((x*right)+room2.x,room2.y+(2*down), GRASS)
	for y in dis_height:
		set_cell(room1.x, (y*down)+room1.y, GRASS)
		set_cell(room1.x+(1*right), (y*down)+room1.y, GRASS)
		set_cell(room1.x+(2*right), (y*down)+room1.y, GRASS)
		
func calculate_room_distance(curr_room : Room, rooms, type, ignore_connected) -> Room:
	var dis_scores = []
	for room in rooms:
		if not room.connected or ignore_connected:
			dis_scores.append(curr_room.center.distance_to(room.center))
		else:
			if type:
				dis_scores.append(0)
			else:
				dis_scores.append(1000)
		
	if not type:
		return rooms[dis_scores.find(dis_scores.min(), 0)]
	else:
		return rooms[dis_scores.find(dis_scores.max(), 0)]
