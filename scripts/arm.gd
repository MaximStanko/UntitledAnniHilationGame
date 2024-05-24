extends Node2D

@export var STRIKE_DURATION = .5

var is_striking = false
var strike_progress = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_striking:
		strike_progress += delta
		$Sprite2D.rotation = -0.7*PI
		if strike_progress > STRIKE_DURATION:
			is_striking = false
			$Sprite2D.rotation = 0
			strike_progress = 0.0

func strike():
	is_striking = true
