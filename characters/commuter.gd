extends Node2D
class_name commuter

@export var stats : Person = null
@export var line_position : int = 0
@onready var sprite_2d_external: Sprite2D = $loc_external/Sprite2D_external
@onready var sprite_2d_driver: Sprite2D = $loc_driverview/Sprite2D_driver
@onready var fidget_timer: Timer = $FidgetTimer

var mypath : PathFollow2D = null

var fidget_move : Vector2 = Vector2.ZERO
var timer_trigger : bool = false
var next_move : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if stats == null:
		stats = preload("res://busd/characters/person2.tres")
	sprite_2d_external.texture = stats.texture_small
	fidget_timer.start()
	
func set_fidget_time(min_time : float = 1.0, max_time : float = 6.0) -> float:
	return randf_range(min_time, max_time)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if mypath: 
		mypath.progress += stats.speed*delta
		global_position = mypath.global_position
		if mypath.progress_ratio >= 1:
			global.dprint(self, "DONE MOVING")
			mypath = null
	# add fidgeting 
	self.position = floor(self.position) + get_fidgeting()

## Follow the path that is this commuter's parent or the path provided in
func follow_path(path: PathFollow2D) -> void:
	if not path:
		mypath = self.get_node("../")
	else:
		mypath = path
	global.dprint(self, mypath)

func _on_fidget_timer_timeout():
	timer_trigger = true
	fidget_timer.wait_time = set_fidget_time(1,10)
	
func get_fidgeting() -> Vector2:
	# Jitter to make them look restless and alive. 
	if timer_trigger and mypath == null:
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
