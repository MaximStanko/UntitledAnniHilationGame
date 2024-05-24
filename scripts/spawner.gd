extends Node2D

@export var enemy_file_location: String
@export var spawn_interval: float = 4.0

var enemy
var spawn_new = true

func _ready():
	enemy = load(enemy_file_location)

func spawn():
	if spawn_new:
		spawn_new = false
		await get_tree().create_timer(spawn_interval).timeout
		var instance = enemy.instantiate()
		add_child(instance)
		spawn_new = true

func _process(delta):
	spawn()
