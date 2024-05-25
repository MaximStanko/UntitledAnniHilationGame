extends Camera2D

@onready var topleft: Vector2 = get_parent().get_node("topleft").position
@onready var bottomright: Vector2 = get_parent().get_node("bottomright").position

@onready var anni = %Anni
@onready var hilation = %hilation

@export var margin = 400 # in pixels
const max_scaler = 1

var viewport_size
var intended_size

func _ready():
	self.limit_left = topleft.x
	self.limit_top = topleft.y
	self.limit_right = bottomright.x
	self.limit_bottom = bottomright.y

func _process(delta):
	viewport_size = get_viewport().get_visible_rect().size
	
	position = (anni.position + hilation.position) / 2
	
	intended_size = (Vector2.ONE * margin) + abs(anni.position - hilation.position)
	zoom = Vector2.ONE * min(max_scaler, viewport_size.x / intended_size.x, viewport_size.y / intended_size.y)
