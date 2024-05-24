extends CanvasLayer

@onready var survive_time = $survive_time
@onready var time_display = $time_display
@onready var score_display = $score_display

var time = 0
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	survive_time.start()

func _on_survive_time_timeout():
	time += 1
	time_display.text = "Zeit: " + str(time) + "s"

func update_score(change):
	score += change
	score_display.text = "Score: " + str(score)
