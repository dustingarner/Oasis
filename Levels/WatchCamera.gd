extends Camera2D


const MVMT_SPEED:= 45


var direction:= Vector2.ZERO


func _process(delta):
	if current:
		direction.x = Input.get_axis("left", "right")
		direction.y = Input.get_axis("up", "down")
		direction = direction.normalized()
		
		position += direction * MVMT_SPEED * delta
