extends Node

@onready var anni = %anni
@onready var hilation = %hilation
@onready var dmg_timer = $dmg_timer

var let_dmg = true
var dropped_part = preload("res://scenes/dropped_part.tscn")


func _on_enemy_prototype_hit(body):
	if (body == anni):
		print("anni")
		if (let_dmg):
			anni.on_hit(20)
			let_dmg = false
			dmg_timer.start()
	elif (body == hilation):
		print("hilation")
		#hilation.on_hit()
		# on_hit noch nicht fertig implementiert, nehme ich an


func _on_dmg_timer_timeout():
	let_dmg = true


func _on_hilation_part_detached():
	print("penis")
	var part = dropped_part.instantiate()
	part.set("position", hilation.position)
	add_child(part)
