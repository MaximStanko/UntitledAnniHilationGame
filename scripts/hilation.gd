extends CharacterBody2D

signal part_detached

@export var BASE_SPEED = 50
@export var LEG_SPEED = 150

var attached_parts = []

func _ready():
	attached_parts = [$arm_l, $leg_r, $leg_l, $arm_r]
	$leg_l.set("is_flipped", true)

func _physics_process(delta):
	var velo = Vector2(		
		Input.get_action_strength("hilation_right") - Input.get_action_strength("hilation_left"),
		Input.get_action_strength("hilation_down") - Input.get_action_strength("hilation_up")
	)
	var speed = BASE_SPEED
	if $leg_l in self.attached_parts:
		speed += LEG_SPEED
	if $leg_r in self.attached_parts:
		speed += LEG_SPEED
	self.velocity = velo.normalized() * speed
	move_and_slide()
	
	if self.velocity.length() > 0:
		$leg_l.set("is_walking", true)
		$leg_r.set("is_walking", true)
	else:
		$leg_l.set("is_walking", false)
		$leg_r.set("is_walking", false)

	if Input.is_action_pressed("hilation_strike_r"):
		$arm_r.strike()

	if Input.is_action_pressed("hilation_strike_l"):
		$arm_l.strike()

func on_hit():
	var part = self.attached_parts.pop_front()
	if part:
		part.detach()
		self.part_detached.emit()
