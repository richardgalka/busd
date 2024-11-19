extends Node2D

@onready var bus_lights: PointLight2D = $Bus/HeadLights

var bus_light_switch: Node2D
var bus_door_switch: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Wait until scene tree is ready to continue
	await(get_node("/root").ready)  
	_connect_switches()

func _connect_switches() -> void:
	bus_light_switch = %DashView.get_switch_lights_node()
	bus_door_switch = %DashView.get_switch_door_node()
	bus_light_switch.switched.connect(set_buslights)
	bus_door_switch.switched.connect(set_busdoor)
	
func set_buslights(state):
	bus_lights.enabled = state

func set_busdoor(state):
	#bus_door.enabled = state
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
