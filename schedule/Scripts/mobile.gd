extends VBoxContainer

@onready var tutorial: Control = %Tutorial

func _process(delta: float) -> void:
	match Global.playing_mobile:
		true:
			if tutorial.visible != true and Global.in_func != true and Global.in_gui != true and Global.in_pause != true:
				self.show()
			else:
				self.hide()
		false:
			self.hide()
