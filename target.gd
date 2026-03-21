extends Node3D

var onfloor = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("bullet") and !onfloor:
		$AnimationPlayer.play("falling")
		$Area3D.visible = false
		onfloor = true
