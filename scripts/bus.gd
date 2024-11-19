extends Sprite2D

@onready var head_lights: PointLight2D = $HeadLights


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var bus_lights_node = get_node(%SwitchLights)
	#var bus_lights_node = get_tree().get_root().find_node("Enemy",true,false)
	#global.bus_lights_switched.connect(handlelightsenabled)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


# signal switched(state)
func handlelightsenabled(state):
	print("Lights state switched")
	head_lights.enabled = state
	
func switch_on() -> void:
	head_lights.enabled = true

func switch_off() -> void:
	head_lights.enabled = false
