extends PathFollow2D

var player_near: bool = false
var vulnerable: bool = true

func fire():
	Globals.health -= 13

func hit():
	if vulnerable:
		Globals.car_health -= 10
		vulnerable = false
		$HitTimer.start()
		if Globals.hunter_dead:
				Globals.health += 3
	if Globals.car_health <= 0:
		Globals.points += 150
		queue_free()
		
func _process(delta):
	progress_ratio += 0.03 * delta
	if player_near:
		$Turret.look_at(Globals.player_pos)
		progress_ratio -= 0.02 * delta

func _on_notice_area_body_entered(_body):
	player_near = true
	$AnimationPlayer.play("laser_load")



func _on_notice_area_body_exited(_body):
	player_near = false
	$AnimationPlayer.stop()


func _on_hit_timer_timeout():
	vulnerable = true


func _on_character_body_2d_cardeath():
	queue_free()
