extends MarginContainer
class_name TextBoxScene


@onready var label: Label = $MarginContainer/Label
@onready var letter_display_timer: Timer = $LetterDisplayTimer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@export_category("Size")
@export var max_width: int = 256

@export_category("Spacing")
@export var height_above: int = 60

@export_category("Text Timing")
@export var letter_time: float = 0.05
@export var space_time: float = 0.09
@export var punctuation_time: float = 0.3
@export var fast_forward_rate: float = 5.0

signal finished_displaying

var text = ""
var letter_index = 0
var forward_rate := 1.0

func _ready() -> void:
	scale = Vector2.ZERO
	forward_rate = 1.0

func display_text(text_to_display: String, speech_sfx: AudioStream):
	text = text_to_display
	label.text = text_to_display
	audio_stream_player.stream = speech_sfx
	forward_rate = 1.0
	
	await resized
	
	custom_minimum_size.x = min(size.x, max_width)

	if size.x > max_width:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		await resized # Await X resize
		await resized # Await Y resize
		custom_minimum_size.y = size.y
	
	label.text = ""
	# expand box
	pivot_offset = Vector2(size.x/2, size.y)
	var tween = self.create_tween()
	tween.tween_property(self, "scale", Vector2(1,1), 0.15).set_trans(Tween.TRANS_BACK)
	
	_display_letter()

func _display_letter():
	label.text += text[letter_index]
	letter_index += 1
	if letter_index >= text.length():
		finished_displaying.emit()
		return
		
	match text[letter_index]:
		"!", "?", ",", ".":
			letter_display_timer.start(punctuation_time / forward_rate)
		" ":
			letter_display_timer.start(space_time / forward_rate)
		_:
			letter_display_timer.start(letter_time / forward_rate)
			var new_audio_player:AudioStreamPlayer = audio_stream_player.duplicate()
			new_audio_player.pitch_scale += randf_range(-0.1, 0.1)
			if text[letter_index] in ['a', 'e','i','o','u']:
				new_audio_player.pitch_scale += 0.2
			get_tree().root.add_child(new_audio_player)
			new_audio_player.play()
			await new_audio_player.finished
			new_audio_player.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func fast_forward(rate:float = fast_forward_rate) -> void:
	forward_rate = rate

func _on_letter_display_timer_timeout() -> void:
	_display_letter()
	pass # Replace with function body.
