extends Node2D

## Triggers as soon as a body touched our area2d
signal bus_stop_line_touched(body:Node2D, busstop:Node2D)
## Triggers to tell the commuter to line up (once they get to start of busline
signal bus_stop_line_up(body:Node2D, path:PathFollow2D, pos_number:int)
## Triggers when person is linedup
signal bus_stop_line_linedup(body:Node2D, busstop:Node2D)
 
@export_group("Debug")
@export var debug : bool = true

@export_group("Bus Stop Textures")
@export var texture_far : CompressedTexture2D = preload("res://aseprite/sign.png")
@export var texture_close : CompressedTexture2D = preload("res://aseprite/bus_stop.png")
@onready var bus_stop_sprite_close: Sprite2D = $Lineup/BusStopSpriteClose
@onready var bus_stop_sprite_far: Sprite2D = $Lineup/BusStopSpriteFar


@onready var lineup: Path2D = $Lineup
var path_follows : Array[PathFollow2D] = []

#testing
@onready var path_follow_2d: PathFollow2D = $Lineup/PathFollow2D
@onready var path_follow_2d_2: PathFollow2D = $Lineup/PathFollow2D2

var lineup_entry_point: Vector2

func dprint(data):
	if debug: print(self, data)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set bus stop textures from exports so we don't always have to use defaults
	bus_stop_sprite_close.texture = texture_close
	bus_stop_sprite_close.visible = false
	bus_stop_sprite_far.texture = texture_far
	#Setup bus lineup position (take into account scaling)
	var p = lineup.curve.get_point_position(0)
	lineup_entry_point = global_position + Vector2(scale.x * p.x, scale.y * p.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#if anything in path_follows
	
	#Move it at some speed
	
	#Stop at end-user_postion*width
	
	#Remove the path_follow once we are at end
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	#something entered our busstop lineup
	if body.is_in_group("commuter"):
		dprint("A commuter is here!")
		dprint("emitting touched")
		# signal_out
		bus_stop_line_touched.emit(body, self)
		# create tween
		#var temp_tween = body.create_tween()
		# TODO: calculate speed by checking player speed and then checking distance to lineup_entry_point and calculating time to move
		#temp_tween.tween_property(body, "global_position", lineup_entry_point, 0.4)
		#temp_tween.tween_callback(_move_to_spot_and_signal.bind(body))

	
		
func _move_to_spot_and_signal(body) -> void:
	# We are now moved to beginning of line
	dprint("bus_stop_line_entered_emitted")
	# Now we start the movement
	# Find out where body should move to.
	
func register(body):
	dprint("registered %s" % body)
	# let's register some signals for this body
	# To be called by an external commutor that want's to lineup to this busstop
	body.bus_stop_line_entered.connect(_entered)
	body.bus_stop_line_left.connect(_left)
	
func _entered(body):
	dprint("%s entered busstop" % body)
	# how do we get them to follow the path? Let's get them a path to follow.
	var path_follow = PathFollow2D.new()
	path_follow.loop=false
	lineup.add_child(path_follow)
	#save path
	path_follows.append(path_follow)
	bus_stop_line_up.emit(body, path_follow, path_follows.size())
	print("path follow length: %s" % path_follows.size())
	
func _left(body):
	dprint("%s body left busstop" % body)
	
	
	
