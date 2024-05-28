extends Node2D

var strike_cooldown = 0.7
var can_strike = true

func _ready():
	$strike_component.init($Sprite, -0.75*PI)

func strike():
	if not can_strike:
		return
	$strike_component.strike()
	can_strike = false
	await get_tree().create_timer(strike_cooldown).timeout
	can_strike = true

func attach():
	$strike_component.attach()
	show()

func detach():
	$strike_component.detach()
	hide()
