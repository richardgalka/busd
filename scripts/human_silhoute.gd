#extends StaticBody2D
extends Sprite2D

@export var clicks_to_pop : int = 40
@export var size_increase : float = 0.2
@export var score_to_give : int = 1

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if get_rect().has_point(to_local(event.position)):
			print("click")
			scale += Vector2.ONE * size_increase
			clicks_to_pop -= 1
			if clicks_to_pop < 1:
				#$"/root/Main".increase_score(score_to_give)
				queue_free()
