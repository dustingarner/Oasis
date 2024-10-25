extends CharacterBody2D


const WALK_SPEED:= 45
const SPRINT_SPEED:= 60
const MAX_COYOTE:= 400
const JUMP_SPEED:= 75
const MAX_JUMP:= 26
const DAMAGE_COLOR:= Color(0.51, 0.34, 0.34, 1)
const MAX_BLINK:= 5
const BLINK_TIME:= 0.55
const DAMAGE_MVMT:= Vector2(1, -1)
const DAMAGE_SPEED:= 75
const DAMAGE_HEIGHT:= 16



@onready var fsm:= get_node("Fsm")
@onready var interact:= get_node("Interact")
@onready var damage_timer:= get_node("DamageTimer")
@onready var animation:= get_node("AnimatedSprite2D")
@onready var plant:= get_node("PlantDesign/Plant")
@onready var jump_start:= get_node("JumpStart")
@onready var plant_positions:= [
	get_node("PlantDesign/Position1"),
	get_node("PlantDesign/Position2"),
	get_node("PlantDesign/Position3")
]


var health:= 4
var vulnerable:= true
var blink_count:= 0
var has_floored:= false
var direction: Vector2
var velocity: Vector2
var sprinting:= false
var coyote_frame:= 0
var was_on_floor:= true
var has_jumped:= false
var jump_frame:= 0
var start_jump: float
var facing_right:= true
var anim_dict:= { #Keeps track of where plant is in animation
	"idle": {0: 0, 1: 0, 2: 1, 3: 1},
	"fall": {0: 1, 1: 0, 2: 0, 3: 0},
	"jump": {0: 0, 1: 1, 2: 1, 3: 1, 4: 1, 5: 1},
	"land": {0: 1, 1: 2, 2: 2, 3: 2, 4: 2, 5: 1, 6: 1},
	"walk": {0: 0, 1: 0}
}


func _ready():
	animation.connect("animation_finished", Callable(self, "switch_anim"))
	interact.connect("body_entered", Callable(self, "damage_start"))
	damage_timer.connect("timeout", Callable(self, "damage_blink"))


func switch_anim() -> void:
	if animation.animation == "land":
		if fsm.current_state == "walk":
			animation.animation = "walk"
			animation.speed_scale = 1
		elif fsm.current_state == "sprint":
			animation.animation = "walk"
			animation.speed_scale = 1.5
		else:
			animation.animation = fsm.current_state
			animation.speed_scale = 1


func basic_movement() -> void:
	direction.x = Input.get_axis("left", "right")
	
	if sprinting:
		velocity.x = direction.x * SPRINT_SPEED
	else:
		velocity.x = direction.x * WALK_SPEED


func apply_gravity() -> void:
	if fsm.current_state == "fall":
		velocity.y += Global.GRAVITY
	else:
		velocity.y = Global.GRAVITY


func coyote_check(delta) -> bool:
	if is_on_floor():
		coyote_frame = 0
		has_jumped = false
		return true
	elif has_jumped:
		return false
	elif coyote_frame <= MAX_COYOTE * delta:
		coyote_frame += 1
		return true
	else:
		return false


func jump() -> void:
	velocity.y = -JUMP_SPEED


func move(delta) -> void:
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()


func damage_start(body) -> void:
	if body.is_in_group("Enemies") and vulnerable:
		health -= 1
		if health != 0:
			GlobalSound.play_sound(GlobalSound.hurt)
		fsm.change_state("damage")
		damage_timer.start(BLINK_TIME)
		animation.modulate = DAMAGE_COLOR
		vulnerable = false
		blink_count += 1


func damage_blink() -> void:
	if animation.modulate == DAMAGE_COLOR:
		animation.modulate = Color.WHITE
		damage_timer.start(BLINK_TIME)
		blink_count += 1
	elif animation.modulate == Color.WHITE:
		if blink_count >= MAX_BLINK:
			vulnerable = true
			blink_count = 0
		else:
			animation.modulate = DAMAGE_COLOR
			damage_timer.start(BLINK_TIME)
			blink_count += 1


func damage_movement() -> void:
	direction = DAMAGE_MVMT
	if facing_right:
		direction.x = -1
	else:
		direction.x = 1
	velocity = direction * DAMAGE_SPEED



func end_processes() -> void:
	fsm.change_state("idle")
	for state in fsm.get_children():
		state.set_process(false)
		state.set_physics_process(false)
		state.set_process_input(false)



func _process(delta):
	if health == 0:
		GlobalSound.switch_song(GlobalSound.death)
		get_tree().change_scene_to_file("res://Menus/GameOverMenu.tscn")
	
	if is_on_floor():
		has_floored = true
	
	plant.position = plant_positions[anim_dict[animation.animation][animation.frame]].position
	
	if is_equal_approx(Input.get_axis("left", "right"), -1) and facing_right:
		facing_right = false
	elif is_equal_approx(Input.get_axis("left", "right"), 1) and not facing_right:
		facing_right = true
	
	animation.flip_h = not facing_right


func _physics_process(delta):
	pass
