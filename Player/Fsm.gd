extends Node2D


@onready var player:= get_parent()
@onready var states:= {
	"idle": $Idle,
	"walk": $Walk,
	"sprint": $Sprint,
	"jump": $Jump,
	"fall": $Fall,
	"damage": $Damage
}


var prev_state: String
var current_state: String


func _ready():
	current_state = "idle"
	player.get_node("AnimatedSprite2D").play("idle")
	for state in get_children():
		if state == states[current_state]:
			state.set_process(true)
			state.set_physics_process(true)
			state.set_process_input(true)
		else:
			state.set_process(false)
			state.set_physics_process(false)
			state.set_process_input(false)


func change_state(new_state: String) -> void:
	prev_state = current_state
	states[prev_state].set_process(false)
	states[prev_state].set_physics_process(false)
	states[prev_state].set_process_input(false)
	
	
	if prev_state == "fall" and new_state != "jump" and new_state != "damage":
		player.animation.play("land")
		player.animation.speed_scale = 3
	elif new_state == "jump":
		player.jump_frame = 0
		player.has_jumped = true
		player.start_jump = player.jump_start.global_position.y
		player.animation.play("jump")
		player.animation.speed_scale = 1
		GlobalSound.play_sound(GlobalSound.jump)
	elif new_state == "idle":
		player.animation.play("idle")
		player.animation.speed_scale = 1
	elif new_state == "walk":
		player.animation.play("walk")
		player.animation.speed_scale = 1
	elif new_state == "sprint":
		player.animation.play("walk")
		player.animation.speed_scale = 1.5
	elif new_state == "fall":
		player.animation.play("fall")
		player.animation.speed_scale = 1
	elif new_state == "damage":
		player.start_jump = player.jump_start.global_position.y
		player.animation.play("jump")
		player.animation.speed_scale = 1
		
	
	current_state = new_state
	states[current_state].set_process(true)
	states[current_state].set_physics_process(true)
	states[current_state].set_process_input(true)


func _process(delta):
	pass
