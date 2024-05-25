extends Node2D

@export var speed: float = 200.0
@export var velocity: Vector2 = Vector2.RIGHT
@export var distance: float = 150.0

@onready var init_pos: Vector2 = position

var dissolving = false

func _process(delta):
	if not dissolving:
		position += velocity * speed * delta
	if (init_pos - position).length() >= distance and not dissolving:
		dissolving = true
		queue_free()
