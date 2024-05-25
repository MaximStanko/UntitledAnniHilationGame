extends CharacterBody2D

const group_name = "enemy"

@export var SPEED = 4000
@export var enemy_pushback = 300
var hilation
var anni
var game_manager

@export var stepback_duration = 0.2
@export var retreat_slow = 0.5
@export var damage_slow_duration = 0.2
@export var attack_cooldown = 0.7
@export var start_hp = 100
@export var item_drop_probability = 0.1

@onready var attack_cooldown_timer = $AttackCooldown
@onready var item_object = preload("res://scenes/item.tscn")
@onready var bat_1 = $bat_1

var player
var damage_slow = 1
var nearest_enemy
var lowest_distance
var distance
var pushback_vector
var lastVel
var step_back = false
var player_pushback = Vector2.ZERO
var player_knockback = Vector2.ZERO
var hp
var can_attack = true
var speed_multiplier = 2
var has_died = false

var rng = RandomNumberGenerator.new()

func _ready():
	add_to_group(group_name)
	hp = start_hp
	attack_cooldown_timer.wait_time = attack_cooldown

func vector_is_zero(v: Vector2) -> bool:
	return abs(v.x) < 1 and abs(v.y) < 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if has_died:
		return
	lowest_distance = INF
	nearest_enemy = self
	for member in get_tree().get_nodes_in_group(group_name):
		if member != self:
			distance = (position - member.position).length()
			if distance < lowest_distance:
				lowest_distance = distance
				nearest_enemy = member
		
	if (hilation.position - position).length() < (anni.position - position).length():
		player = hilation
	else:
		player = anni
	var dir = player.position - position

	lastVel = dir
	if step_back or not can_attack:
		dir = -dir
	if not step_back:
		speed_multiplier = damage_slow
		if not can_attack:
			speed_multiplier *= retreat_slow
	else:
		speed_multiplier = 2
	
	velocity = dir.normalized() * SPEED * delta * speed_multiplier
	
	if nearest_enemy != self:
		pushback_vector = (enemy_pushback * Vector2(1,1)) / (position - nearest_enemy.position)
		velocity += pushback_vector.rotated(deg_to_rad(10))
	
	velocity += player_pushback
	player_pushback *= 0.2
	
	if not vector_is_zero(player_knockback):
		velocity = player_knockback
		player_knockback *= 0.8
	
	if velocity.x <= 0:
		bat_1.flip_h = false
	else:
		bat_1.flip_h = true
	
	move_and_slide()

func _on_player_detector_body_entered(body):
	if body==anni or body==hilation:
		if can_attack and not has_died:
			can_attack = false
			body.on_hit()
			attack_cooldown_timer.start()
		step_back = true
		await get_tree().create_timer(stepback_duration).timeout
		step_back = false

func take_hit(damage):
	if has_died:
		return
	print("debug: enemy hit")
	hp -= damage
	if hp <= 0:
		has_died = true
		if rng.randf_range(0, 1) < item_drop_probability:
			var item_instance = item_object.instantiate()
			item_instance.position = position
			get_parent().add_child(item_instance)
		game_manager.enemy_died()
		bat_1.play("death")
		return
	damage_slow = 0.7
	await get_tree().create_timer(damage_slow_duration).timeout
	damage_slow = 1

func _on_attack_cooldown_timeout():
	can_attack = true

func _on_timer_player_hit_timeout():
	step_back = false

func on_hit(dmg, knockback):
	take_hit(dmg)
	player_knockback = (position - hilation.position).normalized() * knockback

func _on_bat_1_animation_finished():
	if bat_1.animation == "death":
		queue_free()
