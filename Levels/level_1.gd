extends Node2D

@export var passengers_present: int = 22
@export var passengers_arriving: int = 1
#const COMMUTER = preload("res://busd/characters/commuter.tscn")

@export var ordered_commuters: Array[commuter]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	PersonManager.passengers_arriving = passengers_arriving
	PersonManager.passengers_present = passengers_present


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
