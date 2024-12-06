extends Node2D

@onready var switch_lights: Sprite2D = $SwitchLights
@onready var switch_door: Sprite2D = $SwitchDoor
@onready var bus_drawer_handle: Sprite2D = $BusDrawer/BusDrawerHandle
@onready var drawer_animation: AnimationPlayer = $BusDrawer/DrawerAnimation
@onready var handle_cs_2d: CollisionShape2D = $BusDrawer/Handle_CS2D

var drawer_closed=true
var drawer_dragging=false

func _init() -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	print("ready switch_lights: %s" % switch_lights)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	if drawer_dragging: 
		pass
		var mp = get_global_mouse_position().y-handle_cs_2d.global_position.y
		handle_cs_2d.position.y = clamp(mp, 0, 428);
		
		# code to move the Y value of the drawer between 50 and 428
	pass

func get_switch_lights_node() -> Node2D:
	return switch_lights

func get_switch_door_node() -> Node2D:
	return switch_door

func _on_bus_drawer_mouse_entered():
	print("mouse entered")
	drawer_animation.play("highlight_drawer")

	#material.set_shader_parameter("colors", [Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1)])
	pass # Replace with function body.


func _on_bus_drawer_input_event(viewport: Node, event: InputEventMouseButton, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		print("button: %s is pressed" % event.button_index)
		drawer_dragging = true
		#if drawer_closed:
		#	drawer_animation.play("open_drawer")
		#else:
		#	drawer_animation.play_backwards("open_drawer")
		drawer_closed = !drawer_closed
	if event is InputEventMouseButton and event.is_released():
		print("button: %s is released" %event.button_index)
		drawer_dragging = false
		
	pass # Replace with function body.
