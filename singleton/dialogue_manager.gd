extends Node

@onready var text_box_scene = preload("res://busd/Scene/text_box_scene.tscn")


var dialog_options: Dictionary = {}

var dialog_lines: Array[String] = []

var current_line_index = 0

var text_box: TextBoxScene = null
var text_box_position
var text_box_marker: Marker2D

var is_dialog_active = false
var can_advance_line = false

var sfx: AudioStream
var options_dialogue_object := {}

var option_chose = true


func start_dialog_options(marker: Marker2D, position: Vector2, line_options: Dictionary, speech_sfx: AudioStream):
	if is_dialog_active: return
	# Expect line	{"text" : "How is your day?", "options" : ["Great", "Bad"], "methods":["response_great", "response_bad"]},
	options_dialogue_object = line_options
	if line_options.has("options"):
		option_chose = false
		# need to add button of option
		pass
	text_dialog(marker, position, [line_options["text"],], speech_sfx)  # Assuem we have to have text key


func text_dialog(marker: Marker2D, position: Vector2, lines: Array[String], speech_sfx: AudioStream) -> bool:
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
	
	
func _show_text_box():
	text_box = text_box_scene.instantiate()
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	get_tree().root.add_child(text_box)   # use root so it displays about all subviews
	text_box.global_position = text_box_position
	text_box.display_text(dialog_lines[current_line_index], sfx, options_dialogue_object)
	can_advance_line = false

func _on_text_box_finished_displaying():
	can_advance_line = true
	

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("advance_dialogue") && is_dialog_active):
		print("can advance? %s" % can_advance_line)
		if (can_advance_line && option_chose):
			text_box.queue_free()
			current_line_index += 1
			if current_line_index >= dialog_lines.size():
				is_dialog_active = false
				current_line_index = 0 
				return
			_show_text_box()
		else:
			# Can't advance line so speed up text
			text_box.fast_forward()
	pass
