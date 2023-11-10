extends CharacterBody2D

var active: bool = false
var speed: int = 400
var explosion_radius: int = 325
var vulnerable: bool = true
var health: int = 40

var explosion_active: bool = false

func _ready():
	$Explosion.hide()
	$Drone.show()

func _process(delta):
#	$Drone.material.set_shader_parameter("progress",0.2)
#	await get_tree().create_timer(0.1).timeout	
#	$Drone.material.set_shader_parameter("progress",0)
#	await get_tree().create_timer(0.1).timeout
	if active:
		look_at(Globals.player_pos)
		var direction = (Globals.player_pos - position).normalized()
		velocity = direction * speed
		speed = speed + 1.5
		var collision = move_and_collide(velocity * delta)
		if collision:
			var targets = get_tree().get_nodes_in_group("Container") + get_tree().get_nodes_in_group("Entity")
			for target in targets:
				var in_range = target.global_position.distance_to(global_position) < explosion_radius
				if "hit" in target and in_range:
					target.hit()

func killpoints():
	Globals.points += 20
	
func hit():
	if vulnerable:
		$Drone.material.set_shader_parameter("progress",0.7)
		health -= 10
		vulnerable = false
		$HitTimer.start()
		$Sounds/HitSound.play()
		if Globals.hunter_dead:
				Globals.health += 3
	if health <= 0:
		$AnimationPlayer.play("explosion")
		active = false

func _on_notice_area_body_entered(_body):
	active = true


func _on_hit_timer_timeout():
	$Drone.material.set_shader_parameter("progress",0)
	vulnerable = true
