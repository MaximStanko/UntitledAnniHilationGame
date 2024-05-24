extends CharacterBody2D

const SPEED = 4000
var damage_slow = 1
var hp = 100

# Reference muss geändert werden
@onready var player = $"../hilation"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var dir = player.position - position
	velocity = dir.normalized() * SPEED * delta * damage_slow
	move_and_slide()


func _on_player_detector_body_entered(body):
	if body == player:
		body.get_node("AnimatedSprite2D").modulate = Color(1,0,0)

func take_hit(damage):
	print("debug: enemy hit")
	hp -= damage
	
	damage_slow = 0.7
	

