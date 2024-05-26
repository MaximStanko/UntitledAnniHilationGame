extends CharacterBody2D

signal part_detached

@export var BASE_SPEED = 30
@export var LEG_SPEED = 70

var attached_parts = []
var flipped = false

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

	if self.velocity.x < 0:
		flipped = false
	elif self.velocity.x > 0:
		flipped = true
	$torso.flip_h = flipped
	$leg_l/Sprite.scale.x = 1.0 if flipped else -1.0
	$leg_r/Sprite.scale.x = 1.0 if flipped else -1.0

	if Input.is_action_pressed("hilation_strike_r"):
		$arm_r.strike()

	if Input.is_action_pressed("hilation_strike_l"):
		$arm_l.strike()

func on_hit():
	var part = self.attached_parts.pop_front()
	if part:
		part.detach()
		self.part_detached.emit(part)

func attach(dropped_part):
	var part = dropped_part.body_part
	part.attach()
	self.attached_parts.append(part)
