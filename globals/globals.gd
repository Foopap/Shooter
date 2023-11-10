extends Node

signal stat_change

var player_hit_sound: AudioStreamPlayer2D
var hunter_dead = false
var lifesteal_kill = false
var points = 0

func _process(delta):
	if points == 2235:
		Globals.points += 1
		_win()
func _win():
	var tween = create_tween()
	tween.tween_property($Player, "speed",0,.15)
	TransitionLayer.change_scene("res://winscreen.tscn")
	

var car_health = 150:
	set(value):
		car_health = value

var laser_amount = 30:
	set(value):
		laser_amount = value
		stat_change.emit()
		
var grenade_amount = 5:
	set(value):
		grenade_amount = value
		stat_change.emit()

var player_vulnerable: bool = true
var health = 150:
	set(value):
		if health <= 0:
			TransitionLayer.get_tree().quit()
		if value < 0:
			health = 0
		if value > health:
			health = min(value, 150)
		else:
			if player_vulnerable:
				health = value
				player_vulnerable = false
				player_invulnerable_timer()
				player_hit_sound.play()
		stat_change.emit()
		
func player_invulnerable_timer():
	await get_tree().create_timer(0.5).timeout
	player_vulnerable = true

var player_pos: Vector2

func _ready():
	player_hit_sound = AudioStreamPlayer2D.new()
	player_hit_sound.stream = load("res://audio/solid_impact.ogg")
	add_child(player_hit_sound)
