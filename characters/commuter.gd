extends Node2D
class_name commuter

@export var stats : Person
@onready var external: Sprite2D = $loc_external/Sprite2D_external
@onready var driverview: Sprite2D = $loc_driverview/Sprite2D_driver


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	external.texture = stats.texture_small
	driverview.texture = stats.texture_large

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:

	pass
