extends CanvasLayer

@onready var survive_time = $survive_time
@onready var time_display = $time_display
@onready var score_display = $score_display
@onready var wave_display = $waves/wave_display

#@onready var health_display = $health_display

@onready var game_over = $game_over
@onready var pause_screen = $PauseScreen

@export var health = 200

var time = 0
var score = 0
var anni_hp = health

var paused = false

# neue Lebensleiste
@onready var bar_container = $new_healthbar/Control
var bar_size = 165

# Called when the node enters the scene tree for the first time.
func _ready():
	game_over.visible = false
	survive_time.start()

func _input(event):
	if event.is_action_pressed("pause"):
		if paused:
			paused = false
			get_tree().paused = false
			pause_screen.visible = false
		else:
			paused = true
			get_tree().paused = true
			pause_screen.visible = true

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
		get_node("game_over/Button").grab_focus()
		game_over.visible = true
		bar_container.size.x = 0
	else:
		# neue Lebensleiste
		bar_container.size.x = bar_size * anni_hp/health

func update_wave(x):
	wave_display.text = "Wave " + str(x)

func wave_pause():
	wave_display.text = "Pause"

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
