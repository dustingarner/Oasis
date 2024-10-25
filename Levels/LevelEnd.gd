extends Area2D


func _ready():
	connect("body_entered", Callable(self, "next_level"))


func next_level(body) -> void:
	if body.is_in_group("Player"):
		Global_UI.levels_unlocked[Global_UI.current_level + 1] = true
		GlobalSound.switch_song(GlobalSound.end_level)
		get_tree().change_scene_to_file("res://Menus/NextLevelMenu.tscn")
