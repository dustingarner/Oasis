extends Area2D




func _ready():
	connect("body_entered", Callable(self, "end_game"))


func end_game(body) -> void:
	if body.is_in_group("Player"):
		GlobalSound.current_song.stop()
		get_tree().change_scene_to_file("res://Scenes/Ending.tscn")

