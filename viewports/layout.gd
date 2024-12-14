extends Control

@export var EngineTimeScale : float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Engine.time_scale = 1.0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#Engine.time_scale = EngineTimeScale
	pass
