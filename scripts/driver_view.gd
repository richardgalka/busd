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
var ordered_commuters: Array[commuter]

var _debug = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Wait until scene tree is ready to continue
	await(get_node("/root").ready)  
	_connect_switches()

func _process(delta: float) -> void:
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
	signals.commuter_added_to_scene.connect(commuter_added)
	signals.commuter_path_setup.connect(spawn_commuter_path)

func commuter_added(passenger: commuter):
	global.dprint(self, "Commuter added to scene: %s" % commuter)
	print("here")

func spawn_commuter_path(passenger: commuter, path_follow: PathFollow2D, lined_up: bool):
	global.dprint(self, "We need to add this commuter %s to the scene" % commuter)
	
	# create a new path: 
	var new_comy_path = commuter_path_follow_2d.duplicate()
	commuter_path_to_stop.add_child(new_comy_path)
	
	# create a new character_driver_view
	var new_char = char_driver_view_scn.duplicate()
	new_comy_path.add_child(new_char)
	
	'''
	# Get sprite to add to comy path
	var commuter_sprite = passenger.stats.texture_large
	var sprite2d = Sprite2D.new()
	sprite2d.texture = commuter_sprite
	new_comy_path.add_child(sprite2d)
	'''
	
	passenger.follow_path(new_comy_path, lined_up)
	
	# Get all the details we need. 

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
