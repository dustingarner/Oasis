extends AnimatedSprite2D

const pre_time:= 0.1
const post_time:= 1.2


@onready var start_time:= $Timer2
@onready var wait_time:= $Timer




func _ready():
	frame = 10
	playing = false
	connect("animation_finished", Callable(self, "timer"))
	start_time.connect("timeout", Callable(self, "play"))
	wait_time.connect("timeout", Callable(self, "switch_scene"))
	
	start_time.start(pre_time)


func timer() -> void:
	wait_time.start(post_time)


func switch_scene() -> void:
	GlobalSound.switch_song(GlobalSound.main_song)
	get_tree().change_scene_to_file("res://Levels/Level 1.tscn")


func _input(event):
	if event.is_action_pressed("esc"):
		switch_scene()



