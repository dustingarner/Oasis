extends Node2D

const MAX_CEILING:= 75


@onready var fsm:= get_parent()
@onready var player:= get_parent().get_parent()

var ceiling_frame:= 0


func _process(delta):
	pass


func _physics_process(delta):
	if player.start_jump - player.global_position.y >= player.MAX_JUMP:
		fsm.change_state("fall")
	elif player.is_on_ceiling():
		if ceiling_frame <= MAX_CEILING * delta:
			ceiling_frame += 1
		else:
			ceiling_frame = 0
			fsm.change_state("fall")
	
	player.basic_movement()
	player.jump()
	player.move(delta)


func _input(event):
	if event.is_action_released("jump"):
		fsm.change_state("fall")


