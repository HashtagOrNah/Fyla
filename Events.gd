extends Node

# PLAYER SIGNALS

signal player_damaged(amount)
signal enemy_damaged(amount, body)

# MAP SIGNALS

signal bomb_dropped(player_pos)
signal bomb_exploded(bomb_pos)

# INTERACTABLE SIGNALS

signal warp_new_map()

# COLLECTION SIGNALS

signal gem_collected(value)

# UI Signals
