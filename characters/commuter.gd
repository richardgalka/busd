extends Node2D
class_name commuter

# Finite State Machine Options
enum States {IDLE, RUNNING, JUMPING, FALLING, GLIDING}
# This variable keeps track of the character's current state.
var state: States = States.IDLE: set = set_state


signal decided_to_leave(position_number:int)
signal left
signal at_front_of_line

@export var stats : Person = null
@export var line_position : int = 0
@onready var sprite_2d_external: Sprite2D = $loc_external/Sprite2D_external
@onready var sprite_2d_driver: Sprite2D = $loc_driverview/Sprite2D_driver
@onready var fidget_timer: Timer = $FidgetTimer

var mypath : PathFollow2D = null

var fidget_move : Vector2 = Vector2.ZERO
var timer_trigger : bool = false
var next_move : Vector2 = Vector2.ZERO

var tbool = true
var _debug = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if stats == null:
		stats = preload("res://busd/characters/person2.tres")
	sprite_2d_external.texture = stats.texture_small
	fidget_timer.start()

func set_state(new_state: int) -> void:
	var previous_state := state
	state = new_state
	if state == States.IDLE:
		#animation_player.play("idle")
		pass
	elif state == States.RUNNING:
		#animation_player.play("run")
		pass

	# You can check both the previous and the new state to determine what to do when the state changes. This checks the previous state.
	if previous_state == States.GLIDING:
		pass

	# Here, I check the new state.
	if state == States.GLIDING:
		pass



func set_fidget_time(min_time : float = 1.0, max_time : float = 6.0) -> float:
	return randf_range(min_time, max_time)

func _my_final_distance() -> float:
	return mypath.get_node("../").curve.get_baked_length() - line_position * stats.personal_space
func _final_distance() -> float:
	return mypath.get_node("../").curve.get_baked_length()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if mypath: 
		# get how far down math i should go
		if mypath.progress >= _my_final_distance():
			# Don't move
			if tbool:
				#global.dprint(self,"my final distance: %s of %s" % [_my_final_distance(), _final_distance()])
				tbool = false
		else:
			mypath.progress += stats.speed*delta
			#global.dprint(self,"moved %s pixels of %s pixels" % [mypath.progress, mypath.get_node("../").curve.get_baked_length()])
			global_position = floor(mypath.global_position)  # we floor due to low resoluton and partial pixels causing tearing
			if mypath.progress_ratio >= 1:
				#global.dprint(self, "DONE MOVING")
				mypath.queue_free.call_deferred()
				mypath = null
	# add fidgeting 
	self.position = floor(self.position) + get_fidgeting()

## Called by signal for world recognizing commutor left
func other_comy_left(comy_num: int):
	if self.line_position > comy_num:
		#global.dprint(self, "I need to move forward")
		self.line_position -= 1
		#global.dprint(self, "Moving forward from %s to %s as I'm now number %s" % [mypath.progress, _my_final_distance(), self.line_position])
		if self.line_position == 0:
			at_front_of_line.emit()
		tbool = true
			

## Follow the path that is this commuter's parent or the path provided in
func follow_path(path: PathFollow2D, start_at_end: bool = false) -> void:
	if not path:
		mypath = self.get_node("../")
	else:
		mypath = path
	#global.dprint(self, mypath)
	# if start_at_end we set our mypath.progress to where we should be in line
	if start_at_end:
		mypath.progress = _my_final_distance()
	global_position = floor(mypath.global_position)  # we floor due to low resoluton and partial pixels causing tearing
	#global.dprint(self, "Starting at %s to %s as I'm now number %s" % [mypath.progress, _my_final_distance(), self.line_position])



func _on_fidget_timer_timeout():
	timer_trigger = true
	fidget_timer.wait_time = set_fidget_time(1,10)
	
func get_fidgeting() -> Vector2:
	# Jitter to make them look restless and alive. 
	if timer_trigger and ((mypath and mypath.progress >= _my_final_distance()) or (mypath==null)):
		#if timer_trigger and mypath == null:   # TODO: Need to update as commuters now sit in their path
		#global.dprint(self, "I twitched")
		if next_move == Vector2.ZERO:
			timer_trigger = false
			fidget_move = Vector2(randi_range(-1, 1), randi_range(-1, 1))
			next_move = -fidget_move
		else:
			fidget_move = next_move
			next_move = Vector2.ZERO
	else:
		fidget_move = Vector2.ZERO
	return fidget_move

func _create_path_exit():
	# We will not actually create a path, but a tween to leave the scene
	# By default just move left outside of window
	#self.create_tween()
	decided_to_leave.emit(line_position)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position:x", -10.0, 1)
	#tween.tween_property(self, "modulate", Color.RED, 1)
	#tween.tween_property(self, "scale", Vector2(), 1)
	tween.tween_callback(self._left)

func _left():
	left.emit()
	self.queue_free()


func _on_static_body_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("Left button was clicked at ", event.position)
			#global.dprint(self, "I'm at line position: %s" % line_position)
			_create_path_exit()
			
	pass # Replace with function body.
