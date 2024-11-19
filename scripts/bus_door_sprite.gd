extends AnimatedSprite2D
@onready var bus_door_open: AudioStreamPlayer = $BusDoorOpen
@onready var bus_door_close: AudioStreamPlayer = $BusDoorClose

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func switch_on():
	play("Open")
	bus_door_open.play()

func switch_off():
	play_backwards("Open")
	bus_door_close.play()
