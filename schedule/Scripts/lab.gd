extends Node3D

@onready var production: Control = $Production
@onready var paused: Control = $Paused
@onready var sfx: AudioStreamPlayer2D = $CharacterBody3D/SFX
@onready var player: CharacterBody3D = $CharacterBody3D
@onready var functions: Control = $Functions

func soundfx():
	sfx.play()

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
	if event.is_action_pressed("Function"):
		match Global.in_func:
			false:
				soundfx()
				functions.show()
				Global.in_func = true
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			true:
				soundfx()
				functions.hide()
				Global.in_func = false
	if event.is_action_pressed("Escape"):
		match Global.in_pause:
			false:
				soundfx()
				paused.show()
				Global.in_pause = true
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				Engine.time_scale = 0
			true:
				soundfx()
				paused.hide()
				Global.in_pause = false
				Engine.time_scale = 1.0

func _on_stuck_pressed() -> void:
	soundfx()
	paused.hide()
	Global.in_pause = false
	Engine.time_scale = 1.0
	player.position.x = -7.677
	player.position.y = 0.077
	player.position.z = -13.20
	player.rotation.x = 0
	player.rotation.y = -144.3
	player.rotation.z = 0

@onready var cauldron_imp: CSGBox3D = $Cauldron_IMP
@onready var chem_imp: CSGBox3D = $Chem_IMP
@onready var oven_imp: CSGBox3D = $Oven_IMP
@onready var oven_table: MeshInstance3D = $"lab_ver2/Oven Table"
@onready var cauldron: MeshInstance3D = $lab_ver2/Cauldron
@onready var chem_table: MeshInstance3D = $"lab_ver2/Chem Table"
var col_stored = Color.BLACK
@onready var pots: CSGBox3D = $Pots
@onready var pot: MeshInstance3D = $lab_ver2/Pot
@onready var tvM: MeshInstance3D = $lab_ver2/TV

func _process(delta: float) -> void:
	if Global.sleep_anim != false:
		sleep_screen()
		Global.sleep_anim = false
	cauldron.visible = Global.coke_unlock
	chem_table.visible = Global.meth_unlock
	oven_table.visible = Global.meth_unlock
	cauldron_imp.use_collision = Global.coke_unlock
	chem_imp.use_collision = Global.meth_unlock
	oven_imp.use_collision = Global.meth_unlock
	if Global.room_col != Color.BLACK and col_stored != Global.room_col:
		col_stored = Global.room_col
		var material:StandardMaterial3D = load("res://Assets_Other/walls.tres") as StandardMaterial3D
		material.albedo_color = col_stored
	match Global.tv_off:
		true:
			tvM.set_surface_override_material(1, load("res://Assets_Other/deadtv.tres") as StandardMaterial3D)
		false:
			tvM.set_surface_override_material(1, load("res://Assets_Other/tvon.tres") as StandardMaterial3D)
	match Global.pots:
		true:
			pots.use_collision = true
			pot.visible = true
		false:
			pots.use_collision = false
			pot.visible = false

@onready var tutorial: Control = $Tutorial

func _ready() -> void:
	match Global.loading_game:
		true:
			tutorial.hide()
		false:
			Engine.time_scale = 0
			tutorial.show()
			soundfx()

@onready var sleep: Control = $SLEEP

func sleep_screen():
	sleep.show()
	var timer:Timer = Timer.new()
	timer.wait_time = 3
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(sleep_hide.bind(timer))
	timer.start()

func sleep_hide(timer: Timer):
	timer.queue_free()
	sleep.hide()
