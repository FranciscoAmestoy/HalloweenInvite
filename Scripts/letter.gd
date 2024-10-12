# scroll.gd

extends "item.gd"

func _ready():
	item_texture = preload("res://Assets/Characters/scroll.png")
	print(item_texture)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		if Global.letter < 4:  # Ensure we don't exceed 4 scrolls
			Global.letter += 1  # Increase global letter count
			print("Scroll picked up, current letter count: ", Global.letter)  # Print letter count
			var cloned_item = self.duplicate()  # Clone the current scroll
			cloned_item.item_texture = self.item_texture
			Global.add_scroll_to_progress(cloned_item)  # Add the scroll to the progress tracking list
			var inventory_node = get_node("../player/Inventory")
			if inventory_node:
				inventory_node.update_progress_UI()  # Only call update_progress_UI here
			else:
				print("Failed to find inventory node")
			queue_free()  # Remove the original scroll from the game world
