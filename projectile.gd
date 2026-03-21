extends CharacterBody3D

@export var speed = 200.0
@export var lifetime = 3.0

var direction = Vector3.ZERO

func _ready():
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta):
	velocity = direction * speed
	move_and_slide()
