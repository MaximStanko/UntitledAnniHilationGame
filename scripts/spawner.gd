extends Node2D

@onready var anni = %Anni
@onready var hilation = %hilation

@export var enemy_file_location: String
@export var spawn_interval: float = 4.0
@export var spawn_amount: int = 5

var enemy
var spawn_new = true
var spawned = 0

func _ready():
	enemy = load(enemy_file_location)

func spawn():
	if spawn_new and spawned < spawn_amount:
		spawn_new = false
		spawned += 1
		await get_tree().create_timer(spawn_interval).timeout
		var instance = enemy.instantiate()
		instance.position = position + Vector2(1,1) * spawned * 10
		get_window().add_child(instance)
		instance.anni = anni
		instance.hilation = hilation
		spawn_new = true

func _process(_delta):
	spawn()
