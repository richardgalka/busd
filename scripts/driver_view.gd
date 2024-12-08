extends Node2D

@export var bus_top_speed: float = 20.0
var bus_speed: float = 0.0
@onready var bus_door_sprite: AnimatedSprite2D = $BusDoorBackground/BusDoorSprite
@onready var busdriverviewroad: Sprite2D = $Parallax2D/Busdriverviewroad

var bus_light_switch : Node2D
var bus_door_switch : Node2D

#var world_view : Node2D
#var dash_view : Node2D

@onready var world_view: Node2D = %WorldView
@onready var dash_view: Node2D = %DashView
var ordered_commuters: Array[commuter]


var _debug = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Wait until scene tree is ready to continue
	await(get_node("/root").ready)  
	_connect_switches()

func _process(delta: float) -> void:
	# Check if we have signal connected for the first person. 
	
	
	pass



func _connect_switches() -> void:
	dash_view = get_node_or_null("%DashView")
	world_view = get_node_or_null("%WorldView")
	if dash_view:
		global.dprint(self, "dashview connected")
		bus_light_switch = dash_view.get_switch_lights_node()
		bus_door_switch = dash_view.get_switch_door_node()
		bus_light_switch.switched.connect(set_buslights)
		bus_door_switch.switched.connect(set_busdoor)
	if world_view:
		global.dprint(self, "world view connected")
		global.dprint(self, world_view.ordered_commuters)
		ordered_commuters = world_view.ordered_commuters
		
		
	signals.bus_arrived.connect(bus_arrived)
	signals.bus_leaving.connect(bus_leaving)

func bus_arrived():
	#driving.stop()
	pass
	
func bus_leaving():
	#driving.start()
	pass
	
func set_buslights(_state):
	global.dprint(self, world_view.ordered_commuters)

	pass
	
func set_busdoor(state):
	if state:
		bus_door_sprite.switch_on()
	else:
		bus_door_sprite.switch_off()
