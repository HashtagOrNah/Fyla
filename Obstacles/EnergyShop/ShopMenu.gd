extends Control


onready var gem_cost = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/ButtonHolder/Cost/Cost1
onready var speed_cost = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/ButtonHolder/Cost/Cost2
onready var blast_cost = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/ButtonHolder/Cost/Cost3
onready var map_cost = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/ButtonHolder/Cost/Cost4
onready var gems_spawned_cost = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/ButtonHolder/Cost/Cost5

onready var gem_tier = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/ButtonHolder/Tier/Tier1
onready var speed_tier = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/ButtonHolder/Tier/Tier2
onready var blast_tier = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/ButtonHolder/Tier/Tier3
onready var map_tier = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/ButtonHolder/Tier/Tier4
onready var gems_spawned_tier = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/ButtonHolder/Tier/Tier5

onready var win_button = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/MarginContainer/WinButton
var P = null

func _on_Button_pressed():
	visible = false


func _on_WinButton_pressed():
	if P.gem_count >= 1000000*(P.beat_game+1):
		Events.emit_signal("beat_game")
		P.gem_count = -1000000*(P.beat_game+1)
		P.beat_game += 1

func set_stats(player = null):
	
	if P == null:
		P = player
	gem_cost.text = String(P.gem_mult_cost)
	gem_tier.text = String(P.gem_mult_curr)
	speed_cost.text = String(P.speed_cost)
	speed_tier.text = String(P.speed)
	blast_cost.text = String(P.blast_radius_cost)
	blast_tier.text = String(P.blast_radius_curr)
	map_cost.text = String(P.map_size_cost)
	map_tier.text = String(P.map_size_curr)
	gems_spawned_cost.text = String(P.gems_spawned_cost)
	gems_spawned_tier.text = String(P.gems_spawned)
	
	var win_text = "Beat the game: %s,000,000" % (P.beat_game+1)
	win_button.text = win_text
	
func _on_GemMult_pressed():
	if P.gem_count >= P.gem_mult_cost:
		P.gem_count = -P.gem_mult_cost
		P.gem_mult_curr += 3
		P.gem_mult_cost = P.gem_mult_cost*3
		set_stats()

func _on_SpeedUp_pressed():
	if P.gem_count >= P.speed_cost:
		P.gem_count = -P.speed_cost
		P.speed += 1
		P.speed_cost = P.speed_cost*2
		set_stats()

func _on_Blast_pressed():
	if P.gem_count >= P.blast_radius_cost:
		P.gem_count = -P.blast_radius_cost
		P.blast_radius_curr += 1
		P.blast_radius_cost = P.blast_radius_cost*10
		set_stats()
		
func _on_Map_pressed():
	if P.gem_count >= P.map_size_cost:
		P.gem_count = -P.map_size_cost
		P.map_size_curr += 1
		P.map_size_cost = P.map_size_cost*4
		set_stats()

func _on_GemsSpawned_pressed():
	if P.gem_count >= P.gems_spawned_cost:
		P.gem_count = -P.gems_spawned_cost
		P.gems_spawned += 3
		P.gems_spawned_cost = P.gems_spawned_cost*2
		set_stats()
