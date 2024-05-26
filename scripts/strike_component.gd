extends Node2D

var STRIKE_DURATION = 0.25
var STRIKE_ROTATION_FINAL = 0.0

var sprite = null

var attack_damage = 100
var knockback = 400

var is_attached = true
var is_striking = false
var strike_progress = 0.0
var already_hit = []

# go from 0.0: a, ..., 0.5: b, ..., 1.0: a
func interpolate_back_forth(a, b, progress):
	var away_from_a = progress if progress <= 0.5 else 1.0-progress
	return a + (b-a) * away_from_a * 2

func _ready():
	self.STRIKE_DURATION = 0.25

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_striking and is_attached:
		for body in $Area2D.get_overlapping_bodies():
			if "enemy" in body.get_groups() and not body in already_hit:
				body.on_hit(attack_damage, knockback)
				already_hit.append(body)
		strike_progress += delta / self.STRIKE_DURATION
		sprite.rotation = sin(self.strike_progress*PI)*self.STRIKE_ROTATION_FINAL
		if strike_progress >= 1:
			is_striking = false
			sprite.rotation = 0
			strike_progress = 0.0

func attach():
	is_attached = true
	sprite.play()

func detach():
	is_attached = false
	sprite.pause()

func strike():
	if is_attached and not is_striking:
		is_striking = true
		already_hit.clear()

func init(sprite, final_rotation):
	self.STRIKE_ROTATION_FINAL = final_rotation
	self.sprite = sprite
	sprite.play()
