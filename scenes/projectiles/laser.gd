extends Area2D

@export var speed: int = 2250
var direction: Vector2 = Vector2.UP


func _ready():
	$LaserBeGone.start()
	$AudioStreamPlayer2D.play()
	
func _process(delta):
	position += direction * speed * delta
	

func _on_body_entered(body):
	if "hit" in body:
		body.hit()
	$Sprite2D.hide()	
	await $AudioStreamPlayer2D.finished
	queue_free()
	
		

		
func _on_laser_be_gone_timeout():
	queue_free()



