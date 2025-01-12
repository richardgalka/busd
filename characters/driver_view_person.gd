extends Node2D
class_name driver_view_person

signal decided_to_leave(position_number:int)
signal left
signal at_front_of_line

@export var stats : Person = null
@export var line_position : int = 0
@onready var sprite_2d: Sprite2D
var fidget_timer: Timer = null
var spawn_timer: Timer = null 
var sprite_width: int = 90
var mypath : PathFollow2D = null
var is_spawned : bool = false

## Fidget related variables
var fidget_move : Vector2 = Vector2.ZERO
var timer_trigger : bool = false
var next_move : Vector2 = Vector2.ZERO

var tbool = true
var _debug = true

func _init(person_ref:Person, spawn_order:int, person_path:PathFollow2D) -> void:
	stats = person_ref
	line_position = spawn_order
	mypath = person_path
	sprite_2d = Sprite2D.new()
	sprite_2d.z_index -= line_position
	sprite_2d.texture = stats.texture_large
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if _debug: global.dprint(self, "Debug Enabled")
	global.dprint(self, sprite_2d.texture.resource_name)

	# place our sprite in the world
	mypath.add_child(sprite_2d)
	# set our fidget timer
	#fidget_timer = Timer.new()
	#fidget_timer.wait_time = set_fidget_time()
	#fidget_timer.connect("timeout", _on_fidget_timer_timeout)
	#fidget_timer.start()
	
	# check stats and if we are to wait to get to start our process. 
	if stats.at_stop: 
		is_spawned = true
		mypath.progress = _my_final_distance()
	else:
		await get_tree().create_timer(stats.time_to_spawn).timeout
		is_spawned = true


func set_fidget_time(min_time : float = 1.0, max_time : float = 6.0) -> float:
	return randf_range(min_time, max_time)

func _my_final_distance() -> float:
	# personal space should be 0.8 times the width of our character
	return mypath.get_node("../").curve.get_baked_length() - line_position * (stats.personal_space * float(sprite_width))
	
func _final_distance() -> float:
	return mypath.get_node("../").curve.get_baked_length()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if mypath and is_spawned: 
		# get how far down math i should go
		var final_distance = _my_final_distance()
		if mypath.progress >= _my_final_distance():
			stats.at_stop = true
			# Don't move
			if tbool:
				#global.dprint(self,"my final distance: %s of %s" % [_my_final_distance(), _final_distance()])
				tbool = false
		else:
			#global.dprint(self, "I'm inline!")
			stats.at_stop = false
			# Fix for a bug when speed is too quick and mypath.progress overbounds and resets to 0
			set_path_progress(delta)
			#mypath.progress += stats.speed*delta*50
			#global.dprint(self, "progress: %s %s" % [mypath.progress, _my_final_distance()])
			#global.dprint(self,"moved %s pixels of %s pixels" % [mypath.progress, mypath.get_node("../").curve.get_baked_length()])
			global_position = floor(mypath.global_position)  # we floor due to low resoluton and partial pixels causing tearing
			#if mypath.progress_ratio >= 1:
			#	mypath.queue_free.call_deferred()
			#	mypath = null
	# add fidgeting 
	self.position = floor(self.position) + get_fidgeting()

func set_path_progress(delta: float) -> void:
	# delta is amount of seconds
	var final_distance = _my_final_distance()
	var my_movement = _my_final_distance() / delta
	'''
	10 spaces in 2 seconds if we have a frame every 1/2 second
	10 / 2 * 0.5  = 0.25
	distance / time * delta = movement
	'''
	var progress = _my_final_distance() / stats.time_to_travel * delta
	var orig_progress_ratio = mypath.progress_ratio
	mypath.progress += progress
	if mypath.progress_ratio < orig_progress_ratio:
		mypath.progress_ratio = 1.0

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
