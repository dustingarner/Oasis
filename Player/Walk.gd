extends Node2D


@onready var fsm:= get_parent()
@onready var player:= get_parent().get_parent()


func _process(delta):
	if Input.is_action_pressed("sprint"):
		player.sprinting = true
		fsm.change_state("sprint")
	
	if is_zero_approx(Input.get_axis("left", "right")):
		fsm.change_state("idle")


func _physics_process(delta):
	if not player.is_on_floor() and player.has_floored:
		fsm.change_state("fall")
	
	player.was_on_floor = player.coyote_check(delta)
	player.basic_movement()
	player.apply_gravity()
	player.move(delta)


func _input(event):
	if event.is_action_pressed("jump") and player.was_on_floor:
		fsm.change_state("jump")

