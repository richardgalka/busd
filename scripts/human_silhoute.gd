#extends StaticBody2D
extends Sprite2D
@export_category("Click Details")
@export var clicks_to_pop : int = 4
@export var size_increase : float = 0.2
@export var score_to_give : int = 1

@export_category("Passenger Details")
@export var passenger_fname : String
@export var passenger_lname : String
@export var passenger_age : int
@export var passenger_race : String
@export var passenger_number : int
@export_range(0.5, 5) var walk_speed : float = 2.0
@export_range(2,10) var passenger_width : int = 6

@onready var marker_2d_lineup = get_node("/root/Node2D/ExternalView/Marker2D_lineup")

func _ready():
	print("test")
	
func _process(delta):
	# As we are low resolution we don't want fractions in our position which can cause tearing
	self.position = floor(self.position)
	print(self.position, self.global_position)

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
	self.create_tween().tween_property(self, "position:x", marker_2d_lineup.global_position.x-(10+passenger_width*passenger_number), walk_speed)
	print("moving passenger # %s" % passenger_number)
