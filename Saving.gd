extends Node

var save_dir_path : String  = "C:\\Users\\onewa\\Desktop\\Fyla Saves\\"

var current_profile : String = "test"

func save_game():
	
	var current_path = save_dir_path + current_profile + ".save"
	var save_game = File.new()
	
	save_game.open(current_path, File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# Store the save dictionary as a new line in the save file.
		save_game.store_line(to_json(node_data))
	save_game.close()

func load_player_data(player_node):
	
	var current_path = save_dir_path + current_profile + ".save"
	var player_save = File.new()
	if not player_save.file_exists(current_path):
		return # Error! We don't have a save to load.

	player_save.open(current_path, File.READ)
	
	while player_save.get_position() < player_save.get_len():
		
		var node_data = parse_json(player_save.get_line())
		
		for data in node_data.keys():
			player_node.set(data, node_data[data])

func load_game():
	var current_path = save_dir_path + current_profile + ".save"
	var save_game = File.new()
	if not save_game.file_exists(current_path):
		return # Error! We don't have a save to load.

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open("user://savegame.save", File.READ)
	while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_game.get_line())

		# Now we set the remaining variables.
#		for i in node_data.keys():
#			new_object.set(i, node_data[i])

	save_game.close()
