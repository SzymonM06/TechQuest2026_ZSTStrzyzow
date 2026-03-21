extends Node3D

var max_targets = 5
# Called when the node enters the scene tree for the first time.
var points = 0
func _ready() -> void:
	$Label2.visible = true
	await get_tree().create_timer(3).timeout
	$Label2.visible = false

func _add_point():
	points = points + 1
	$Label.text = "Cele " + str(points) + "/5"
	print(points)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(points == max_targets):
		print("win")
		get_tree().change_scene_to_file("res://win_screen.tscn")
