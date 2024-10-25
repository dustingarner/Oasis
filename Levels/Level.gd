extends Node2D

const cam_limits:= [120, 24, 41]
const cam_multiplier:= 1


@onready var player_camera:= $Player/Camera2D
@onready var test_camera:= $TestCamera
@onready var player:= $Player
@onready var player_fsm:= $Player/Fsm
@onready var pause:= $PauseLayer/Pause
@onready var pause_menu:= $PauseLayer/PauseMenu
@onready var health_bar:= $PauseLayer/HealthBar
@onready var scenes:= $Scenes
@onready var fade:= $Fade


var entered:= false
var raise_camera:= false
var begin_raise:= false


func _ready():
	player_camera.current = true
	pause.connect("mouse_entered", Callable(self, "entered_pause"))
	pause.connect("mouse_exited", Callable(self, "exited_pause"))
	pause.modulate = Color.BLACK
	pause_menu.hide()
	health_bar.frame = 0



func _input(event):
	if event.is_action_pressed("test_camera") and player_camera.current:
		test_camera.current = true
		for child in player_fsm.get_children():
			child.set_process(false)
			child.set_physics_process(false)
			child.set_process_input(false)
	elif event.is_action_pressed("test_camera") and test_camera.current:
		player_camera.current = true
		player_fsm.change_state("idle")
		
	if (event.is_action_pressed("click") and entered) or event.is_action_pressed("esc"):
		GlobalSound.play_sound(GlobalSound.menu_click)
		Global_UI.paused = true
		pause_menu.show()
		

func entered_pause() -> void:
	pause.modulate = Color(0.278431, 0.466667, 0.952941)
	entered = true

func exited_pause() -> void:
	pause.modulate = Color.BLACK
	entered = false


func _process(delta):
	if raise_camera and Global_UI.current_level == 3 and player_camera.limit_bottom != cam_limits[1]:
		if begin_raise:
			player_camera.limit_bottom = cam_limits[2]
			begin_raise = false
		elif player_camera.limit_bottom > cam_limits[1]:
			player_camera.limit_bottom -= cam_multiplier
	elif not raise_camera and Global_UI.current_level == 3 and player_camera.limit_bottom < cam_limits[0]:
		player_camera.limit_bottom += cam_multiplier
	
	match player.health:
		4:
			health_bar.frame = 0
		3:
			health_bar.frame = 1
		2:
			health_bar.frame = 2
		1:
			health_bar.frame = 3
		_:
			health_bar.frame = 4
	

