extends Node2D

@export var STEP_ROTATION = 0.2*PI
@export var STEP_DURATION = 0.5

var walk_progress = 0.0
var is_walking = false
var is_flipped = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_walking:
		walk_progress += delta
		var rot = sin(walk_progress*2*PI/self.STEP_DURATION)
		if is_flipped:
			rot = -rot
		$Sprite.rotation = rot * self.STEP_ROTATION
	else:
		self.walk_progress = 0.0
		$Sprite.rotation = 0

func detach():
	$Sprite.pause()
	hide()

func attach():
	$Sprite.play()
	show()
