extends CharacterBody2D

signal hit(body)

const group_name = "enemy"

@export var SPEED = 4000
@export var enemy_pushback = 300
@export var damage_slow = 1
@export var hp = 100
var hilation
var anni

# Reference muss geändert werden
@onready var timer_enemy_hit = $TimerEnemyHit
@onready var timer_player_hit = $TimerPlayerHit

var player
var nearest_enemy
var lowest_distance
var distance
var pushback_vector
var lastVel
var step_back = false
var player_pushback = Vector2.ZERO

func _ready():
	add_to_group(group_name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	lowest_distance = INF
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
	if (step_back):
		velocity = -dir.normalized() * SPEED * delta * 2
	else:
		velocity = dir.normalized() * SPEED * delta * damage_slow
	
	if nearest_enemy:
		pushback_vector = (enemy_pushback * Vector2(1,1)) / (position - nearest_enemy.position)
		velocity += pushback_vector
	
	velocity += player_pushback
	player_pushback *= 0.2 
	
	move_and_slide()

func _on_player_detector_body_entered(body):
	if body==hilation:
		hilation.on_hit()
	if body == anni:
		anni.on_hit()

func take_hit(damage):
	print("debug: enemy hit")
	hp -= damage
	timer_enemy_hit.start()
	damage_slow = 0.7
	

func _on_timer_enemy_hit_timeout():
	damage_slow = 1


func _on_timer_player_hit_timeout():
	step_back = false

func on_hit():
	print("enemy was hit")
