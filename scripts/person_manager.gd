extends Node

# Class in charge of creating and managing people

const MIN_PASSENGERS := 0
const MAX_PASSENGERS := 10

var passengers_present: int = 3:
	set(new_value):
		passengers_present = clamp(new_value, MIN_PASSENGERS, MAX_PASSENGERS)
	get:
		return passengers_present
		
var passengers_arriving: int = 1:
	set(new_value):
		passengers_arriving = clamp(new_value, MIN_PASSENGERS, MAX_PASSENGERS)
	get:
		return passengers_arriving

const COMMUTER = preload("res://busd/characters/commuter.tscn")
@export var ordered_commuters: Array[commuter]


func add_passenger(passenger_num:int, path:Path2D, path_follow:PathFollow2D):
	var last_stop = path.scale.x*path.curve.get_point_position(path.curve.point_count-1)
	var comy = _create_passenger(last_stop, passenger_num)
	var comy_path = path_follow
	path.add_child(comy_path)
	#self.add_child(comy)
	comy.follow_path(comy_path, true)
	# Fire commuter path setup so driverview port can mimick movement of commuter
	signals.commuter_path_setup.emit(comy, comy_path, true)
	# Driver view is not getting the above singal as it's not connected yet. Let's manually add.
	global.dprint(self, "signal commuter path setup")
	
	
func create_passengers_present(commuter_path_to_stop: Path2D, commuter_path_follow2d:PathFollow2D):
	for i in range(0, passengers_present):
		add_passenger(i, commuter_path_to_stop, commuter_path_follow2d)

func _create_passenger(location, pos) -> commuter:
	# Create the commuter instance and place at location
	var commuter_instance = COMMUTER.instantiate()
	# Need to add a person resource.
	commuter_instance.add_to_group("commuter")
	commuter_instance.global_position = location
	commuter_instance.line_position = pos
	#global.dprint(commuter_instance, "My position : %s" % pos)
	
	# register the commuter with our world
	commuter_instance.decided_to_leave.connect(_passenger_left)
	
	# register this world with the passenger
	self.commuter_left.connect(commuter_instance.other_comy_left)
	ordered_commuters.append(commuter_instance)
	
	# let everyone know a new commuter has been added to scene
	signals.commuter_added_to_scene.emit(commuter_instance)
	return commuter_instance
	
func _passenger_left(position_num):
	#global.dprint(self, "Passenger %s decided to leave" % position_num)
	# for each passenger with a > # let's ensure they move forward one place
	self.commuter_left.emit(position_num)
	# Update ordered_commuters
	ordered_commuters.pop_at(position_num)
