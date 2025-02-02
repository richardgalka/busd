extends Node

#@onready var text_box_scene = preload("res://busd/Scene/text_box_scene.tscn")
const TEXT_BOX_SCENE = preload("res://busd/Scene/text_box_scene.tscn")
const OPTION_BOX = preload("res://busd/Scene/option_box.tscn")


var dialog_lines: Array = []

var current_line_index = 0

var text_box: TextBoxScene = null
var text_box_position
var text_box_marker: Marker2D

var is_dialog_active = false
var can_advance_line = false

var sfx: AudioStream
var options_dialogue_object := {}

var options_displayed = false
var option_chose = true

# Option box vars
var options_box: OptionBoxScene
var options_box_offset: Vector2 = Vector2(-10, -8)


func start_dialog_options(marker: Marker2D, position: Vector2, line_options: Dictionary, speech_sfx: AudioStream):
	if is_dialog_active: 
		return
	# Expect line	{"text" : "How is your day?", "options" : ["Great", "Bad"], "methods":["response_great", "response_bad"]},
	options_dialogue_object = line_options
	if line_options.has("options"):
		option_chose = false
		# need to add button of option
		pass
	# ensure text_lines is an array of strings
	var text_lines = line_options["text"]
	if typeof(text_lines) == TYPE_STRING:
		text_lines = [text_lines, ]

	text_dialog(marker, position, text_lines, speech_sfx)  # Assuem we have to have text key


func text_dialog(marker: Marker2D, position: Vector2, lines: Array, speech_sfx: AudioStream) -> bool:
	if is_dialog_active:
		return false
	dialog_lines = lines
	#text_box_position = position
	text_box_position = Vector2(marker.global_position.x, marker.global_position.y*2)
	sfx = speech_sfx
	text_box_marker = marker
	_show_text_box()
	print("Position: %s" % position)
	print("Char pos: %s" % marker.global_position)
	
	is_dialog_active = true
	return true
	
func start_dialog(marker: Marker2D, position: Vector2, lines: Array[String], speech_sfx: AudioStream) -> bool:
	return text_dialog(marker, position, lines, speech_sfx)
	
func end_dialog() -> void:
	is_dialog_active = false
	if options_box:
		options_box.queue_free()
	if text_box:
		text_box.queue_free()
	current_line_index = 0
	
	
func _show_text_box():
	if current_line_index < dialog_lines.size():
		text_box = TEXT_BOX_SCENE.instantiate()
		text_box.finished_displaying.connect(_on_text_box_finished_displaying)
		get_tree().root.add_child(text_box)   # use root so it displays about all subviews
		text_box.global_position = text_box_position
		text_box.display_text(dialog_lines[current_line_index], sfx, options_dialogue_object)
		can_advance_line = false

func _on_text_box_finished_displaying():
	can_advance_line = true
	if !option_chose and current_line_index >= dialog_lines.size()-1: 
		options_box = OPTION_BOX.instantiate()
		#options_box.
		get_tree().root.add_child(options_box)
		#text_box.add_child(options_box)
		var text_box_bot_right = text_box_position \
									+ Vector2(text_box.size.x/2, text_box.size.y) \
									+ options_box_offset
		options_box.display_options(options_dialogue_object, text_box_bot_right)

	

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("advance_dialogue") and is_dialog_active):
		print("can advance? %s" % can_advance_line)
		if can_advance_line:
			print("current_line_index: %s, dialog_lines.size: %s, option_chose: %s" % [current_line_index, dialog_lines.size(), option_chose])
			#current_line_index += 1
			if current_line_index+1 < dialog_lines.size():
				# We can display one more line! 
				current_line_index +=1
				text_box.queue_free()
				_show_text_box()
			else:
				if option_chose:
					end_dialog()
		else: 
			text_box.fast_forward()
