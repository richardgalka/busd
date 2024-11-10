extends Node2D


# Define the range for the number of passengers arriving
@export_category("Passenger numbers")
@export var min_passengers: int = 1
@export var max_passengers: int = 10
var num_passengers: int = 0
var num_spawned_passengers: int = 0

# The timer range for when new passengers arrive
@export var min_timer: float = 1.0
@export var max_timer: float = 5.0

@export var difficulty : int = 10
@onready var scn_human_silhoute: PackedScene = preload("res://busd/Scene/human_silhoute.tscn")
@onready var marker_2d_lineup = $Marker2D_lineup
@onready var bus_stop_animation_player = $"../BusDriverView/BusStopAnimationPlayer"


var time_left : float = 5.0

# Preload the HumanSilhoute scene
var passenger_scene = preload("res://busd/Scene/human_silhoute.tscn")

func _ready():
	# Call the function to start generating passengers
	#generate_passengers()
	num_passengers = generate_random_passengers(min_passengers, max_passengers)
	print("Number of passengers arriving at bus stop: ", num_passengers)

# Function to generate a random number of passengers
func generate_random_passengers(minp: int, maxp: int) -> int:
	return randi_range(minp, maxp)

# Function to move a passenger along the X axis
func move_passenger(passenger):
	passenger.create_tween().tween_property(self, "position:x", marker_2d_lineup.global_position.x-10, 5)
	#var tween = Tween.new()

func _on_timer_new_person_timeout():
	if(num_spawned_passengers < num_passengers):
		num_spawned_passengers += 1
		var passenger = passenger_scene.instantiate()
		passenger.passenger_number = num_spawned_passengers
		passenger.position = Vector2i(-10, (randi_range(-1, 1) +  marker_2d_lineup.global_position.y))
		add_child(passenger)
		passenger.move_passenger()
		# move passenger
	else:
		print("Stopping passenger create timer")
		$Timer_new_person.stop()

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()


func _on_bus_stop_area_area_entered(area):
	if area.is_in_group("Bus"):
		# start the bus stop movement in bus driver view
		bus_stop_animation_player.play("BusStopMoveInView")
	
