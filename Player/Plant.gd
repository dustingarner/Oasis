extends CharacterBody2D


@onready var sprite:= $Sprite2D


func _ready():
	sprite.visible = false
	print(sprite.visible)
