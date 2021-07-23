extends Control

var profile_name_list : Array = []
var title_screen = load("res://MainMenu/MainMenu.tscn")
var hub_world = load("res://Map Setup/HubWorld.tscn")
var player = load("res://Player/Player.tscn")
var dir_path = Saving.save_dir_path

onready var name_enter = get_node("MainMargins/MarginFit/MainContent/ButtonMargins/Buttons And Map/NewProfile/MarginContainer/VBoxContainer/LineEdit")
onready var char_list = get_node("MainMargins/MarginFit/MainContent/ButtonMargins/Buttons And Map/MainMenuButtons/MarginContainer/ProfileList")
onready var display_info = get_node("MainMargins/MarginFit/MainContent/ButtonMargins/Buttons And Map/Profile Details/MarginContainer/VBoxContainer/ProfileContent")

var no_profile_selected_text = "[center][wave]No profile selected :("
var profile_count = 0
var last_selected = 0

var new_profile = {
	"profile_name" : "",
	"last_save" : "N/A",
	"gem_count" : 0,
	"gem_mult_curr" : 1,
	"speed" : 10,
	"blast_radius_curr" : 1,
	"map_size_curr" : 10,
	"save_type" : "player",
	"gems_spawned" : 1,
	"beat_game" : 0
}

func _ready():

	char_list.add_item("Profiles Found: " + str(profile_count), null, false)
	
	var dir = Directory.new()
	if dir.open(dir_path) == OK:
		dir.list_dir_begin(true,true)
		var file_name = dir.get_next()
		
		while file_name != "":
			
			profile_count += 1
			var file = File.new()
			file.open(dir_path + file_name, File.READ)
			var data = parse_json(file.get_line())
			file.close()
			char_list.add_item(data.profile_name)
			char_list.set_item_metadata(profile_count, data)
			profile_name_list.append(data.profile_name)
			
			char_list.set_item_text(0, "Profiles Found: " + str(profile_count))
			
			file_name = dir.get_next()
		
		dir.list_dir_end()

func _on_BackButton_pressed():
	get_tree().change_scene_to(title_screen)

# Creates a brand new profile with default values
func _on_CreateProfile_pressed():
	
	if name_enter.text.length() != 0 and !profile_name_list.has(name_enter.text):
		char_list.add_item(name_enter.text)
		profile_count += 1
		var default_profile = new_profile.duplicate()
		default_profile["profile_name"] = name_enter.text
		char_list.set_item_metadata(profile_count, default_profile)

		profile_name_list.append(name_enter.text)
		char_list.set_item_text(0, "Profiles Found: " + str(profile_count))

		var file = File.new()
		file.open(dir_path + name_enter.text + ".save", File.WRITE)
		file.store_line(to_json(default_profile))
		file.close()

# Removes profile from save file
func _on_RemoveProfile_pressed():
	
	if char_list.get_selected_items().size() > 0:
		var selected_item = char_list.get_selected_items()[0]
		var dir = Directory.new()
		dir.open(dir_path)
		profile_name_list.erase(char_list.get_item_text(selected_item))
		dir.remove(char_list.get_item_text(selected_item) + ".save")
		
		char_list.remove_item(selected_item)
		profile_count -= 1
		char_list.set_item_text(0, "Profiles Found: " + str(profile_count))
		
		last_selected = 0
		set_info_text(null)

# This will handle deselecting a profile
func _on_ProfileList_item_selected(index):
	
	if char_list.get_item_count() == 0:
		return

	if index == last_selected:
		char_list.unselect_all()
		set_info_text(null)
		last_selected = 0
	else:
		last_selected = index
		set_info_text(index)
		
func set_info_text(index):
	
	if index == null or index == 0:
		display_info.bbcode_text = no_profile_selected_text
		return

	var data = char_list.get_item_metadata(index)
	
	var text_string = "Beat the Game: %s %s\nGem Count: %s\nSpeed: %s\nBlast: %s\nMap Size: %s\nGem Multi: %s\nGems Spawned: %s\n\n[center]Last Save\nDate: %s\nTime: %s[/center]"
	
	var ng = ""
	var won = "No :("
	var date = "[tornado]N/A[/tornado]"
	var time = "[wave]N/A[/wave]"
	if typeof(data.last_save) == TYPE_DICTIONARY:
		date = str(data.last_save.month) + "/" + str(data.last_save.day) + "/" + str(data.last_save.year)
		# Just some simple time formatting stuff
		time = ":"
		if data.last_save.minute < 10:
			time = time + "0" + str(data.last_save.minute)
		else:
			time = time + str(data.last_save.minute)
		if data.last_save.hour > 12:
			time = str(data.last_save.hour-12) + time + " PM"
		else:
			time = str(data.last_save.hour) + time + " AM"
		
		if data.beat_game >= 1:
			ng = "NG+%s" % [data.beat_game]
			won = "[rainbow]Yes!!![/rainbow]"
		
	text_string = text_string % [won, ng, data.gem_count, data.speed, data.blast_radius_curr, data.map_size_curr, data.gem_mult_curr, data.gems_spawned, date, time] #data.get("last_save")]
	display_info.bbcode_text = text_string


func _on_PlayGame_pressed():
	
	if char_list.get_selected_items().size() == 0:
		return

	var profile_data = char_list.get_item_metadata(char_list.get_selected_items()[0])
	Saving.current_profile = profile_data.profile_name
	
	get_tree().change_scene_to(hub_world)
	self.queue_free()
