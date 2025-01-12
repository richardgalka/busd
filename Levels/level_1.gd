extends Node2D

## Level needs to be loaded prior to everything else

@export var passengers_present: int = 5
@export var passengers_arriving: int = 5
#const COMMUTER = preload("res://busd/characters/commuter.tscn")
@onready var passenger_arrive_timer: Timer = $PassengerArriveTimer
@export var ordered_commuters: Array[Person]

var _debug = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if _debug: global.dprint(self, "Debug Enabled")
	pass # Replace with function body.
	PersonManager.passengers_arriving = passengers_arriving
	PersonManager.passengers_present = passengers_present
	PersonManager.initialize_commuters(ordered_commuters)
	
	print(self, "person manager setup")
	global.dprint(self, "PersonManager setup")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
