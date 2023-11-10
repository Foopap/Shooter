extends CharacterBody2D

signal laser(pos, direction)
signal grenade(pos, direction)

var can_laser:bool = true
var can_grenade:bool = true
var roll_timer:bool = true

@export var max_speed: int = 1200
var speed: int = max_speed

func hit():
	Globals.health -= 10
	$PlayerImage.material.set_shader_parameter("progress",0.7)
	await get_tree().create_timer(0.5).timeout
	$PlayerImage.material.set_shader_parameter("progress",0.0)
	
	
func _process(_delta):
	# input
	var direction = Input.get_vector("left", "right", "up", "down")
	Input.get_action_strength("dodge")
	velocity = direction * speed
	move_and_slide()
	Globals.player_pos = global_position
	if Input.is_action_just_pressed("dodge") and roll_timer:
		
		# roll speed
		
		var tween = get_tree().create_tween()
		tween.tween_property($".", "speed", 2200, .1)
		await tween.finished
		var tween2 = get_tree().create_tween()
		tween2.tween_property($".", "speed", 1200, .1)
		$Timers/RollTimer.start()
		roll_timer = false
	
	look_at(get_global_mouse_position())
	
	# laser shooting input
	var player_direction = (get_global_mouse_position() - position).normalized()
	if Input.is_action_just_pressed("primary action") and can_laser and Globals.laser_amount > 0:
		Globals.laser_amount -= 1
		$GPUParticles2D.emitting = true
		var laser_markers = $LaserStartPositions.get_children()
		var selected_laser = laser_markers[randi() % laser_markers.size()]
		can_laser = false
		$Timers/LaserTimer.start()
		laser.emit(selected_laser.global_position, player_direction)
		
		
		
	if Input.is_action_just_pressed("secondary action") and can_grenade and Globals.grenade_amount > 0:
		var pos = $LaserStartPositions.get_children()[1].global_position
		Globals.grenade_amount -= 1
		can_grenade = false
		$Timers/GrenadeReloadTimer.start()
		grenade.emit(pos, player_direction)

func _on_laser_timer_timeout():
	can_laser = true


func _on_grenade_reload_timer_timeout():
	can_grenade = true

func _on_roll_timer_timeout():
		roll_timer = true



