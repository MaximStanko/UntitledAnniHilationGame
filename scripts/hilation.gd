extends CharacterBody2D

# Movement speed in pixels per second.
@export var speed = 500
@export var STRIKE_R_DURATION = 2.0

var is_strike_r = false
var strike_r_progress = 0.0
var body_parts = [$arm_l, $arm_r]

func _physics_process(delta):
	var velo = Vector2(		
		Input.get_action_strength("hilation_right") - Input.get_action_strength("hilation_left"),
		Input.get_action_strength("hilation_down") - Input.get_action_strength("hilation_up")
	)
	self.velocity = velo.normalized() * speed
	move_and_slide()
	
	if Input.is_action_pressed("hilation_strike_r"):
		$arm_r.strike()
	
	if Input.is_action_pressed("hilation_strike_l"):
		$arm_l.strike()
