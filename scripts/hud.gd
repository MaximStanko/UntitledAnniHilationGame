extends CanvasLayer

@onready var survive_time = $survive_time
@onready var time_display = $time_display
@onready var score_display = $score_display
#@onready var health_display = $health_display

@onready var game_over = $game_over

@export var health = 240

var time = 0
var score = 0
var anni_hp = health
var max_bar = 6
var curr_bar = max_bar
var stepper = anni_hp / max_bar

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
	
	if anni_hp < (curr_bar-1)*stepper:
		get_node("health_bar/"+str(curr_bar)+"bars").visible = false
		curr_bar -= 1
		
	
#	health_display.text = "Health: " + str(anni_hp)
	if (anni_hp <= 0):
		Engine.time_scale = 0
		game_over.visible = true
		


# respawn button
func _on_button_pressed():
	Engine.time_scale = 1
	game_over.visible = false
	for i in range(1,max_bar+1):
		get_node("health_bar/"+str(i)+"bars").visible = true
	curr_bar = max_bar
	time = 0
	time_display.text = "Zeit: " + str(time) + "s"
	update_score(-score)
	update_health(health)
	get_tree().reload_current_scene()
