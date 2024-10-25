extends AnimatedSprite2D

const pre_time:= 1
const post_time:= 1.5
const music_time:= 1.6


@onready var pre_timer:= $PreTime
@onready var post_timer:= $PostTime
@onready var pre_music:= $PreMusic


func _ready():
	playing = false
	frame = 0
	pre_timer.connect("timeout", Callable(self, "start_anim"))
	connect("animation_finished", Callable(self, "start_post"))
	post_timer.connect("timeout", Callable(self, "switch_scene"))
	pre_music.connect("timeout", Callable(self, "start_music"))
	pre_timer.start(pre_time)


func start_anim() -> void:
	play()
	pre_music.start(music_time)


func start_music() -> void:
	GlobalSound.switch_song(GlobalSound.end_game)


func start_post() -> void:
	post_timer.start(post_time)

func switch_scene() -> void:
	get_tree().change_scene_to_file("res://Menus/EndMenu.tscn")
