extends Control
@onready var v_box_container: VBoxContainer = $MarginContainer/MarginContainer/VBoxContainer

@export_category("Size")
@export var max_width: int = 256
var option_items: Dictionary
const TALK_THEME = preload("res://busd/ui/talk_theme.tres")

#var scale: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.

var _debug = true

func _ready() -> void:
	
	global.dprint(self, "ready!")
	# debug
	display_options({"options":[
		["text1", self.option_chose],
		["Come on in", self.option_chose],
		["Go F**K yourself lady!", self.option_chose]
		]})


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func option_chose() -> void:
	print("option chosen")


func display_options(options: Dictionary):
	# options layout: 	"text_1" : {"text" : "How is your day?", "options" : ["Great", "Bad"], "methods":["response_great", "response_bad"]},
	#@await resized
	option_items = options
	for option in options['options']:
		var button = Button.new()
		button.theme
		button.text = option[0]
		button.pressed.connect(option[1])
		button.theme = TALK_THEME
		v_box_container.add_child(button)
		var anim_comp = AnimationComponent.new()
		anim_comp.from_center = true
		anim_comp.default_scale = Vector2(1,1)
		anim_comp.time = 0.3
		anim_comp.transition = 11
		anim_comp.hover_scale = Vector2(1.1, 1.01)
		button.add_child(anim_comp)
		
		
