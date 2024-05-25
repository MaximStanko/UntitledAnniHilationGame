extends CanvasLayer

@onready var survive_time = $survive_time
@onready var time_display = $time_display
@onready var score_display = $score_display
@onready var health_display = $health_display


var time = 0
var score = 0
var anni_hp = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	survive_time.start()

func _on_survive_time_timeout():
	time += 1
	time_display.text = "Zeit: " + str(time) + "s"

func update_score(change):
	score += change
	score_display.text = "Score: " + str(score)

func update_health(change):
	anni_hp += change
	health_display.text = "Health: " + str(anni_hp)
