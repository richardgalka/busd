extends Node2D

@export var bus_top_speed: float = 20.0
var bus_speed: float = 0.0

@onready var bus_door_sprite: AnimatedSprite2D = $BusDoorSprite

var bus_light_switch : Node2D
var bus_door_switch : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Wait until scene tree is ready to continue
	await(get_node("/root").ready)  
	_connect_switches()

func _connect_switches() -> void:
	var dashview = get_node_or_null("%DashView")
	if dashview:
		bus_light_switch = dashview.get_switch_lights_node()
		bus_door_switch = dashview.get_switch_door_node()
		bus_light_switch.switched.connect(set_buslights)
		bus_door_switch.switched.connect(set_busdoor)

func set_buslights(_state):
	pass
	
func set_busdoor(state):
	if state:
		bus_door_sprite.switch_on()
	else:
		bus_door_sprite.switch_off()
