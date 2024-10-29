extends Node2D


# Define the range for the number of passengers arriving
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
#@onready var marker_2d_lineup = get_node("./Marker2d_lineup")
#@onready var player_node = get_node("/root/main_scene/Player")
#@onready var player_node = get_node("/root/main_scene/Player")
#@onready var player_node = get_node("/root/main_scene/Player")



var time_left : float = 5.0

# Preload the HumanSilhoute scene
var passenger_scene = preload("res://busd/Scene/human_silhoute.tscn")

func _ready():
	# Call the function to start generating passengers
	#generate_passengers()
	num_passengers = generate_random_passengers(min_passengers, max_passengers)
	print("Number of passengers arriving at bus stop: ", num_passengers)

# Function to generate a random number of passengers
func generate_random_passengers(min: int, max: int) -> int:
	return randi() % (max - min + 1) + min

# Function to move a passenger along the X axis
func move_passenger(passenger):
	passenger.create_tween().tween_property(self, "position:x", marker_2d_lineup.global_position.x-10, 5)
	print("moving passenger #")
	var tween = Tween.new()
	#tween.tween_property(self, "position:x", marker_2d_lineup.global_position.x-10, 5)
	#add_child(tween)
	#tween.interpolate_property(passenger, "position:x", passenger.position.x, self.rect_size.x + passenger.rect_size.x, 5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	#tween.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_timer_new_person_timeout():
	print("TIMER")
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
