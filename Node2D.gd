extends Node2D



func _on_area_2d_body_entered(_body):
	var tween = create_tween()
	tween.tween_property($Player, "speed",0,.15)
	TransitionLayer.change_scene("res://scenes/levels/outside.tscn")


func _on_area_2d_2_body_entered(_body):
	var tween = create_tween()
	tween.tween_property($Player, "speed",0,.5)
	await tween.finished
	TransitionLayer.get_tree().quit()
