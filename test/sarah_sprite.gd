extends Sprite2D

@onready var marker_speech_bubble: Marker2D = $Marker2D_speech_location

enum State {LINING_UP, IN_LINE, BUS_DOOR, LEAVING, ENTERING_BUS, LEAVING_BUS}
var state = State.BUS_DOOR


@export var text_lines:Array[String] = [
	"I'm really sorry to hear that!",
	"Perhaps there is something you can do?\nGo see a therapist perhaps?",
	"Well... just stop being a doo doo head. Okay? Okay!"
]

@export var text_interaction:Dictionary = {
	"text_1" : {"text" : ["How is your day?", "I hope it's going well!"], "options" : [["Great", option_great], ["Bad", option_bad]]},
	"text_2" : {"text" : "Sorry to hear that!"},
	"text_3" : {"text" : "Awesome! How should we celebrate??", "options" : ["Let's go out!"], "methods":["response_go_out"]},
	"text_4" : {"text" : "Nothing more to say I have.\nOkay. Thanks though\n    Do    we    do    lots   of spaces?"},
	"text_5" : {"text" : "Did you want me to go away?", "options": [["Yes!", self.queue_free], ["No", nothing]]}
}

@export var speech_sfx: AudioStream

func nothing():
	pass

func option_great():
	print("option great selected")
	DialogueManager.start_dialog_options(marker_speech_bubble, global_position, text_interaction["text_5"], speech_sfx)

func option_bad():
	print("option bad selected")
	DialogueManager.start_dialog(marker_speech_bubble, global_position, text_lines, speech_sfx)


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
