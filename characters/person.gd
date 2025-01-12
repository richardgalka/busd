extends Resource

class_name Person

@export_category("Person Details")
@export var name : String = "name"
@export var personal_space : int = 5
@export var at_stop : bool = true
@export var time_to_spawn : float = 1.0
## Time it takes to get to stop
@export var time_to_travel : float = 5.0

#@export var head : 
#@export var body : 
#@export var legs : 
@export var quirks : Array[Quirk]
@export var storage : InvContainer

@export var texture_small : Texture2D = preload("res://aseprite/human_silhoute0001.png")
@export var texture_large : Texture2D = preload("res://aseprite/Cigar man sprite.png")
