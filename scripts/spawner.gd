extends Node2D

@onready var anni = %Anni
@onready var hilation = %hilation

@export var enemy_file_location: String
@export var spawn_interval: float = 4.0
@export var spawn_amount: int = 5

var enemy = preload("res://scenes/enemy_prototype.tscn")
var spawn_new = true
var spawned = 0

func _ready():
	print(hilation.get_node("hitbox"))
	pass

func spawn():
	if spawn_new and spawned < spawn_amount:
		spawn_new = false
		spawned += 1
		await get_tree().create_timer(spawn_interval).timeout
		var instance = enemy.instantiate()
		instance.set("anni", anni)
		instance.set("hilation", hilation)
		instance.position = position + Vector2(1,1) * spawned * 10
		get_window().add_child(instance)
		spawn_new = true

func _process(_delta):
	spawn()
