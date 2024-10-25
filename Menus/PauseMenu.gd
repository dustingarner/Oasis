extends Node2D



const MAIN_MENU:= "res://Menus/MainMenu.tscn"

const text:= {
	0: ["PAUSE", "PAUSA"],
	1: ["RESUME", "De Volta"],
	2: ["MAIN", "PRINCIPAL"],
	3: ["PORT", "ENG"],
	4: ["SOUND", "SOM"]
}


@onready var title:= $Label
@onready var resume_button:= $Buttons/ScrollContainer/VBoxContainer/Resume
@onready var main_button:= $Buttons/ScrollContainer/VBoxContainer/Main
@onready var language_button:= $Buttons/ScrollContainer/VBoxContainer/Language
@onready var sound_button:= $Buttons/ScrollContainer/VBoxContainer/Sound


var title_array: Array


func _ready():
	title_array = [title, resume_button, main_button, language_button, sound_button]
	for key in text:
		title_array[key].text = text[key][Global_UI.current_lang]
	
	resume_button.connect("pressed", Callable(self, "resume_game")) #Change to level menu if add more
	main_button.connect("pressed", Callable(self, "select").bind(MAIN_MENU))
	language_button.connect("pressed", Callable(self, "change_lang"))
	sound_button.connect("pressed", Callable(self, "toggle_sound"))


func resume_game() -> void:
	GlobalSound.play_sound(GlobalSound.menu_click)
	Global_UI.paused = false
	hide()


func select(new_scene: String) -> void:
	GlobalSound.play_sound(GlobalSound.menu_click)
	Global_UI.paused = false
	GlobalSound.switch_song(GlobalSound.menu_song)
	get_tree().change_scene_to_file(new_scene)


func change_lang() -> void:
	if Global_UI.current_lang == Global_UI.Language.ENGLISH:
		Global_UI.current_lang = Global_UI.Language.PORTUGUESE
	elif Global_UI.current_lang == Global_UI.Language.PORTUGUESE:
		Global_UI.current_lang = Global_UI.Language.ENGLISH
	GlobalSound.play_sound(GlobalSound.menu_click)
	for key in text:
		title_array[key].text = text[key][Global_UI.current_lang]


func toggle_sound() -> void:
	Global_UI.sound = not Global_UI.sound
	GlobalSound.play_sound(GlobalSound.menu_click)
	GlobalSound.switch_song(GlobalSound.main_song)


func _input(event):
	if event.is_action_pressed("esc"):
		resume_game()
