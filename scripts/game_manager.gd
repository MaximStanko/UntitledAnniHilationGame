extends Node

@onready var anni = %Anni
@onready var hilation = %hilation
@onready var dmg_timer = $dmg_timer

var let_dmg = true
var dropped_part = preload("res://scenes/dropped_part.tscn")


func _on_hilation_part_detached():
	print("penis")
	var part = dropped_part.instantiate()
	part.set("position", hilation.position)
	add_child(part)
