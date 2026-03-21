extends VehicleBody3D
#:(
const ENGINE_POWER = 500

@onready var left_wheels = [$VehicleWheel3D2, $VehicleWheel3D, $VehicleWheel3D3, $VehicleWheel3D4, $VehicleWheel3D5, $VehicleWheel3D6]
@onready var right_wheels = [$VehicleWheel3D12, $VehicleWheel3D11, $VehicleWheel3D10, $VehicleWheel3D9, $VehicleWheel3D8, $VehicleWheel3D7]
@onready var turret = $Body/Turret
@onready var elevation_pivot = $Body/Turret/ElevationPivot

var mouse_sensitivity = 0.003
var gun_vertical_angle = 0.0
var max_gun_angle = deg_to_rad(20)
var min_gun_angle = deg_to_rad(-45)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event is InputEventMouseMotion:
		turret.rotate_y(-event.relative.x * mouse_sensitivity)
		
		gun_vertical_angle -= event.relative.y * mouse_sensitivity * 5.0
		gun_vertical_angle = clamp(gun_vertical_angle, min_gun_angle, max_gun_angle)
		
		if elevation_pivot:
			elevation_pivot.rotation.x = gun_vertical_angle

func _process(delta: float) -> void:
	var steer = Input.get_axis("right","left")
	var move_dir = Input.get_axis("backward", "forward")
	if move_dir != 0 and steer !=0:
		for wheel in left_wheels:
			wheel.engine_force = ENGINE_POWER * (move_dir - steer)
		for wheel in right_wheels:
			wheel.engine_force = ENGINE_POWER * (move_dir + steer)
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
		
