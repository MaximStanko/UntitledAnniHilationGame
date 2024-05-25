extends Node2D

var VELOCITY_THERSHOLD = 10

var body_part
var is_flying = true
var friction = 0.2
var velocity = Vector2.ZERO

func init(part, hilation):
	self.body_part = part
	self.add_child(part.get_node("Sprite2D").duplicate())
	self.position = hilation.position+part.position
	self.add_to_group("dropped_parts")

# Called when the node enters the scene tree for the first time.
func _ready():
	var speed = randi_range(1000, 1200)
	var angle = randf_range(0, 2*PI)
	self.velocity = Vector2(speed, 0).rotated(angle)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position += delta * self.velocity
	self.velocity *= (1.0-friction)
	if self.velocity.length() < self.VELOCITY_THERSHOLD:
		self.velocity = Vector2.ZERO
		self.is_flying = false
