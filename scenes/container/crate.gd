extends ItemContainer

var rng = RandomNumberGenerator.new()
var num = rng.randi_range(3, 6)


func hit():
	if not opened:
		$LidSprite.hide()
		$AudioStreamPlayer2D.play()
		for i in range(num):
			var pos = $SpawnPositions.get_child(randi()%$SpawnPositions.get_child_count()).global_position
			open.emit(pos, current_direction)
		opened = true
	


