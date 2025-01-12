extends Sprite2D

@onready var marker_speech_bubble: Marker2D = $Marker2D_speech_location

@export var text_lines:Array[String] = [
	"This is a bunch of sample text. \n This is really just testing the engine and apparently slash n works for breaking lines.",
	"But what else do  you want? Anything at all and what not and what not and what not and what not ?",
	"ahhh",
	"nahh"
]
@export var speech_sfx: AudioStream

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		DialogueManager.start_dialog(marker_speech_bubble, global_position, text_lines, speech_sfx)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
