extends Node2D

signal bus_stop_line_touched(body, busstop)
#signal bus_stop_line_entered(body, busstop)
signal bus_stop_line_linedup(body, busstop)
 
@onready var bus_stop: Node2D = $"."


@export_group("Bus Stop Textures")
@export var texture_far : CompressedTexture2D = preload("res://aseprite/sign.png")
@export var texture_close : CompressedTexture2D = preload("res://aseprite/bus_stop.png")
@onready var bus_stop_sprite_close: Sprite2D = $Lineup/BusStopSpriteClose
@onready var bus_stop_sprite_far: Sprite2D = $Lineup/BusStopSpriteFar


@export_group("Commutors")
@export var max_people : int = 6
@export var people : Array [Node] = []
@export var stand_distance : int = 2

@onready var lineup: Path2D = $Lineup
@onready var path_follow_2d: PathFollow2D = $Lineup/PathFollow2D

@onready var path_follow_2d_2: PathFollow2D = $Lineup/PathFollow2D2

var lineup_entry_point: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set bus stop textures from exports so we don't always have to use defaults
	bus_stop_sprite_close.texture = texture_close
	bus_stop_sprite_close.visible = false
	bus_stop_sprite_far.texture = texture_far
	#Need to add up all parents to get proper position
	lineup_entry_point = lineup.global_position+path_follow_2d.position+lineup.curve.get_point_position(0)

	
	# Move or copy human silhoute to path
	# Do this on a signal that human has entered bus point2d


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	#something entered our busstop lineup
	print("Something entered our busstop lineup %s " % body)
	if body.is_in_group("commuter"):
		print("A commuter is here!")
		# signal_out
		print("emitting touched")
		bus_stop_line_touched.emit(body, bus_stop)
		# create tween
		#var temp_tween = body.create_tween()
		# TODO: calculate speed by checking player speed and then checking distance to lineup_entry_point and calculating time to move
		#temp_tween.tween_property(body, "global_position", lineup_entry_point, 0.4)
		#temp_tween.tween_callback(_move_to_spot_and_signal.bind(body))

		
func _move_to_spot_and_signal(body) -> void:
	# We are now moved to beginning of line
	#bus_stop_line_entered.emit(body, bus_stop)
	print("bus_stop_line_entered_emitted")
	# Now we start the movement
	# Find out where body should move to.
	
func register(body):
	# let's register some signals for this body
	body.bus_stop_line_entered.connect(_entered)
	body.bus_stop_line_left.connect(_left)
	
func _entered(body):
	print("%s entered busstop" % body)
	
func _left(body):
	print("%s body left busstop" % body)
	
	
	
	
#signal bus_stop_line_touched(body)
#signal bus_stop_line_entered(body)
#signal bus_stop_line_linedup(body)
