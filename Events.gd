extends Node

# PLAYER SIGNALS

signal game_end()
signal player_damaged(amount)
signal cam_shake()

# MAP SIGNALS

signal bomb_dropped(player_pos, blast_radius, gems_spawned)
signal bomb_exploded(bomb_pos, blast)
signal warp_hub()

# INTERACTABLE SIGNALS

signal beat_game()
signal warp_new_map()

# COLLECTION SIGNALS

signal gem_collected(value)

# UI Signals

signal toggle_audio()
