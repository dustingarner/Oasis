extends Node2D


@onready var fsm:= get_parent()
@onready var player:= get_parent().get_parent()


func _process(delta):
	if Input.is_action_pressed("sprint"):
		player.sprinting = true
	else:
		player.sprinting = false


func _physics_process(delta):
	if player.is_on_floor():
		if is_zero_approx(Input.get_axis("left", "right")):
			fsm.change_state("idle")
		elif player.sprinting:
			fsm.change_state("sprint")
		else:
			fsm.change_state("walk")
	
	player.was_on_floor = player.coyote_check(delta)
	
	player.basic_movement()
	player.apply_gravity()
	player.move(delta)


func _input(event):
	if event.is_action_pressed("jump") and player.was_on_floor:
		fsm.change_state("jump")


