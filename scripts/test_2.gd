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

@export_category("Bus Details")
@export_enum("Left", "Right") var direction: int = 0

@export_category("Level")
@export var difficulty : int = 10
@onready var scn_human_silhoute: PackedScene = preload("res://busd/Scene/human_silhoute.tscn")
@onready var marker_2d_lineup = $Marker2D_lineup
@onready var bus_stop_animation_player = $"../BusDriverView/BusStopAnimationPlayer"
@onready var bus_lights = $Bus/BusLights

@onready var bus: Sprite2D = $Bus
@onready var bus_2: Sprite2D = $Bus2

var time_left : float = 5.0

# Preload the HumanSilhoute scene
var passenger_scene = preload("res://busd/Scene/human_silhoute.tscn")

func _test(vehicle, next_location, time):
	if(next_location):
		var vt = vehicle.create_tween()
		vt.tween_property(bus, "global_position", next_location, 20)
	else:
		vehicle.queue_free()
	
func _ready():
	# Call the function to start generating passengers
	#generate_passengers()
	var next_position = Vector2(1.0, 1.0)
	var time = 1.0
	num_passengers = generate_random_passengers(min_passengers, max_passengers)
	print("Number of passengers arriving at bus stop: ", num_passengers)
	var bt = bus.create_tween()
	bt.tween_property(bus, "global_position", Vector2(100.0,100.0), 2.0)
	bt.tween_callback(_test.bind(bus, next_position, time))
	

#var tween = get_tree().create_tween().set_loops()
#tween.tween_callback(shoot).set_delay(1)


#A tween animation is created by adding Tweeners to the Tween object, using tween_property(), tween_interval(), tween_callback() or tween_method():

#	var tween = get_tree().create_tween()
#	tween.tween_property($Sprite, "modulate", Color.RED, 1)
#	tween.tween_property($Sprite, "scale", Vector2(), 1)
#	tween.tween_callback($Sprite.queue_free)


# Function to generate a random number of passengers
func generate_random_passengers(minp: int, maxp: int) -> int:
	return randi_range(minp, maxp)

# Function to move a passenger along the X axis
func move_passenger(passenger):
	pass
	#passenger.create_tween().tween_property(self, "position:x", marker_2d_lineup.global_position.x-10, 5)
	#var tween = Tween.new()

func _on_timer_new_person_timeout():
	if(num_spawned_passengers < num_passengers):
		num_spawned_passengers += 1
		var passenger = passenger_scene.instantiate()
		passenger.passenger_number = num_spawned_passengers
		#passenger.position = Vector2i(-10, (randi_range(-1, 1) +  marker_2d_lineup.global_position.y))
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


func _on_switch_lights_switched(_state):
	# State should not be needed, we just switch
	bus_lights.enabled = !bus_lights.enabled
