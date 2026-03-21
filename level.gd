extends Node3D

var max_targets = 10
# Called when the node enters the scene tree for the first time.
var points = 0
func _ready() -> void:
	pass # Replace with function body.

func _add_point():
	points = points + 1
	print(points)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(points == max_targets):
		print("win")
