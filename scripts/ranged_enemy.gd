extends CharacterBody2D

const group_name = "enemy"

@export var SPEED = 100
@export var enemy_pushback = 300
@export var weight = 0.9

@onready var hilation
@onready var anni

@export var stepback_duration = 0.2
@export var retreat_slow = 0.5
@export var damage_slow_duration = 0.2
@export var attack_cooldown = 0.7
@export var start_hp = 80

@export var shoot_dist = 160.0
@export var stop_dist = 120.0
@export var projectile_speed = 200.0
@export var shoot_cooldown = 0.7
@export var walk_cooldown = 0.3

@onready var attack_cooldown_timer = $AttackCooldown

var projectile = preload("res://scenes/projectile.tscn")

var player
var damage_slow = 1
var nearest_enemy
var lowest_distance
var distance
var pushback_vector
var lastVel
var player_pushback = Vector2.ZERO
var player_knockback = Vector2.ZERO
var hp
var dir
var can_attack = true
var speed_multiplier = 2
var has_died = false

var is_walking = true
var can_walk = true

func _ready():
	add_to_group(group_name)
	hp = start_hp
	attack_cooldown_timer.wait_time = attack_cooldown

func vector_is_zero(v: Vector2) -> bool:
	return abs(v.x) < 1 and abs(v.y) < 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if has_died:
		# handle death animation
		return
	
	if len(hilation.attached_parts) != 0 and (hilation.position - position).length() < (anni.position - position).length():
		player = hilation
	else:
		player = anni
	
	velocity = Vector2.ZERO
	dir = player.position - position
	
	if is_walking:
		lowest_distance = INF
		nearest_enemy = self
		for member in get_tree().get_nodes_in_group(group_name):
			if member != self:
				distance = (position - member.position).length()
				if distance < lowest_distance:
					lowest_distance = distance
					nearest_enemy = member
		
		velocity += dir.normalized() * SPEED * damage_slow
		
		if nearest_enemy != self:
			pushback_vector = (enemy_pushback * Vector2(1,1)) / (position - nearest_enemy.position)
			velocity += pushback_vector.rotated(deg_to_rad(10))
	
	velocity += player_pushback
	player_pushback *= 0.2
	
	if not vector_is_zero(player_knockback):
		velocity = player_knockback
		player_knockback *= 0.8
	
	distance = dir.length()
	
	if distance <= stop_dist:
		is_walking = false
		can_walk = false
		await get_tree().create_timer(walk_cooldown).timeout
		can_walk = true
	
	if distance <= shoot_dist and can_attack:
		can_attack = false
		
		var projectile_instance = projectile.instantiate()
		get_parent().add_child(projectile_instance)
		projectile_instance.distance = shoot_dist
		projectile_instance.speed = projectile_speed
		projectile_instance.rotation = fmod(dir.angle(), 2 * PI)
		projectile_instance.position = position
		projectile_instance.direction = dir
		projectile_instance.init_pos = position
		projectile_instance.anni = anni
		projectile_instance.hilation = hilation
		
		attack_cooldown_timer.start()
		
	
	if distance > shoot_dist and can_walk:
		is_walking = true
	
	move_and_slide()

func take_hit(damage):
	print("debug: ranged enemy hit")
	hp -= damage
	if hp <= 0:
		has_died = true
		return
	damage_slow = 0.7
	await get_tree().create_timer(damage_slow_duration).timeout
	damage_slow = 1

func _on_attack_cooldown_timeout():
	can_attack = true

func on_hit(dmg, knockback):
	take_hit(dmg)
	player_knockback = (position - hilation.position).normalized() * knockback / weight
