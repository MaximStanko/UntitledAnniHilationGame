extends CharacterBody2D

signal hit(body)

const SPEED = 4000
var damage_slow = 1
var hp = 100

# Reference muss geändert werden
@onready var hilation = %hilation
@onready var anni = %Anni
@onready var timer_enemy_hit = $TimerEnemyHit
@onready var timer_player_hit = $TimerPlayerHit

var player
var lastVel
var step_back = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
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
	move_and_slide()

func _on_player_detector_body_entered(body):
	if (body == player):
		hit.emit(body)
		step_back = true
		timer_player_hit.start()

func take_hit(damage):
	print("debug: enemy hit")
	hp -= damage
	timer_enemy_hit.start()
	damage_slow = 0.7
	

func _on_timer_enemy_hit_timeout():
	damage_slow = 1


func _on_timer_player_hit_timeout():
	step_back = false
