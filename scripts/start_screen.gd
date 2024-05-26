extends Control

const scale_factor = 1.08
const scaleback_time = 0.3

const player1 = 1
const player2 = 0

@onready var hilation_art = get_node("HilationArtwork")
@onready var anni_art = get_node("AnniArtwork")
var hilation_scale
var anni_scale

var timer_anni = 0
var timer_hilation = 0

func _ready():
	HUD.visible = false
	get_node("PlayButton").grab_focus()
	hilation_scale = hilation_art.scale
	anni_scale = anni_art.scale

func _process(delta):
	var time = Time.get_ticks_msec()
	if time - timer_anni >= scaleback_time * 1000:
		anni_art.scale = anni_scale
	if time - timer_hilation >= scaleback_time * 1000:
		hilation_art.scale = hilation_scale

func _on_play_button_pressed():
	HUD.visible = true
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _input(event:InputEvent):
	var device = event.device
	if event is InputEventMouse or event is InputEventMouseButton or event is InputEventMouseMotion or event is InputEventKey:
		device = -1
	if device == player1:
		anni_art.scale = anni_scale * scale_factor
		timer_anni = Time.get_ticks_msec()
	if device == player2:
		hilation_art.scale = hilation_scale * scale_factor
		timer_hilation = Time.get_ticks_msec()


func _on_quit_button_pressed():
	get_tree().quit()
