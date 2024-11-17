extends Resource

class_name Quirk

@export var timeout : int

enum Quirks {SMOKER, FIDGETY, MURDERER, TERRORIST, DRUNK, HOMELESS, OFFICIAL}
@export var quirk: Quirks

func _init() -> void:
	print("init node2d")
	print(len(Quirks.keys()))

	
func output(a: String) -> void:
	print("Timer done =- OUTOUT!!! %s" % a)
	
	
