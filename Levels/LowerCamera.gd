extends Area2D


@onready var level:= get_parent()


func _ready():
	connect("body_entered", Callable(self, "lower_camera"))

func lower_camera(body):
	if body.is_in_group("Player"):
		level.raise_camera = false
