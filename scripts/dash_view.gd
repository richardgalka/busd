extends Node2D

@onready var switch_lights: Sprite2D = $SwitchLights
@onready var switch_door: Sprite2D = $SwitchDoor

func _init() -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass

func lights_off() -> bool:
	return switch_lights.switch_state

func get_lights_node() -> Node2D:
	return switch_lights

func get_door_node() -> Node2D:
	return switch_door

func _on_bus_drawer_mouse_entered():
	print("mouse entered")

	#material.set_shader_parameter("colors", [Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1)])
	pass # Replace with function body.
