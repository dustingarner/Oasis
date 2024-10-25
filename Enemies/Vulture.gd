extends CharacterBody2D


@export var stop_pos1:= -16
@export var stop_pos2:= 16
@export var idle_time:= 1.5
@export var pre_dive_time:= 0.35


enum States {
	IDLE,
	FLY,
	PRE_DIVE,
	DIVE,
	POST_DIVE
}


const FLY_SPEED:= 25
const DIVE_SPEED:= 100
const LIFT_SPEED:= -25
const animation_speed:= 1.25


@onready var idle_timer:= $IdleTimer
@onready var detect_player:= $DetectPlayer
@onready var talons:= $Talons
@onready var animation:= $AnimationPlayer


var start_pos: Vector2
var prev_state: int
var current_state: int
var facing_right:= true
var speed: Vector2
var x_direction: int
var velocity: Vector2
var divable:= true
var pre_dive:= false
var dive_to: float


func _ready():
	start_pos = global_position
	x_direction = 1
	current_state = States.FLY
	animation.play("Vulture")
	animation.playback_speed = animation_speed
	idle_timer.connect("timeout", Callable(self, "after_idle"))
	detect_player.connect("body_entered", Callable(self, "prepare_dive"))


func prepare_dive(body) -> void:
	if divable and body.is_in_group("Player"):
		divable = false
		pre_dive = true
		if body.fsm.current_state == "jump":
			dive_to = body.start_jump
		else:
			dive_to = body.position.y
		change_state(States.PRE_DIVE)


func after_idle() -> void:
	if pre_dive:
		change_state(States.DIVE)
		pre_dive = false
	else:
		change_state(States.FLY)


func change_state(new_state: int) -> void:
	prev_state = current_state
	match new_state:
		States.IDLE:
			idle_timer.start(idle_time)
		States.FLY:
			scale.x *= -1
			x_direction *= -1
			facing_right = not facing_right
		States.PRE_DIVE:
			idle_timer.start(pre_dive_time)
		States.DIVE:
			GlobalSound.play_sound(GlobalSound.vulture)
		States.POST_DIVE:
			pass
	current_state = new_state


func _physics_process(delta):
	match current_state:
		States.IDLE:
			speed = Vector2.ZERO
		States.FLY:
			speed = Vector2(FLY_SPEED, 0)
			if (facing_right and global_position.x - start_pos.x >= stop_pos2) \
					or not facing_right and (global_position.x - start_pos.x <= stop_pos1):
				change_state(States.IDLE)
			elif is_on_wall():
				change_state(States.IDLE)
		States.PRE_DIVE:
			speed = Vector2.ZERO
		States.DIVE:
			speed = Vector2(0, DIVE_SPEED)
			if talons.global_position.y >= dive_to or is_on_floor():
				divable = true
				change_state(States.POST_DIVE)
		States.POST_DIVE:
			speed = Vector2(0, LIFT_SPEED)
			if global_position.y <= start_pos.y:
				change_state(States.IDLE)
	
	velocity.x = speed.x * x_direction
	velocity.y = speed.y
	
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()
	


