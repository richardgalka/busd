extends CharacterBody2D

signal bus_stop_line_entered(body:Node2D)
signal bus_stop_line_left(body:Node2D)

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var bus_stop: Node2D = $".."


func _ready() -> void:
	#bus_stop.bus_stop_line_entered.connect(entered)
	bus_stop.bus_stop_line_linedup.connect(linedup)
	bus_stop.bus_stop_line_touched.connect(touched)
	bus_stop.register(self)
	
func entered(body, busstop):
	if self == body:
		print("I've entered")
	
func linedup(body, busstop):
	if self == body:
		print("I've linedup")
	
func touched(body, busstop):
	if self == body:
		print("I've touched, better lineup")
		var temp_tween = body.create_tween()
		# TODO: calculate speed by checking player speed and then checking distance to lineup_entry_point and calculating time to move
		temp_tween.tween_property(body, "global_position", busstop.lineup_entry_point, 0.4)
		temp_tween.tween_callback(_move_to_spot_and_signal.bind(busstop))

func _move_to_spot_and_signal(busstop):
	# better register me to busstop
	print("singal lined_up")
	bus_stop_line_entered.emit(self)
	pass


func _physics_process(delta: float) -> void:
	# Add the gravity.

	# Handle jump.

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var xdirection := Input.get_axis("ui_left", "ui_right")
	var ydirection := Input.get_axis("ui_up", "ui_down")
	if xdirection:
		velocity.x = xdirection * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if ydirection:
		velocity.y = ydirection * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()
