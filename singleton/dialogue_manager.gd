extends Node

@onready var text_box_scene = preload("res://busd/Scene/text_box_scene.tscn")

var dialog_lines: Array[String] = []

var current_line_index = 0

var text_box: TextBoxScene
var text_box_position
var text_box_marker: Marker2D

var is_dialog_active = false
var can_advance_line = false

var sfx: AudioStream

func start_dialog(marker: Marker2D, position: Vector2, lines: Array[String], speech_sfx: AudioStream):
	if is_dialog_active:
		return
	dialog_lines = lines
	#text_box_position = position
	text_box_position = marker.global_position
	sfx = speech_sfx
	text_box_marker = marker
	_show_text_box()
	print("Position: %s" % position)
	print("Char pos: %s" % marker.global_position)
	
	is_dialog_active = true
	
func _show_text_box():
	text_box = text_box_scene.instantiate()
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	get_tree().root.add_child(text_box)   # use root so it displays about all subviews
	#text_box_marker.add_child(text_box)
	#text_box.global_position = text_box_position
	text_box.global_position = Vector2(400,400)
	#text_box.global_position = get_tree()
	
	text_box.display_text(dialog_lines[current_line_index], sfx)
	can_advance_line = false
	
func _on_text_box_finished_displaying():
	can_advance_line = true
	
func _unhandled_input(event: InputEvent) -> void:
	if (
		event.is_action_pressed("advance_dialogue") && 
		is_dialog_active && 
		can_advance_line
	):
		text_box.queue_free()
		
		current_line_index += 1
		if current_line_index >= dialog_lines.size():
			is_dialog_active = false
			current_line_index = 0 
			return
		_show_text_box()
	pass
