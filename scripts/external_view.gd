extends Node2D

@export var difficulty : int = 10
@onready var human_silhoute_0001 = $HumanSilhoute0001
var time_left : float = 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	var vec = Vector2(50,200)
	_welcome_message()
	print (_add(3,4))
	pass # Replace with function body.

func _add(a, b):
	var sum = a+b
	return sum
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_left -= delta
	print(time_left)
	var direction = Vector2(5,1)
	print(human_silhoute_0001.global_position)
	human_silhoute_0001.global_position += direction*delta
	pass

func _welcome_message():
	print("abba")
