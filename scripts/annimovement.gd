extends CharacterBody2D

# Movement speed in pixels per second.
@export var walk_speed: float = 300.0
@export var dash_speed: float = 900.0
@export var dash_distance: float = 100.0
@export var dash_influence_factor: float = 0.08
@export var dash_enemy_pushback: float = 200.0


var dashing = false
var dash_dir: Vector2
var last_active_dir = Vector2.ZERO

func dash() -> void:
	if Input.is_action_just_pressed("anni_dash") and not dashing:
		dashing = true
		get_node("CollisionShape2D").disabled = true
		await get_tree().create_timer(dash_distance / dash_speed).timeout
		dashing = false
		get_node("CollisionShape2D").disabled = false

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
		for enemy in get_tree().get_nodes_in_group("enemy"):
			var distance = (enemy.position - position).length()
			if distance < 200 and distance > 20:
				enemy.player_pushback = (dash_enemy_pushback * Vector2(1,1)) / (position - enemy.position)
	else:
		self.velocity = velo * walk_speed
	
	move_and_slide()

func on_hit():
	print("anni hit")
	#HUD.update_health(-src)
