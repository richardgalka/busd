extends Resource

class_name Person

@export_category("Person Details")
@export var fname : String = "fname"
@export var lname : String = "lname"
#@export var head : 
#@export var body : 
#@export var legs : 
@export var quirks : Array[Quirk]
@export var speed: int = 10
@export var storage : InvContainer

@export var texture_small : Texture2D = preload("res://aseprite/human_silhoute0001.png")
@export var texture_large : Texture2D = preload("res://aseprite/Cigar man sprite.png")
