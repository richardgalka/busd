extends Control
class_name OptionBoxScene

@onready var v_box_container: VBoxContainer = $MarginContainer/MarginContainer/VBoxContainer

@export_category("Size")
@export var max_width: int = 256
var option_items: Dictionary
const TALK_THEME = preload("res://busd/ui/talk_theme.tres")

#var scale: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.

var _debug = true

func _ready() -> void:
	
	global.dprint(self, "Option Box ready!")
	# debug
	#display_options({"options":[
	#	["text1", self.option_chose],
	#	["Come on in", self.option_chose],
	#	["Go F**K yourself lady!", self.option_chose]
	#	]})



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func option_chose() -> void:
	print("option chosen")


func display_options(options: Dictionary, location: Vector2 = Vector2(0,0)) -> void:
	# options layout: 	"text_1" : {"text" : "How is your day?", "options" : [["Great", "Bad"], "methods":["response_great", "response_bad]},
	#@await resized
	option_items = options
	for option in options['options']:
		var button = Button.new()
		button.theme
		button.text = option[0]
		#button.pressed.connect(option[1])
		button.pressed.connect(_handle_button_press.bind(option[1]))
		button.theme = TALK_THEME
		v_box_container.add_child(button)
		var anim_comp = AnimationComponent.new()
		anim_comp.from_center = true
		anim_comp.default_scale = Vector2(1,1)
		anim_comp.time = 0.1
		anim_comp.transition = 0
		anim_comp.hover_scale = Vector2(1.13, 1)
		button.add_child(anim_comp)
	global_position = location
	
func _handle_button_press(method:Callable) -> void:
	# Need to free the text box and the options box
	#DialogueManager.end_dialog()
	#method.call_deferred()
	DialogueManager.end_dialog.call_deferred()
