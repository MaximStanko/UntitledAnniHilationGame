extends CharacterBody2D

signal hit(body)

const group_name = "enemy"

@export var SPEED = 4000
@export var enemy_pushback = 300
@export var stepback_duration = 0.2
@export var retreat_slow = 0.5
@export var damage_slow_duration = 0.2
@export var attack_cooldown = 0.7
@export var start_hp = 100

@onready var hilation = %hilation
@onready var anni = %Anni
@onready var attack_cooldown_timer = $AttackCooldown

var player
var damage_slow = 1
var nearest_enemy
var lowest_distance
var distance
var pushback_vector
var lastVel
var step_back = false
var player_pushback = Vector2.ZERO
var hp
var can_attack = true
var speed_multiplier = 2
var has_died = false

func _ready():
	add_to_group(group_name)
	hp = start_hp
	attack_cooldown_timer.wait_time = attack_cooldown

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if has_died:
		# handle death animation
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
	
	move_and_slide()

func _on_player_detector_body_entered(body):
	var type = body.get_meta("type")
	if (type == "anni" or type == "hilation"):
		if can_attack:
			can_attack = false
			hit.emit(body)
			attack_cooldown_timer.start()
		step_back = true
		await get_tree().create_timer(stepback_duration).timeout
		step_back = false

func take_hit(damage):
	print("debug: enemy hit")
	hp -= damage
	if hp <= 0:
		has_died = true
		return
	damage_slow = 0.7
	await get_tree().create_timer(damage_slow_duration).timeout
	damage_slow = 1

func _on_attack_cooldown_timeout():
	can_attack = true

func on_hit():
	pass
