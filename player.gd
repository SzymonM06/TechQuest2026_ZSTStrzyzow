extends VehicleBody3D

const ENGINE_POWER = 8096.0
@onready var left_wheels = [$VehicleWheel3D,$VehicleWheel3D2,
$VehicleWheel3D3,$VehicleWheel3D4,$VehicleWheel3D5, 
$VehicleWheel3D11,$VehicleWheel3D12]
@onready var right_wheels = [$VehicleWheel3D6,$VehicleWheel3D7,
$VehicleWheel3D8,$VehicleWheel3D9,$VehicleWheel3D10,
$VehicleWheel3D13,$VehicleWheel3D14]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var steer = Input.get_axis("right","left")
	var move_dir = Input.get_axis("backward","forward")
	var engine_power = 20.0
	if steer != 0 and move_dir != 0:
		for wheel in left_wheels:
			wheel.engine_force = ENGINE_POWER * (move_dir-steer*1.6) * 2
		for wheel in right_wheels:
			wheel.engine_force = ENGINE_POWER * (move_dir+steer*1.6) * 2
	elif steer != 0:
		for wheel in left_wheels:
			wheel.engine_force = ENGINE_POWER * -steer * 2
		for wheel in right_wheels:
			wheel.engine_force = ENGINE_POWER * steer * 2
	else:
		for wheel in left_wheels:
			wheel.engine_force = ENGINE_POWER * move_dir
		for wheel in right_wheels:
			wheel.engine_force = ENGINE_POWER * move_dir
		
