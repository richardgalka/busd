extends Node2D

@export var bus_top_speed: float = 20.0
var bus_speed: float = 0.0
@onready var bus_door_sprite: AnimatedSprite2D = $BusDoorBackground/BusDoorSprite
@onready var busdriverviewroad: Sprite2D = $Parallax2D/Busdriverviewroad
@onready var commuter_path_to_stop: Path2D = $CommuterPathToStop
@onready var commuter_path_follow_2d: PathFollow2D = $CommuterPathToStop/CommuterPathFollow2D

@export_group("Same as bus.gd World View Please")
@export var bus_max_speed : float = 400.0  # initial speed of bus
@export var bus_min_speed : float = 10.0  # Minimum speed when bus is stopped. 
@export var bus_acceleration_curve: float = 0.3 # Factor by which speed decreases each frame

var char_driver_view_scn = preload("res://busd/Scene/character_driver_view.tscn").instantiate()

var bus_light_switch : Node2D
var bus_door_switch : Node2D

@onready var world_view: Node2D = %WorldView
@onready var dash_view: Node2D = %DashView

var _debug = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if _debug: global.dprint(self, "Debug Enabled")
	# Wait until scene tree is ready to continue
	await(get_node("/root").ready)  
	_connect_switches()
	
	global.dprint(self, "Passengers: %s" % len(PersonManager.ordered_commuters))
	
	# Add passengers to scene
	var i := 0
	for passenger in PersonManager.ordered_commuters:
		i = i+1
		place_commuter_on_path(passenger, i)
	

func place_commuter_on_path(passenger:Person, line_position:int):
	var commuter_path = commuter_path_follow_2d.duplicate()
	var commuter = driver_view_person.new(passenger, line_position, commuter_path)
	commuter_path_to_stop.add_child(commuter_path)
	commuter_path.add_child(commuter)

func _process(_delta: float) -> void:
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
		#ordered_commuters = world_view.ordered_commuters
	signals.bus_arrived.connect(bus_arrived)
	signals.bus_leaving.connect(bus_leaving)



func bus_arrived():
	#driving.stop()
	pass
	
func bus_leaving():
	#driving.start()
	pass
	
func set_buslights(_state):
	pass
	
func set_busdoor(state):
	if state:
		bus_door_sprite.switch_on()
	else:
		bus_door_sprite.switch_off()
