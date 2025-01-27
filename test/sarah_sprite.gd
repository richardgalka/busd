extends Sprite2D

@onready var marker_speech_bubble: Marker2D = $Marker2D_speech_location

enum State {LINING_UP, IN_LINE, BUS_DOOR, LEAVING, ENTERING_BUS, LEAVING_BUS}
var state = State.LINING_UP


@export var text_lines:Array[String] = [
	"This is a bunch of sample text. \n This is really just testing the engine and apparently slash n works for breaking lines.",
	"But what else do  you want? Anything at all and what not and what not and what not and what not ?",
	"ahhh",
	"nahh"
]

@export var text_interaction:Dictionary = {
	"text_1" : {"text" : "How is your day?", "options" : ["Great", "Bad"], "methods":["response_great", "response_bad"]},
	"text_2" : {"text" : "Sorry to hear that!"},
	"text_3" : {"text" : "Awesome! How should we celebrate??", "options" : ["Let's go out!"], "methods":["response_go_out"]},
	"text_4" : {"text" : "Nothing more to say I have.\nOkay. Thanks though\n    Do    we    do    lots   of spaces?"}
}

@export var speech_sfx: AudioStream

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		match state:
			State.LINING_UP:
				DialogueManager.start_dialog(marker_speech_bubble, global_position, text_lines, speech_sfx)
			State.IN_LINE:
				DialogueManager.start_dialog_options(marker_speech_bubble, global_position, text_interaction["text_4"], speech_sfx)
				pass
			State.BUS_DOOR:
				DialogueManager.start_dialog_options(marker_speech_bubble, global_position, text_interaction["text_1"], speech_sfx)
		
		
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func response_great() -> void:
	DialogueManager.start_dialog(marker_speech_bubble, global_position, text_lines, speech_sfx)
