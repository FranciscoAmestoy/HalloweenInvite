# inventory.gd
extends CanvasLayer

var slots = [null, null, null, null]
@onready var slot_images = [$Control/Slot1/Slot1Image, $Control/Slot2/Slot2Image, $Control/Slot3/Slot3Image, $Control/Slot4/Slot4Image]

func _ready():
	slots = Global.get_inventory()
	update_inventory_UI()


func _input(event):
		if event.is_action_pressed("Slot_1"):
			use_item(0)
			print("Item 1 Used")
		elif event.is_action_pressed("Slot_2"):
			use_item(1)
		elif event.is_action_pressed("Slot_3"):
			use_item(2)
		elif event.is_action_pressed("Slot_4"):
			use_item(3)

func use_item(slot_index):
	if slots[slot_index]:
		slots[slot_index].use()
		slots[slot_index] = null
		slot_images[slot_index].texture = null  # Clear the texture
		update_inventory_UI()

func update_inventory_UI():
	slots = Global.get_inventory()
	print("Updating UI")
	for i in range(len(slots)):
		print("Updating slot ", i)
		if slots[i] != null:
			print("Found an item for slot ", i)
			slot_images[i].texture = slots[i].item_texture
