extends Button

func _process(delta: float) -> void:
	match Global.playing_mobile:
		true:
			self.show()
		false:
			self.hide()
