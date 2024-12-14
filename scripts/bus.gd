extends Sprite2D

## Signal sent once bus arrives at stop
signal bus_arrived
## Signal sent once bus leaves stop
signal bus_leaving

@export var bus_speed : float = 100.0

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
	#lineup_entry_point = global_position + Vector2(scale.x * p.x, scale.y * p.y)
	
	# Setup what path we are on
	on_path = path_to_stop
	self.global_position = bus_stop.global_position + bus_stop.scale.x * p.get_point_position(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#self.global_position = bus_stop.global_position + on_path.global_position * bus_stop.scale.x
	if on_path:
		on_path.progress += bus_speed*delta
		global_position = on_path.global_position
		if on_path.progress_ratio >= 1: 
			#global.dprint(self, "Emitting bus_arrived_signal" )
			signals.bus_arrived.emit()
			on_path = null

func handlelightsenabled(state):
	print("Lights state switched")
	head_lights.enabled = state
	
func switch_on() -> void:
	head_lights.enabled = true

func switch_off() -> void:
	head_lights.enabled = false
