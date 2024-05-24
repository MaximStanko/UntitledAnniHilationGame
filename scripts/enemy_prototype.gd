extends CharacterBody2D

const SPEED = 4000
var damage_slow = 1
var hp = 100

# Reference muss geändert werden
@onready var hilation = $"../hilation"
@onready var anni = $"../Anni"
@onready var timer_enemy_hit = $TimerEnemyHit
@onready var timer_player_hit = $TimerPlayerHit

var player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if hilation.position - position < anni.position - position:
		player = hilation
	else:
		player = anni
	var dir = player.position - position
	velocity = dir.normalized() * SPEED * delta * damage_slow
	move_and_slide()

var store_body
var store_modulate

func _on_player_detector_body_entered(body):
	if body == player:
		store_body = body
		store_modulate = body.get_node("AnimatedSprite2D").modulate
		body.get_node("AnimatedSprite2D").modulate = Color(1,0,0)
		timer_player_hit.start()
		

func take_hit(damage):
	print("debug: enemy hit")
	hp -= damage
	timer_enemy_hit.start()
	damage_slow = 0.7
	

func _on_timer_enemy_hit_timeout():
	damage_slow = 1


func _on_timer_player_hit_timeout():
	store_body.get_node("AnimatedSprite2D").modulate = store_modulate
