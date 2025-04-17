extends Control

@onready var paused: Control = $"."

func _on_play_pressed() -> void:
	paused.hide()
	Global.in_pause = false
	Engine.time_scale = 1.0

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

@onready var options: Control = $Options

func _on_options_pressed() -> void:
	options.show()
