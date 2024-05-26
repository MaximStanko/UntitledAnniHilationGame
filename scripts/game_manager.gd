extends Node

@onready var anni = %Anni
@onready var hilation = %hilation
@onready var dmg_timer = $dmg_timer

func DIFF(n):
	# Funktion für potenziell non-linearen wave-size Anstieg
	# Im Moment sehr simpel:
	var frac : int = n/2
	if not frac:
		frac = 1
	
	return 4*n*frac

var let_dmg = true
var dropped_part = preload("res://scenes/dropped_part.tscn")

func _ready():
	start_wave()

func _on_hilation_part_detached(body_part):
	var part = dropped_part.instantiate()
	part.init(body_part, hilation)
	call_deferred("add_child", part)

func _on_anni_attached_part(dropped_part):
	print('attaching hurenshon')
	hilation.attach(dropped_part)
	call_deferred("remove_child", dropped_part)


func _on_anni_dropped_part(dropped_part):
	dropped_part.set_physics(true)
	dropped_part.apply_impulse(anni.velocity.normalized() * anni.THROW_SPEED)

#wave_controller
var _wave = 1
var wave_size : int
var wave_size_remaining
var enemies_in_game
var enemies_spawned

var wave_pause = 10

func start_wave():
	HUD.update_wave(_wave)
	wave_size = DIFF(_wave)
	wave_size_remaining = wave_size
	enemies_in_game = 0
	enemies_spawned = 0
	
	for spawner in get_tree().get_nodes_in_group("spawner"):
		var spawn_amount : int = wave_size / get_tree().get_nodes_in_group("spawner").size()
		print(wave_size_remaining)
		if wave_size_remaining:
			spawner.spawned = 0
			if spawn_amount:
				spawner.spawn_amount = spawn_amount
				#print(spawner.spawn_amount)
				wave_size_remaining -= spawn_amount
			else:
				spawner.spawn_amount = wave_size_remaining
				wave_size_remaining = 0
			spawner.wave_ongoing = true
			print(spawner.wave_ongoing)
			print(spawner.spawn_amount)
			print()

func enemy_spawned():
	enemies_in_game += 1
	enemies_spawned += 1

func enemy_died():
	enemies_in_game -= 1
	#print(enemies_in_game)
	#print(enemies_spawned)
	if enemies_in_game == 0 and enemies_spawned == wave_size:
		for spawner in get_tree().get_nodes_in_group("spawner"):
			spawner.wave_ongoing = false
		HUD.wave_pause()
		await get_tree().create_timer(wave_pause).timeout
		_wave += 1
		start_wave()
