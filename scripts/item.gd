extends Node2D

@export var disappear_cooldown: float = 10.0

var disappearing: bool = false
var disappeared: bool = false
var collected: bool = false

func _ready():
	await get_tree().create_timer(disappear_cooldown).timeout
	disappearing = true

func _process(delta):
	if disappearing:
		disappear()

func disappear():
	if disappeared:
		return
	disappeared = true
	
	queue_free()

func _on_area_2d_body_entered(body):
	var type = body.get_meta("type")
	if type != "anni":
		return
	collected = true
	
	HUD.update_health(100)
	
	disappear()
