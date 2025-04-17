extends Control

func _on_play_pressed() -> void:
	Global.loading_game = false
	soundfx()
	get_tree().change_scene_to_file("res://Scenes/lab.tscn")

func load_pressed() -> void: # Add me later!
	Global.loading_game = true
	soundfx()

func _on_quit_pressed() -> void:
	soundfx()
	get_tree().quit()

func _on_bug_pressed() -> void:
	soundfx()
	OS.shell_open("https://forms.gle/Vzr7CWhJfMXE4Rom8")

@onready var options: Control = $Options

func _on_options_pressed() -> void:
	soundfx()
	options.show()

@onready var sfx: AudioStreamPlayer2D = $SFX

func soundfx():
	sfx.play()

# LOADING SETTINGS:
func _ready() -> void:
	if FileAccess.file_exists("res://Settings_DRUGGO.dat"):
		load_settings()

func load_settings():
	var file = FileAccess.open("res://Settings_DRUGGO.dat", FileAccess.WRITE)
	Global.VOL = file.get_var(Global.VOL)
	Global.sfx_vol = file.get_var(Global.sfx_vol)
	Global.mus_vol = file.get_var(Global.mus_vol)
	Global.res = file.get_var(Global.res)
	Global.window = file.get_var(Global.window)
	Global.autosave = file.get_var(Global.autosave)
	Global.v_sync = file.get_var(Global.v_sync)
	Global.max_fps = file.get_var(Global.max_fps)
	file.close()
	Engine.max_fps = Global.max_fps
	_on_master_value_changed(Global.VOL)
	_on_sfx_value_changed(Global.sfx_vol)
	_on_music_value_changed(Global.mus_vol)
	_on_res_item_selected(Global.res)
	_on_window_item_selected(Global.window)
	_on_vsync_item_selected(Global.v_sync)

func _on_master_value_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))

func _on_sfx_value_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))

func _on_music_value_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))

func _on_res_item_selected(index: int) -> void:
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
	match index:
		0:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		1:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
