extends Camera2D


const OFFSET:= Vector2(12, -4)
const SLOPE:= -0.00266666
const Y_INT:= 0.66


@onready var player:= get_parent()


var player_speed: float


func _ready():
	position = OFFSET


func _process(delta):
	player_speed = player.velocity.x
	var camera_mvmt: float = (SLOPE * abs(player_speed)) + Y_INT
	
	if player.facing_right and position.x < OFFSET.x:
		position.x += camera_mvmt
	elif not player.facing_right and position.x > -OFFSET.x:
		position.x -= camera_mvmt
	
