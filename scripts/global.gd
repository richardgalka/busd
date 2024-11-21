extends Node

enum BUS_STATE {STOPPED, MOVING}

var player_fname: String = "Player"
var player_lname: String = "One"
var player_age: int = 22
var bus_name: String = "Bussy"
var bus_state: int = BUS_STATE.MOVING
var bus_lights: bool = false

@export var debug = true

func dprint(objname, data):
	if debug: print(objname, data)
	
