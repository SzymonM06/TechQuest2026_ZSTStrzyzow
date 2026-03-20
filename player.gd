extends VehicleBody3D

@export var max_torque: float = 90000.0
@export var turn_sensitivity: float = 0.7

# --- Gradual Movement Settings ---
@export var acceleration_factor: float = 0.5  # Lower = heavier/slower to start
@export var deceleration_factor: float = 1.2  # How fast it slows down when letting go
@export var friction_slip_value: float = 0.8

var current_move: float = 0.0
var current_steer: float = 0.0

@onready var left_wheels = [$VehicleWheel3D, $VehicleWheel3D2, $VehicleWheel3D3, $VehicleWheel3D4, $VehicleWheel3D5, $VehicleWheel3D11]
@onready var right_wheels = [$VehicleWheel3D6, $VehicleWheel3D7, $VehicleWheel3D8, $VehicleWheel3D9, $VehicleWheel3D10, $VehicleWheel3D12]

func _ready():
	for wheel in (left_wheels + right_wheels):
		wheel.wheel_friction_slip = friction_slip_value

func _physics_process(delta: float) -> void:
	var target_move = Input.get_axis("backward", "forward")
	var target_steer = Input.get_axis("right", "left")
	
	# --- Gradual Acceleration Logic ---
	# Determine if we are speeding up or slowing down
	var accel_rate = acceleration_factor if abs(target_move) > 0.1 else deceleration_factor
	
	# This creates the "momentum" feel
	current_move = move_toward(current_move, target_move, accel_rate * delta)
	
	# We also smooth the steering so the tank doesn't "snap" instantly
	current_steer = move_toward(current_steer, target_steer, 2.0 * delta)
	
	# --- Power Calculation ---
	var left_pwr = current_move - (current_steer * turn_sensitivity)
	var right_pwr = current_move + (current_steer * turn_sensitivity)
	
	# Clamp to keep the physics stable
	left_pwr = clamp(left_pwr, -1.0, 1.0)
	right_pwr = clamp(right_pwr, -1.0, 1.0)
	
	apply_power(left_pwr * max_torque, right_pwr * max_torque)
	
	# --- Braking ---
	# Apply brakes only when there is ZERO input and we are almost stopped
	if target_move == 0 and target_steer == 0 and abs(current_move) < 0.1:
		apply_brakes(500.0)
	else:
		apply_brakes(0.0)

func apply_power(l_pwr: float, r_pwr: float) -> void:
	for wheel in left_wheels: wheel.engine_force = l_pwr
	for wheel in right_wheels: wheel.engine_force = r_pwr

func apply_brakes(strength: float) -> void:
	for wheel in (left_wheels + right_wheels):
		wheel.brake = strength
