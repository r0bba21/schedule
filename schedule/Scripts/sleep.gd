extends Button

func _process(delta: float) -> void:
	match Global.sleep_available:
		true:
			self.disabled = false
		false:
			self.disabled = true
