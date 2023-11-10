extends CharacterBody2D

var player_nearby: bool = false
var can_laser: bool = true
var right_gun: bool = true
var left_gun: bool = false

var health: int = 30
var vulnerable: bool = true

signal laser(pos, direction)

func _process(_delta):
	if player_nearby:
		look_at(Globals.player_pos)
		if can_laser and right_gun:
			var pos: Vector2 = $LaserSpawnPositions/Marker2D.global_position
			var direction: Vector2 = (Globals.player_pos - position).normalized()
			laser.emit(pos, direction)
			can_laser = false
			right_gun = false
			left_gun = true
			$Timers/LaserTimer.start()
		if can_laser and left_gun:
			var pos: Vector2 = $LaserSpawnPositions/Marker2D2.global_position
			var direction: Vector2 = (Globals.player_pos - position).normalized()
			laser.emit(pos, direction)
			can_laser = false
			right_gun =true
			left_gun = false
			$Timers/LaserTimer.start()
			

func hit():
	if vulnerable:
		health -= 10
		vulnerable = false
		$Timers/HitTimer.start()
		$Sprite2D.material.set_shader_parameter("progress",0.7)
		$HitSound.play()
		if Globals.hunter_dead:
				Globals.health += 3
	if health <= 0:
		Globals.points += 35
		queue_free()


func _on_attack_area_body_entered(_body):
	player_nearby = true


func _on_attack_area_body_exited(_body):
	player_nearby = false
	$Sprite2D.material.set_shader_parameter("progress",0)



func _on_laser_timer_timeout():
	can_laser = true


func _on_hit_timer_timeout():
	vulnerable = true
	$Sprite2D.material.set_shader_parameter("progress",0)
	
