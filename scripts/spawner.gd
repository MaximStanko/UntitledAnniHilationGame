extends Node2D

@onready var anni = %Anni
@onready var hilation = %hilation
@onready var game_manager = %GameManager


@export var enemy_file_location: String
@export var spawn_interval: float = 4.0
@export var wave = 1
#@export var spawn_amount: int = 5
# vvv mit wave control:
var spawn_amount

var enemy
var spawn_new = true
var spawned = 0

var wave_ongoing = false

func _ready():
	enemy = load(enemy_file_location)

func spawn():
	if spawn_new and spawned < spawn_amount:
		print(self, "spawn", spawned, spawn_amount)
		spawn_new = false
		spawned += 1
		await get_tree().create_timer(spawn_interval).timeout
		var instance = enemy.instantiate()
		instance.set("anni", anni)
		instance.set("hilation", hilation)
		instance.set("game_manager", game_manager)
		instance.position = position + Vector2(1,1) * spawned * 10
		get_window().add_child(instance)
		instance.add_to_group("enemy")
		
		# for wave control:
		game_manager.enemy_spawned()
		spawn_new = true

func _process(_delta):
	if wave_ongoing and game_manager._wave >= wave:
		#print(self, spawn_amount)
		spawn()
	#else:
		#game_manager.enemy_spawned()
