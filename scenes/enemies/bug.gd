extends CharacterBody2D

var health: int = 50
var speed: int = 300
var vulnerable: bool = true
var player_nearby: bool = false
var player_close: bool = false
var can_attack: bool = true
var player_dmg: bool = false
var laser_loot: int = randi_range(3,7)


func _process(_delta):
	var direction = (Globals.player_pos - position).normalized()
	velocity = direction * speed
	if player_nearby:
		move_and_slide()
		look_at(Globals.player_pos)

func hit():
	if vulnerable:
		health -= 10
		vulnerable = false
		$Particles/HitParticles.emitting = true
		$HitTimer.start()
		$AnimatedSprite2D.material.set_shader_parameter("progress",0.7)
		$AudioStreamPlayer2D.play()
		if Globals.hunter_dead:
				Globals.health += 3
	if health <= 0:
		Globals.laser_amount += laser_loot
		await get_tree().create_timer(0.01).timeout
		Globals.points += 50
		queue_free()


func _on_hit_timer_timeout():
	vulnerable = true
	$AnimatedSprite2D.material.set_shader_parameter("progress",0)


func _on_notice_area_body_entered(_body):
	player_nearby = true
	$AnimatedSprite2D.play("walk")

func _on_notice_area_body_exited(_body):
	player_nearby = false 
	$AnimatedSprite2D.material.set_shader_parameter("progress",0)
	$AnimatedSprite2D.stop()
	
func _on_attack_area_body_entered(_body):
	player_dmg = true
	$AnimatedSprite2D.play("attack")
	while player_dmg:
		Globals.health -= 25
		await get_tree().create_timer(1.0).timeout

func _on_attack_area_body_exited(_body):
	player_dmg = false
	$AnimatedSprite2D.play("walk")
	
