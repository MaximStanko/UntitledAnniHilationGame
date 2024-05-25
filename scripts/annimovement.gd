extends CharacterBody2D

# Movement speed in pixels per second.
@export var walk_speed: float = 300.0
@export var dash_speed: float = 900.0
@export var dash_distance: float = 200.0
@export var dash_influence_factor: float = 0.08

var dashing = false
var dash_dir: Vector2
var last_active_dir = Vector2.ZERO

func dash() -> void:
	if Input.is_action_just_pressed("anni_dash") and not dashing:
		dashing = true
		await get_tree().create_timer(dash_distance / dash_speed).timeout
		dashing = false

func vector_is_zero(v: Vector2) -> bool:
	return abs(v.x) < 0.01 and abs(v.y) < 0.01

func _physics_process(delta) -> void:
	dash()
	
	var velo = Vector2(
		Input.get_action_strength("anni_right") - Input.get_action_strength("anni_left"),
		Input.get_action_strength("anni_down") - Input.get_action_strength("anni_up")
	).normalized()
	
	if not vector_is_zero(velo) and not dashing:
		last_active_dir = velo
	
	if dashing:
		last_active_dir = (last_active_dir + velo * dash_influence_factor).normalized()
		self.velocity = last_active_dir * dash_speed
	else:
		self.velocity = velo * walk_speed
	
	move_and_slide()
