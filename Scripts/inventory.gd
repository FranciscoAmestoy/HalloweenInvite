# inventory.gd
extends CanvasLayer

var slots = [null, null, null, null]
var progress_bar = []  # New list for the scrolls
var select_sound = preload("res://Assets/SFX/charSelect.mp3")
var sfx_player = null
@onready var slot_images = [$Control/Slot1/Slot1Image, $Control/Slot2/Slot2Image, $Control/Slot3/Slot3Image, $Control/Slot4/Slot4Image]
@onready var progress_images = [$Control/ProgressBar/Progress1Image, $Control/ProgressBar/Progress2Image, $Control/ProgressBar/Progress3Image, $Control/ProgressBar/Progress4Image]  # Reference to progress bar images

func _ready():
	slots = Global.get_inventory()
	progress_bar = Global.get_progress_items()
	update_inventory_UI()
	update_progress_UI()
	sfx_player = $SFXPlayer

func _input(event):
	# Your existing input handling code for item slots
	if event.is_action_pressed("Slot_1"):
		use_item(0)
		sfx_player.stream = select_sound
		sfx_player.play()
		print("Item 1 Used")
	# Similar for other slots...
		
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

# New function to update the scroll progress bar
# Update the scroll progress UI (showing scroll images)
func update_progress_UI():
	# Show scrolls based on Global.letter
	for i in range(len(progress_images)):
		if i < Global.letter:  # Only show up to the current letter count
			progress_images[i].visible = true
		else:
			progress_images[i].visible = false  # Hide the rest
