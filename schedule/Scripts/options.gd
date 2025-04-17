extends Control

func _on_save_pressed() -> void:
	soundfx()
	var file = FileAccess.open("res://Settings_DRUGGO.dat", FileAccess.WRITE)
	file.store_var(Global.VOL)
	file.store_var(Global.sfx_vol)
	file.store_var(Global.mus_vol)
	file.store_var(Global.res)
	file.store_var(Global.window)
	file.store_var(Global.autosave)
	file.store_var(Global.v_sync)
	file.store_var(Global.max_fps)
	file.close()

func _on_exit_pressed() -> void:
	soundfx()
	self.hide()

@onready var sound: AudioStreamPlayer2D = $SOUND

func soundfx():
	sound.play()

# AUDIO:
func _on_master_value_changed(value: float) -> void:
	Global.VOL = value
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	soundfx()

func _on_sfx_value_changed(value: float) -> void:
	Global.sfx_vol = value
	var bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	soundfx()

func _on_music_value_changed(value: float) -> void:
	Global.mus_vol = value
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	soundfx()

# DISPLAY:
func _on_res_item_selected(index: int) -> void:
	soundfx()
	Global.res = index
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1280,720))
		1:
			DisplayServer.window_set_size(Vector2i(1600,900))
		2:
			DisplayServer.window_set_size(Vector2i(1920,1080))
		3:
			DisplayServer.window_set_size(Vector2i(2560,1440))
		4:
			DisplayServer.window_set_size(Vector2i(3480,2160))

func _on_window_item_selected(index: int) -> void:
	soundfx()
	Global.window = index
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		3:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)

func _on_vsync_item_selected(index: int) -> void:
	Global.v_sync = index
	soundfx()
	match index:
		0:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		1:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func _on_fps_item_selected(index: int) -> void:
	Global.max_fps = index
	Engine.max_fps = Global.max_fps
	soundfx()

# GAME:
func _on_autosave_item_selected(index: int) -> void:
	Global.autosave = index
	soundfx()
