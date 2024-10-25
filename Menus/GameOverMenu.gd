extends Node2D



const MAIN_MENU:= "res://Menus/MainMenu.tscn"
const LEVEL1:= "res://Levels/Level 1.tscn"

const text:= {
	0: ["DEAD", "MORTO"],
	1: ["RETRY", "NOVAMENTE"],
	2: ["MAIN", "PRINCIPAL"],
}


@onready var title:= $Label
@onready var retry_button:= $Buttons/Retry
@onready var main_button:= $Buttons/Main


var title_array: Array


func _ready():
	title_array = [title, retry_button, main_button]
	for key in text:
		title_array[key].text = text[key][Global_UI.current_lang]
	
	retry_button.connect("pressed", Callable(self, "select").bind(LEVEL1)) #Change to level menu if add more
	main_button.connect("pressed", Callable(self, "select").bind(MAIN_MENU))


func select(new_scene: String) -> void:
	GlobalSound.play_sound(GlobalSound.menu_click)
	if new_scene == MAIN_MENU:
		GlobalSound.switch_song(GlobalSound.menu_song)
		get_tree().change_scene_to_file(new_scene)
	else:
		GlobalSound.switch_song(GlobalSound.main_song)
		get_tree().change_scene_to_file("res://Levels/Level " + String(Global_UI.current_level) + ".tscn")
	


