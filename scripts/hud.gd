extends CanvasLayer

@onready var survive_time = $survive_time
@onready var time_display = $time_display
@onready var score_display = $score_display
#@onready var health_display = $health_display

@onready var game_over = $game_over

@export var health = 200

var time = 0
var score = 0
var anni_hp = health

# neue Lebensleiste
@onready var bar_container = $new_healthbar/Control
var bar_size = 165

var wave = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	game_over.visible = false
	survive_time.start()

func _on_survive_time_timeout():
	time += 1
	time_display.text = "Zeit: " + str(time) + "s"

func update_score(change):
	score += change
	score_display.text = "Score: " + str(score)

func update_health(change):
	anni_hp += change
	
#	health_display.text = "Health: " + str(anni_hp)
	if (anni_hp <= 0):
		Engine.time_scale = 0
		game_over.visible = true
		bar_container.size.x = 0
	else:
		# neue Lebensleiste
		bar_container.size.x = bar_size * anni_hp/health
		print(bar_container.size.x)

# respawn button
func _on_button_pressed():
	Engine.time_scale = 1
	game_over.visible = false
	
	time = 0
	time_display.text = "Zeit: " + str(time) + "s"
	update_score(-score)
	update_health(health)
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.queue_free()
	get_tree().reload_current_scene()
