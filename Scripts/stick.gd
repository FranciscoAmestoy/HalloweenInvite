extends Area2D



func _on_body_entered(body):
	if body.is_in_group("Player"):
		Global.has_stick = true
		self.visible = false
		
