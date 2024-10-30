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
@onready var fidget_timer = $FidgetTimer

var fidget_move : Vector2 = Vector2.ZERO
var timer_trigger : bool = false
var next_move : Vector2 = Vector2.ZERO

func _ready():
	fidget_timer.start()
	
func set_fidget_time(min_time : float = 1.0, max_time : float = 6.0) -> float:
	return randf_range(min_time, max_time)
	

	
func _process(delta):

	# As we are low resolution we don't want fractions in our position which can cause tearing
	self.position = floor(self.position) + get_fidgeting()
	

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if get_rect().has_point(to_local(event.position)):
			scale += Vector2.ONE * size_increase
			clicks_to_pop -= 1
			if clicks_to_pop < 1:
				#$"/root/Main".increase_score(score_to_give)
				queue_free()

func move_passenger():
	self.create_tween().tween_property(self, "position:x", marker_2d_lineup.global_position.x-(10+passenger_width*passenger_number), walk_speed)
	
func retreat():
	pass
	
func enter_bus():
	pass
	
func provide_documents():
	pass
	
func provide_portrait():
	pass
	

func _on_fidget_timer_timeout():
	timer_trigger = true
	fidget_timer.wait_time = set_fidget_time(1,10)

func get_fidgeting() -> Vector2:
	# Jitter to make them look restless and alive. 
	if timer_trigger:
		if next_move == Vector2.ZERO:
			timer_trigger = false
			fidget_move = Vector2(randi_range(-1, 1), randi_range(-1, 1))
			next_move = -fidget_move
		else:
			fidget_move = next_move
			next_move = Vector2.ZERO
	else:
		fidget_move = Vector2.ZERO
	return fidget_move
