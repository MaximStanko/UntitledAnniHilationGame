extends CharacterBody2D

# Movement speed in pixels per second.
@export var speed = 500

func _physics_process(delta):
	var velo = Vector2(
		Input.get_action_strength("hilation_right") - Input.get_action_strength("hilation_left"),
		Input.get_action_strength("hilation_down") - Input.get_action_strength("hilation_up")
	)
	self.velocity = velo.normalized() * speed
	move_and_slide()
