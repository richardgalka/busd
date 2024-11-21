extends CharacterBody2D

signal bus_stop_line_entered(body:Node2D)
signal bus_stop_line_left(body:Node2D)

@export var SPEED : float = 300.0
@onready var bus_stop: Node2D = $".."
@export var char_speed : float = 2.0

var pathfollow : PathFollow2D = null


func _ready() -> void:
	_register_bustop_methods()

func _process(delta: float) -> void:
	if pathfollow:
		pathfollow.progress += char_speed*delta
		global_position = pathfollow.global_position
		if pathfollow.progress_ratio >= 100: 
			global.dprint(self, "DONE MOVING")
			



### Bus Stop Functions
func _register_bustop_methods():
	bus_stop.bus_stop_line_linedup.connect(linedup)
	bus_stop.bus_stop_line_touched.connect(touched)
	bus_stop.bus_stop_line_up.connect(_move_down_path)

	bus_stop.register(self)

func _move_down_path(body:Node2D, path:PathFollow2D):
	if body == self:
		pathfollow = path
		global.dprint(self, "I have path to follow")
	
	
func linedup(body, busstop):
	if self == body:
		print("I've linedup")
	
func touched(body, busstop):
	if self == body:
		print("%s: I've touched, better lineup" % self)
		var temp_tween = body.create_tween()
		# TODO: calculate speed by checking player speed and then checking distance to lineup_entry_point and calculating time to move
		temp_tween.tween_property(body, "global_position", busstop.lineup_entry_point, 0.4)
		temp_tween.tween_callback(_move_to_spot_and_signal.bind(busstop))

func _move_to_spot_and_signal(busstop):
	# better register me to busstop
	print("%s: singal lined_up" % self)
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
