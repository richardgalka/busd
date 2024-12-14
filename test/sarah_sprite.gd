extends Sprite2D

@export var text_lines:Array[String] = [
	"This is a bunch of sample text. \n This is really just testing the engine and apparently slash n works for breaking lines.",
	"But what else do  you want? Anything at all and what not and what not and what not and what not ?",
	"ahhh",
	"nahh"
]

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		DialogueManager.start_dialog(global_position, text_lines)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
