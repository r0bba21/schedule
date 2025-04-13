extends CharacterBody3D

@export var look_sens:float = 0.006
@export var controller_sens:float = 0.05
var wish_dir := Vector3.ZERO
# AIR MOVEMENT
@export var jump_velo:float = 6.0
@export var air_cap := 0.85 # CHANGES SURFING?
@export var air_accel := 800.0
@export var air_move_speed := 500.0
@export var auto_bhop = true
# GROUND MOVEMENT:
@export var walk_speed:float = 7.0
@export var sprint_speed:float = 8.5
@export var ground_accel := 14.0
@export var ground_decel := 10.0
@export var ground_fric := 6.0

const head_bop = 0.06
const head_bob_freq = 2.4
var head_bob_time := 0.0

func _ready() -> void:
	for child in %WorldModel.find_children("*", "VisualInstance3D"):
		child.set_layer_mask_value(1, false)
		child.set_layer_mask_value(2, true)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * look_sens)
			%Camera3D.rotate_x(-event.relative.y * look_sens)
			%Camera3D.rotation.x = clamp(%Camera3D.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _handle_ground_physics(delta: float) -> void:
	var cur_speed_in_wish = self.velocity.dot(wish_dir)
	var add_speed_tcap = get_movespeed() - cur_speed_in_wish
	if add_speed_tcap > 0:
		var accel_speed = ground_accel * delta * get_movespeed()
		accel_speed = min(accel_speed, add_speed_tcap)
		self.velocity += accel_speed * wish_dir
	# FRICTION:
	var control = max(self.velocity.length(), ground_decel)
	var drop = control * ground_fric * delta
	var new_speed = max(self.velocity.length() - drop, 0.0)
	if self.velocity.length() > 0:
		new_speed /= self.velocity.length()
	self.velocity *= new_speed
	_headbob_fx(delta)

func _clip_velocity(normal: Vector3, overbounce: float, delta: float) -> void:
	var backoff := self.velocity.dot(normal) * overbounce
	if backoff >= 0: return
	var change := normal * backoff
	self.velocity -= change
	var adjust = self.velocity.dot(normal)
	if adjust < 0.0:
		self.velocity -= normal * adjust

func _is_surface_toosteep(normal: Vector3) -> bool:
	var max_slope = Vector3(0,1,0).rotated(Vector3(1.0,0,0), self.floor_max_angle).dot(Vector3(0,1,0))
	if normal.dot(Vector3(0,1,0)) < max_slope:
		return true
	else:
		return false

func _handle_air_physics(delta: float) -> void:
	self.velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") * delta
	
	var cur_speed_in_wish_dir = self.velocity.dot(wish_dir)
	var capped_speed = min((air_move_speed * wish_dir).length(), air_cap)
	var add_speed_til_cap = capped_speed - cur_speed_in_wish_dir
	if add_speed_til_cap > 0:
		var accel_speed = air_accel * air_move_speed * delta
		accel_speed = min(accel_speed, add_speed_til_cap)
		self.velocity += accel_speed * wish_dir
	
	if is_on_wall():
		if _is_surface_toosteep(get_wall_normal()):
			self.motion_mode = CharacterBody3D.MOTION_MODE_FLOATING
		else:
			self.motion_mode = CharacterBody3D.MOTION_MODE_GROUNDED
		_clip_velocity(get_wall_normal(), 1, delta) # SURFING

func get_movespeed() -> float:
	return sprint_speed if Input.is_action_pressed("Sprint") else walk_speed

func _physics_process(delta: float) -> void:
	var input_dir = Input.get_vector("Left","Right","Up","Down").normalized()
	wish_dir = self.global_transform.basis * Vector3(input_dir.x, 0., input_dir.y)
	
	if is_on_floor():
		if Input.is_action_just_pressed("Jump") or (auto_bhop and Input.is_action_pressed("Jump")):
			self.velocity.y = jump_velo
		_handle_ground_physics(delta)
	else:
		_handle_air_physics(delta)
	
	move_and_slide()

func _headbob_fx(delta: float) -> void:
	head_bob_time += delta * self.velocity.length()
	%Camera3D.transform.origin = Vector3(
		cos(head_bob_time * head_bob_freq * 0.5) * head_bop,
		cos(head_bob_time * head_bob_freq) * head_bop,
		0)

var cur_cont_look := Vector2() # CONTROLLER ONLY LOOKING
func _handle_controller_look(delta: float) -> void:
	var target_look = Input.get_vector("look_left", "look_right", "look_down", "look_up").normalized()
	if target_look.length() < cur_cont_look.length():
		cur_cont_look = target_look
	else:
		cur_cont_look = target_look.lerp(target_look, 5.0 * delta) # SMOOTHING
	rotate_y(-cur_cont_look.x * controller_sens) # LEFT AND RIGHT
	%Camera3D.rotate_x(cur_cont_look.y * controller_sens) # UP AND DOWN
	%Camera3D.rotation.x = clamp(%Camera3D.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _process(delta: float) -> void:
	_handle_controller_look(delta)
