# global.gd

extends Node

var has_stick = false
var last_world_position = Vector2(0,0)
var health = 300
var inventory = []
var max_inventory_size = 4
var durries = 0
var character = ""
var letter = 0
var progress_items = []  # New list for scrolls

func add_item_to_inventory(item):
	for i in range(min(inventory.size(), max_inventory_size)):
		if inventory[i] == null:
			inventory[i] = item
			return
	if inventory.size() < max_inventory_size:
		inventory.append(item)
	else:
		print("Inventory is full")

# New function to add scrolls to progress
func add_scroll_to_progress(item):
	progress_items.append(item)  # Simply append the scroll to the progress list
	print("Scroll added to progress tracking")

func get_inventory():
	return inventory

func get_progress_items():
	return progress_items  # Return the scrolls for the progress bar UI
