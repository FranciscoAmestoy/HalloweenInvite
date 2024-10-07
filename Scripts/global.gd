#global
extends Node

var has_stick = false
var last_world_position = Vector2(0,0)
var health = 100
var inventory = []
var max_inventory_size = 4
var durries = 0
var character = ""


func add_item_to_inventory(item):
	for i in range(min(inventory.size(), max_inventory_size)):
		if inventory[i] == null:
			inventory[i] = item
			return
	if inventory.size() < max_inventory_size:
		inventory.append(item)
	else:
		print("Inventory is full")



func get_inventory():
	return inventory
