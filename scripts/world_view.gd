extends Node2D

@onready var dash_view: Node2D = $"../../../HBoxContainer/DashViewContainer/DashViewport/DashView"
@onready var bus_lights: PointLight2D = $Bus/HeadLights

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#   player.hit.connect(_on_player_hit.bind("sword", 100))
	printt("Viewport", get_viewport(), get_tree().root) # Game's viewport.
	printt("Current Scene", get_tree().current_scene) # Active scene root.
	#print(get_tree().root.get_tree_string())
	pass # Replace with function body.

func set_buslights_enabled(state: bool) -> void:
	bus_lights.enabled = state

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
