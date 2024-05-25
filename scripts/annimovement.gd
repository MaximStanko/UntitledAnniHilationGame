extends CharacterBody2D

signal attached_part
signal dropped_part

# Movement speed in pixels per second.
@export var walk_speed: float = 300.0
@export var dash_speed: float = 900.0
@export var dash_distance: float = 100.0
@export var dash_influence_factor: float = 0.08
@export var dash_enemy_pushback: float = 200.0
@export var carried_part_offset: Vector2 = Vector2(10, 10)
@export var THROW_SPEED = 1400

@onready var hilation = %hilation
var carried_part
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

func _physics_process(_delta) -> void:
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
	
	# sprite orientation
	if self.velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif self.velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	
	# carry part
	if self.carried_part:
		self.carried_part.position = self.position + self.carried_part_offset
		self.carried_part.rotation = PI/2
		self.carried_part.scale = Vector2(0.8, 0.8)
	
	# drop carried part
	#if Input.is_action_pressed("anni_drop") and self.carried_part:
		#dropped_part.emit(self.carried_part)
		#self.carried_part = null

func on_hit():
	HUD.update_health(-20)


func _on_area_2d_body_entered(body):
	if body == hilation:
		if self.carried_part:
			attached_part.emit(carried_part)
			self.carried_part = null
	elif "dropped_parts" in body.get_groups():
		if not self.carried_part and not body.is_flying():
			self.carried_part = body
			body.set_physics(false)
