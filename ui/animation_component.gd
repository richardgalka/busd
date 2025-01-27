extends Node
class_name AnimationComponent

@export var from_center : bool = true
@export var hover_scale : Vector2 = Vector2.ONE
@export var time : float = 0.1
@export var transition : Tween.TransitionType

var target : Control
var default_scale : Vector2

var _debug = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = get_parent()
	call_deferred("setup")
	setup()

func connect_signals() -> void:
	target.mouse_entered.connect(on_hover)
	target.mouse_exited.connect(off_hover)
	target.focus_entered.connect(on_hover)
	target.focus_exited.connect(off_hover)

func setup() -> void:
	if from_center:
		target.pivot_offset = target.size / 2
	default_scale = target.scale
	connect_signals()


func on_hover() -> void:
	print("on_hover")
	add_tween("scale", hover_scale, time)
	
func off_hover() -> void: 
	add_tween("scale", default_scale, time)
	
func add_tween(property: String, value, seconds: float) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(target, property, value, seconds).set_trans(transition)
