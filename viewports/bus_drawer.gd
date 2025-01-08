extends StaticBody2D

var drawer_dragging=false

@onready var drawer_animation: AnimationPlayer = $DrawerAnimation
@onready var handle_cs_2d: CollisionShape2D = $Handle_CS2D
@onready var audio_bus_drawer_open: AudioStreamPlayer = $Handle_CS2D/AudioBusDrawerOpen
@onready var audio_bus_drawer_mid: AudioStreamPlayer = $Handle_CS2D/AudioBusDrawerMid
@onready var audio_bus_drawer_close: AudioStreamPlayer = $Handle_CS2D/AudioBusDrawerClose

var mouse_loc : Vector2

@export var drawer_min_y:int = 20
@export var drawer_max_y:int = 400
var _debug = false
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	pass # Replace with function body.

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton and event.is_released() and drawer_dragging:
		drawer_dragging = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if mouse_loc and drawer_dragging:
		var new_mouse_loc = get_global_mouse_position()
		var new_loc = new_mouse_loc.y - mouse_loc.y
		mouse_loc = new_mouse_loc
		#global.dprint(self, "Mouse movement: %s" % new_loc)
		handle_cs_2d.position.y = clampf(handle_cs_2d.position.y + new_loc, drawer_min_y, drawer_max_y)

func _on_bus_drawer_input_event(_viewport: Node, event: InputEventMouseButton, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		mouse_loc = event.position
		print("button: %s is pressed" % event.button_index)
		drawer_dragging = true
		audio_bus_drawer_open.finished.connect(_continue_drawer_sound)
		audio_bus_drawer_open.play()
		#	bus_move_animation_player.animation_finished.connect(bus_state_set)
	if event is InputEventMouseButton and event.is_released():
		print("button: %s is released" %event.button_index)
		drawer_dragging = false

func _continue_drawer_sound():
	if drawer_dragging: 
		audio_bus_drawer_mid.finished.connect(_continue_drawer_sound)
		audio_bus_drawer_mid.play()
	else: 
		audio_bus_drawer_close.play()

func _on_mouse_entered() -> void:
	#global.dprint(self, "mouse entered")
	drawer_animation.play("highlight_drawer")


# TODO: credit Pixabay for drawer sound
