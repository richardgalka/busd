extends MarginContainer

@onready var label: Label = $MarginContainer/Label
@onready var letter_display_timer: Timer = $LetterDisplayTimer

@export_category("Size")
@export var max_width: int = 256

@export_category("Spacing")
@export var height_above: int = 60

@export_category("Text Timing")
@export var letter_time: float = 0.03
@export var space_time: float = 0.06
@export var punctuation_time: float = 0.2

signal finished_displaying

var text = ""
var letter_index = 0


func display_text(text_to_display: String):
	text = text_to_display
	label.text = text_to_display
	
	await resized
	
	custom_minimum_size.x = min(size.x, max_width)

	if size.x > max_width:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		await resized # Await X resize
		await resized # Await Y resize
		custom_minimum_size.y = size.y
	global_position.x -= size.x / 2.0
	global_position.y = size.y - height_above
	
	label.text = ""
	_display_letter()

func _display_letter():
	label.text += text[letter_index]
	letter_index += 1
	if letter_index >= text.length():
		finished_displaying.emit()
		return
		
	match text[letter_index]:
		"!", "?", ",", ".":
			letter_display_timer.start(punctuation_time)
		" ":
			letter_display_timer.start(space_time)
		_:
			letter_display_timer.start(letter_time)
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_letter_display_timer_timeout() -> void:
	_display_letter()
	pass # Replace with function body.
