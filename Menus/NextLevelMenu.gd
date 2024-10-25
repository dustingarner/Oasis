extends Node2D



const MAIN_MENU:= "res://Menus/MainMenu.tscn"

const text:= {
	0: ["END", "FIM"],
	1: ["NEXT", "PROXIMO"],
	2: ["MAIN", "PRINCIPAL"],
}


@onready var title:= $Label
@onready var next_button:= $Buttons/Next
@onready var main_button:= $Buttons/Main


var title_array: Array


func _ready():
	title_array = [title, next_button, main_button]
	for key in text:
		title_array[key].text = text[key][Global_UI.current_lang]
	
	next_button.connect("pressed", Callable(self, "next_level"))
	main_button.connect("pressed", Callable(self, "to_main"))


func next_level() -> void:
	GlobalSound.play_sound(GlobalSound.menu_click)
	Global_UI.current_level += 1
	GlobalSound.switch_song(GlobalSound.main_song)
	get_tree().change_scene_to_file("res://Levels/Level " + String(Global_UI.current_level) + ".tscn")


func to_main() -> void:
	GlobalSound.play_sound(GlobalSound.menu_click)
	GlobalSound.switch_song(GlobalSound.menu_song)
	get_tree().change_scene_to_file(MAIN_MENU)


