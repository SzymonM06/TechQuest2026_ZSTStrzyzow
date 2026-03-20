extends VehicleBody3D

@export var max_torque: float = 80000.0 # High torque for 28 tons
@export var brake_strength: float = 500.0

@onready var left_wheels = [$VehicleWheel3D, $VehicleWheel3D2, $VehicleWheel3D3, $VehicleWheel3D4, $VehicleWheel3D5, $VehicleWheel3D11]
@onready var right_wheels = [$VehicleWheel3D6, $VehicleWheel3D7, $VehicleWheel3D8, $VehicleWheel3D9, $VehicleWheel3D10, $VehicleWheel3D12]

func _physics_process(_delta: float) -> void:
	var move_input = Input.get_axis("backward", "forward") # [cite: 3]
	var steer_input = Input.get_axis("right", "left")     # [cite: 3]
	
	# Calculate power for each track (skid steering)
	var steer_multiplier = 3 # Increase this to make turns sharper
	var left_pwr = (move_input - (steer_input * steer_multiplier)) * max_torque
	var right_pwr = (move_input + (steer_input * steer_multiplier)) * max_torque
	
	apply_power(left_pwr, right_pwr)
	apply_brakes()

func apply_power(l_pwr: float, r_pwr: float) -> void:
	for wheel in left_wheels:
		wheel.engine_force = l_pwr
	for wheel in right_wheels:
		wheel.engine_force = r_pwr

func apply_brakes() -> void:
	var is_braking = Input.is_action_pressed("ui_accept") # Spacebar
	var strength = brake_strength if is_braking else 0.0
	
	for wheel in (left_wheels + right_wheels):
		wheel.brake = strength
