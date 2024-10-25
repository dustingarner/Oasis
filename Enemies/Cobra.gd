extends CharacterBody2D


@export var stop_pos1:= -16
@export var stop_pos2:= 16
@export var idle_time:= 1.5
@export var anim_speed:= 1.15

enum States {
	IDLE,
	WALK,
	APPROACH,
	ATTACK
}


const WALK_SPEED:= 25
const APPROACH_SPEED:= 25
const ATTACK_DIST:= 16


@onready var idle_timer:= $IdleTimer
@onready var detect_player:= $DetectPlayer
@onready var attack_player:= $AttackPlayer
@onready var animation:= $AnimationPlayer
@onready var anim_idle:= $Animations/Idle
@onready var anim_attack:= $Animations/Attack
@onready var visibility_notifier:= $VisibleOnScreenNotifier2D


var start_pos: int
var prev_state: int
var current_state: int
var facing_right:= true
var speed: int
var direction: int
var velocity: Vector2
var sound_player:= false


func _ready():
	randomize()
	start_pos = global_position.x
	direction = 1
	current_state = States.WALK
	animation.play("idle")
	idle_timer.connect("timeout", Callable(self, "change_state").bind(States.WALK))
	detect_player.connect("body_entered", Callable(self, "approach_player"))
	detect_player.connect("body_exited", Callable(self, "end_approach"))
	attack_player.connect("body_entered", Callable(self, "attack"))
	animation.connect("animation_finished", Callable(self, "attack_done"))
	visibility_notifier.connect("screen_entered", Callable(self, "toggle_vis").bind(true))
	visibility_notifier.connect("screen_exited", Callable(self, "toggle_vis").bind(false))


func approach_player(body) -> void:
	if body.is_in_group("Player"):
		if global_position.x - body.global_position.x > 0 and facing_right \
				or global_position.x - body.global_position.x < 0 and not facing_right:
			scale.x *= -1
			direction *= -1
			facing_right = not facing_right
		change_state(States.APPROACH)


func attack(body) -> void:
	if body.is_in_group("Player"):
		change_state(States.ATTACK)
		animation.play("Attack")

func attack_done(anim_name) -> void:
	if anim_name == "Attack":
		change_state(States.IDLE)


func end_approach(body) -> void:
	change_state(States.IDLE)


func toggle_vis(visibility: bool) -> void:
	visible = visibility


func change_state(new_state: int) -> void:
	prev_state = current_state
	match new_state:
		States.IDLE:
			var time_diff:= randf_range(-0.25, 0.25)
			idle_timer.start(idle_time + time_diff)
			animation.play("idle")
			animation.playback_speed = anim_speed
			anim_idle.visible = true
			anim_attack.visible = false
		States.WALK:
			scale.x *= -1
			direction *= -1
			facing_right = not facing_right
			anim_idle.visible = true
			anim_attack.visible = false
		States.APPROACH:
			anim_idle.visible = true
			anim_attack.visible = false
		States.ATTACK:
			anim_idle.visible = false
			anim_attack.visible = true
			GlobalSound.play_sound(GlobalSound.snake)
	current_state = new_state


func _process(delta):
	if Global_UI.paused:
		set_physics_process(false)
	else:
		set_physics_process(true)



func _physics_process(delta):
	match current_state:
		States.IDLE:
			speed = 0
		States.WALK:
			speed = WALK_SPEED
			if (facing_right and global_position.x - start_pos >= stop_pos2) \
					or not facing_right and (global_position.x - start_pos <= stop_pos1):
				change_state(States.IDLE)
			elif is_on_wall():
				change_state(States.IDLE)
		States.APPROACH:
			speed = APPROACH_SPEED
		States.ATTACK:
			speed = 0
	
	velocity.x = speed * direction
	velocity.y = Global.GRAVITY
	
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()


