extends VehicleBody3D

@export var max_torque: float = 120000.0  # Increased for 28 tons
@export var acceleration_speed: float = 2.0 # How fast it reaches max speed
@export var turn_speed_multiplier: float = 2.5 # Boosts rotational force
@export var friction_slip_value: float = 0.8 # Lower = easier to slide/turn

var current_move: float = 0.0

@onready var left_wheels = [$VehicleWheel3D, $VehicleWheel3D2, $VehicleWheel3D3, $VehicleWheel3D4, $VehicleWheel3D5, $VehicleWheel3D11]
@onready var right_wheels = [$VehicleWheel3D6, $VehicleWheel3D7, $VehicleWheel3D8, $VehicleWheel3D9, $VehicleWheel3D10, $VehicleWheel3D12]

func _ready():
	# Set wheel friction low globally so tracks can skid
	for wheel in (left_wheels + right_wheels):
		wheel.friction_slip = friction_slip_value

func _physics_process(delta: float) -> void:
	var target_move = Input.get_axis("backward", "forward")
	var steer_input = Input.get_axis("right", "left")
	
	# --- Gradual Acceleration Logic ---
	# Move current_move toward target_move over time
	current_move = move_toward(current_move, target_move, acceleration_speed * delta)
	
	# --- Calculation ---
	# We multiply steer_input by a higher value to "overpower" the friction
	var left_pwr = current_move - (steer_input * turn_speed_multiplier)
	var right_pwr = current_move + (steer_input * turn_speed_multiplier)
	
	# We DON'T clamp here, because we want the turning force 
	# to be much stronger than the forward force.
	apply_power(left_pwr * max_torque, right_pwr * max_torque)
	
	# --- Automatic Braking ---
	# If no keys are pressed, apply small brakes to prevent sliding forever
	if target_move == 0 and steer_input == 0:
		apply_brakes(200.0)
	else:
		apply_brakes(0.0)

func apply_power(l_pwr: float, r_pwr: float) -> void:
	for wheel in left_wheels: wheel.engine_force = l_pwr
	for wheel in right_wheels: wheel.engine_force = r_pwr

func apply_brakes(strength: float) -> void:
	for wheel in (left_wheels + right_wheels):
		wheel.brake = strength
