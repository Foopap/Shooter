extends CharacterBody2D

var active: bool = false
var speed: int = 700
var player_near: bool = false
var vulnerable: bool = true
var health: int = 400

func _ready():
	$NavigationAgent2D.path_desired_distance = 4.0
	$NavigationAgent2D.target_desired_distance = 4.0
	await get_tree().create_timer(0.5).timeout
	$NavigationAgent2D.target_position = Globals.player_pos
	

func _physics_process(_delta):
	if active:
		speed += 1
		var next_path_pos: Vector2 = $NavigationAgent2D.get_next_path_position()
		var direction: Vector2 = (next_path_pos - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		var look_angle = direction.angle()
		rotation = look_angle + PI / 2
		


func _on_notice_area_body_entered(_body):
	active = true
	$AnimationPlayer.play("walk")
	
func _on_notice_area_body_exited(_body):
	active = false
	$AnimationPlayer.play("walk")
	
func _on_navigation_timer_timeout():
	if active:
		$NavigationAgent2D.target_position = Globals.player_pos


func _on_attack_area_body_entered(_body):
	player_near = true
	$AnimationPlayer.play("attack")
	speed = 500


func _on_attack_area_body_exited(_body):
	player_near = false
	$AnimationPlayer.play("walk")

	
func attack():
	if player_near:
		Globals.health -= 25
	
func hit():
	if vulnerable:
		$Node2D/GPUParticles2D.emitting = true
		health -= 10
		$Skeleton2D/Torso/Torso.material.set_shader_parameter("progress",0.7)
		$Timers/HitTimer.start()
		vulnerable = false
		$AudioStreamPlayer2D.play()
		if Globals.hunter_dead:
				Globals.health += 3
	if health <= 0:
		Globals.points += 300
		Globals.hunter_dead = true
		queue_free()

func _on_hit_timer_timeout():
	vulnerable = true
	$Skeleton2D/Torso/Torso.material.set_shader_parameter("progress",0.0)
