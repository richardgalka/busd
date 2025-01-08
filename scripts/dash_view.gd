extends Node2D

@onready var switch_lights: Sprite2D = $SwitchLights
@onready var switch_door: Sprite2D = $SwitchDoor

func _init() -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Function to pass the light switch to whomever asks about it
func get_switch_lights_node() -> Node2D:
	return switch_lights

# Function to pass the door switch to whomever asks about it
func get_switch_door_node() -> Node2D:
	return switch_door
