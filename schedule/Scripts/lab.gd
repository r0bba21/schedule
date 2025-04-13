extends Node3D

@onready var production: Control = $Production
@onready var paused: Control = $Paused

func soundfx():
	pass

func _input(event: InputEvent) -> void: # KEYBOARD SHORTCUTS
	if event.is_action_pressed("Phone"):
		match Global.in_gui:
			false:
				soundfx()
				production.show()
				Global.in_gui = true
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			true:
				soundfx()
				production.hide()
				Global.in_gui = false
	if event.is_action_pressed("Escape"):
		soundfx()
		paused.show()
		Global.in_pause = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
