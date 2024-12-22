extends Sprite2D

## Signal sent once bus arrives at stop
signal bus_arrived
## Signal sent once bus leaves stop
signal bus_leaving

@export var bus_max_speed : float = 400.0  # initial speed of bus
@export var bus_min_speed : float = 10.0  # Minimum speed when bus is stopped. 
@export var deceleration_factor: float = 0.95 # Factor by which speed decreases each frame
var curve_length: float = 0.0 # Total length of the path curve

@onready var bus_path_to_stop: Path2D = $"../BusStop/BusPathToStop"
@onready var head_lights: PointLight2D = $HeadLights
@onready var path_to_stop: PathFollow2D = $"../BusStop/BusPathToStop/PathFollow2D"
@onready var path_to_exit: PathFollow2D = $"../BusStop/BusPathToExit/PathFollow2D"
@onready var bus_stop: Node2D = $"../BusStop"

var on_path: PathFollow2D
var _debug = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# set bus direction based on BusPathToStop direction
	var p = bus_path_to_stop.curve
	if p.get_point_position(0).x > p.get_point_position(p.point_count-1).x:
		self.flip_h = true
	else:
		self.flip_h = false
	
	# Setup what path we are on
	on_path = path_to_stop
	self.global_position = bus_stop.global_position + bus_stop.scale.x * p.get_point_position(0)
	
func set_path(path:PathFollow2D):
	on_path = path
	var parent_path : Path2D = on_path.get_parent()
	curve_length = parent_path.curve.get_baked_length()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if on_path:
		# Calc the deceleration effect
		var distance_remaining = 1.0 - on_path.progress_ratio
		var speed_factor = ease(distance_remaining, 0.3)

		var current_speed = max(speed_factor * bus_max_speed, bus_min_speed)
		on_path.progress += current_speed * delta
		global_position = on_path.global_position
		
		if on_path.progress_ratio >= 1: 
			signals.bus_arrived.emit()
			on_path = null

func handlelightsenabled(state):
	print("Lights state switched")
	head_lights.enabled = state
	
func switch_on() -> void:
	head_lights.enabled = true

func switch_off() -> void:
	head_lights.enabled = false
