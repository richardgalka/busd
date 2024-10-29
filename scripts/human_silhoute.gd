#extends StaticBody2D
extends Sprite2D

@export var clicks_to_pop : int = 4
@export var size_increase : float = 0.2
@export var score_to_give : int = 1

var passenger_fname : String
var passenger_lname : String
var passenger_age : int
var passenger_race : String
var passenger_number : int
@export var passenger_width : int = 10

@onready var marker_2d_lineup = get_node("/root/Node2D/ExternalView/Marker2D_lineup")

func _ready():
	print("test")

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if get_rect().has_point(to_local(event.position)):
			print("click")
			scale += Vector2.ONE * size_increase
			clicks_to_pop -= 1
			if clicks_to_pop < 1:
				#$"/root/Main".increase_score(score_to_give)
				queue_free()

func move_passenger():
	print(marker_2d_lineup.position)
	self.create_tween().tween_property(self, "position:x", marker_2d_lineup.global_position.x-(10+passenger_width*passenger_number), 1.5)
	print("moving passenger # %s" % passenger_number)
