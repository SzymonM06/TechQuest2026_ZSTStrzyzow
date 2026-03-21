extends VehicleBody3D

@export var max_speed: float = 14.0
@export var acceleration: float = 12.0
@export var deceleration: float = 15.0
@export var rotation_speed: float = 1.2

func _physics_process(delta: float) -> void:
	# 1. Get Input
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	
	# 2. Handle Turning (In Place & While Moving)
	if input_dir.x != 0:
		var turn_modifier = 1.0 if input_dir.y == 0 else 0.7
		rotate_y(-input_dir.x * rotation_speed * turn_modifier * delta)
		angular_velocity.y = 0

	# 3. Handle Forward/Backward (Controls Flipped)
	# input_dir.y is negative for W and positive for S.
	# Multiplying by positive max_speed makes W move forward (-basis.z).
	var target_speed = input_dir.y * max_speed
	var forward_basis = global_transform.basis.z
	
	var current_forward_speed = -linear_velocity.dot(forward_basis)
	var new_speed = move_toward(current_forward_speed, target_speed, acceleration * delta)
	
	if input_dir.y != 0:
		linear_velocity = -forward_basis * new_speed
	else:
		var stop_speed = move_toward(current_forward_speed, 0, deceleration * delta)
		linear_velocity = -forward_basis * stop_speed

	# 4. Kill Sideways "Slide"
	var sideways_basis = global_transform.basis.x
	var side_speed = linear_velocity.dot(sideways_basis)
	linear_velocity -= sideways_basis * side_speed

	# 5. Heavy Gravity
	apply_central_force(Vector3.DOWN * 60.0)
