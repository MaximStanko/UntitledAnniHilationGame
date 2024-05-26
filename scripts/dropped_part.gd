extends RigidBody2D

var VELOCITY_THERSHOLD = 10
var SPEED_RANGE = Vector2(500, 800)
var DAMP = 3.0

var body_part
var velocity = Vector2.ZERO

func init(part, hilation):
	self.body_part = part
	var sprite = part.get_node("Sprite").duplicate()
	sprite.rotation = 0.0
	self.add_child(sprite)
	self.rotation = randf_range(0, 2*PI)
	self.position = hilation.position+part.position
	self.add_to_group("dropped_parts")

# Called when the node enters the scene tree for the first time.
func _ready():
	var speed = randi_range(self.SPEED_RANGE.x, self.SPEED_RANGE.y)
	var angle = randf_range(0, 2*PI)
	apply_impulse(Vector2(speed, 0).rotated(angle))
	self.linear_damp = self.DAMP

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func is_flying():
	return self.velocity.length() > self.VELOCITY_THERSHOLD

func set_physics(has_collision):
	$CollisionShape2D.set_deferred("disabled", not has_collision)
