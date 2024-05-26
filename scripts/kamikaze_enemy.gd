extends CharacterBody2D

const group_name = "enemy"

@export var SPEED = 2000
@export var enemy_pushback = 300
@export var weight = 0.7

var hilation
var anni
var game_manager

@export var stepback_duration = 0.2
@export var retreat_slow = 0.5
@export var damage_slow_duration = 0.2
@export var start_hp = 50
@export var item_drop_probability = 0.1
@export var explosion_cooldown = 0.01

@export var explosion_damage = 100

@onready var item_object = preload("res://scenes/item.tscn")
@onready var explosion_collider = get_node("ExplosionArea/Collider")
@onready var active_skull = get_node("skull_1")

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
var speed_multiplier = 2
var has_died = false
var will_explode = false

var rng = RandomNumberGenerator.new()

func _ready():
	add_to_group(group_name)
	hp = start_hp
	explosion_collider.disabled = true

func vector_is_zero(v: Vector2) -> bool:
	return abs(v.x) < 0.01 and abs(v.y) < 0.01

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	lowest_distance = INF
	nearest_enemy = self
	for member in get_tree().get_nodes_in_group(group_name):
		if member != self:
			distance = (position - member.position).length()
			if distance < lowest_distance:
				lowest_distance = distance
				nearest_enemy = member
	
	#if len(hilation.attached_parts) != 0 and (hilation.position - position).length() < (anni.position - position).length():
	#	player = hilation
	#else:
	#	player = anni
	player = anni
	var dir = player.position - position
	
	if has_died or will_explode:
		velocity = Vector2.ZERO
	else:
		velocity = dir.normalized() * SPEED * delta * speed_multiplier
	
		if nearest_enemy != self:
			pushback_vector = (enemy_pushback * Vector2(1,1)) / (position - nearest_enemy.position)
			velocity += pushback_vector.rotated(deg_to_rad(10))
		
		velocity += player_pushback
		player_pushback *= 0.2
	
	if not vector_is_zero(player_knockback):
		velocity = player_knockback
		player_knockback *= 0.8
	
	move_and_slide()

func _on_player_detector_body_entered(body):
	print(body)
	if body==anni and not will_explode:
		will_explode = true
		await get_tree().create_timer(explosion_cooldown).timeout
		has_died = true
		active_skull.play("explode")
		await get_tree().create_timer(0.2).timeout
		explosion_collider.disabled = false
		await get_tree().create_timer(0.1).timeout
		explosion_collider.disabled = true

func take_hit(damage):
	if has_died:
		return
	hp -= damage
	if hp <= 0:
		has_died = true
		if rng.randf_range(0, 1) < item_drop_probability:
			var item_instance = item_object.instantiate()
			item_instance.position = position
			get_parent().add_child(item_instance)
		#game_manager.enemy_died()
		await get_tree().create_timer(0.2).timeout
		active_skull.play("death")
		return
	damage_slow = 0.7
	await get_tree().create_timer(damage_slow_duration).timeout
	damage_slow = 1

func on_hit(dmg, knockback):
	if has_died:
		return
	take_hit(dmg)
	player_knockback = (position - hilation.position).normalized() * knockback / weight

func _on_skull_1_animation_finished():
	if active_skull.animation == "death" or active_skull.animation == "explode":
		queue_free()

func _on_area_2d_body_entered(body):
	if body == anni:
		body.on_hit(explosion_damage)
	if body == hilation:
		body.on_hit()
