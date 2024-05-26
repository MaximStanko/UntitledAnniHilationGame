extends Node2D

var speed: float = 100.0
var direction: Vector2 = Vector2.RIGHT
var distance: float = 150.0

var anni
var hilation

@onready var init_pos: Vector2 = position

var dissolving = false

func _process(delta):
	if not dissolving:
		position += direction.normalized() * speed * delta
	if (init_pos - position).length() >= distance and not dissolving:
		dissolving = true
		queue_free()

func _on_area_2d_body_entered(body):
	print(body, anni, hilation)
	if body==anni or body==hilation:
		body.on_hit()
		queue_free()
