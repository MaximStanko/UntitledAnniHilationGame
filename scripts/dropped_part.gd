extends Node2D

var VELOCITY_THERSHOLD = 10
var SPEED_RANGE = Vector2(1200, 1400)
var FRICTION = 0.15

var body_part
var velocity = Vector2.ZERO

func init(part, hilation):
	self.body_part = part
	self.add_child(part.get_node("Sprite2D").duplicate())
	self.get_node("Sprite2D").rotation = 0
	self.rotation = randf_range(0, 2*PI)
	self.position = hilation.position+part.position
	self.add_to_group("dropped_parts")

# Called when the node enters the scene tree for the first time.
func _ready():
	var speed = randi_range(self.SPEED_RANGE.x, self.SPEED_RANGE.y)
	var angle = randf_range(0, 2*PI)
	self.velocity = Vector2(speed, 0).rotated(angle)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position += delta * self.velocity
	self.velocity *= (1.0-self.FRICTION)
	if not self.is_flying():
		self.velocity = Vector2.ZERO

func is_flying():
	return self.velocity.length() > self.VELOCITY_THERSHOLD

func set_physics(has_collision):
	$Area2D/CollisionShape2D.set_deferred("disabled", not has_collision)
