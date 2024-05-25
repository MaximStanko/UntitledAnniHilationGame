extends Node

@onready var anni = %Anni
@onready var hilation = %hilation
@onready var dmg_timer = $dmg_timer

var let_dmg = true
var dropped_part = preload("res://scenes/dropped_part.tscn")


func _on_hilation_part_detached(body_part):
	var part = dropped_part.instantiate()
	part.init(body_part, hilation)
	call_deferred("add_child", part)


func _on_anni_attached_part(dropped_part):
	hilation.attach(dropped_part)
	call_deferred("remove_child", dropped_part)


func _on_anni_dropped_part(dropped_part):
	dropped_part.set_physics(true)
	dropped_part.velocity = anni.velocity.normalized() * anni.THROW_SPEED
