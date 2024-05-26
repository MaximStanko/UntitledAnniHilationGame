extends Node2D

func _ready():
	$strike_component.init($Sprite, -0.75*PI)

func strike():
	$strike_component.strike()

func attach():
	$strike_component.attach()
	show()

func detach():
	$strike_component.detach()
	hide()
