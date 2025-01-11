extends Node

# Class in charge of creating and managing people

const MIN_PASSENGERS := 0
const MAX_PASSENGERS := 30

const COMMUTER = preload("res://busd/characters/commuter.tscn")
var ordered_commuters: Array[Person]

var t_ordered_commuters_size = 0

var _debug = true

# Passeneger counts - set in level
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

func initialize_commuters(commuters: Array[Person]) -> void:
	if commuters.size() > MAX_PASSENGERS:
		# TODO: UI - Display warning 
		pass
	ordered_commuters = commuters
	

func passenger_left(position_num):
	#global.dprint(self, "Passenger %s decided to leave" % position_num)
	# for each passenger with a > # let's ensure they move forward one place
	
	# Update ordered_commuters
	ordered_commuters.pop_at(position_num)
	self.commuter_left.emit(position_num)   # should we send actual commuter?
