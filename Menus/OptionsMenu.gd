extends Node2D




const text:= {
	0: ["OPTION", "OPCOES"],
	1: ["PORTUGUES", "ENGLISH"],
	2: ["SOUND", "SOM"],
}


var entered:= false


@onready var title:= $Label
@onready var lang_button:= $Buttons/Language
@onready var sound_button:= $Buttons/Sound
@onready var back:= $Buttons/Back
@onready var back_sprite:= $Buttons/Back/Sprite2D
@onready var menu_click:= $AudioStreamPlayer


var title_array: Array


func _ready():
	title_array = [title, lang_button, sound_button]
	for key in text:
		title_array[key].text = text[key][Global_UI.current_lang]
	
	lang_button.connect("pressed", Callable(self, "change_lang"))
	sound_button.connect("pressed", Callable(self, "toggle_sound"))
	back.connect("mouse_entered", Callable(self, "entered_back"))
	back.connect("mouse_exited", Callable(self, "exited_back"))
	back_sprite.modulate = Color.BLACK
	


func change_lang() -> void:
	if Global_UI.current_lang == Global_UI.Language.ENGLISH:
		Global_UI.current_lang = Global_UI.Language.PORTUGUESE
	elif Global_UI.current_lang == Global_UI.Language.PORTUGUESE:
		Global_UI.current_lang = Global_UI.Language.ENGLISH
	GlobalSound.play_sound(GlobalSound.menu_click)
	get_tree().change_scene_to_file("res://Menus/OptionsMenu.tscn")


func toggle_sound() -> void:
	Global_UI.sound = not Global_UI.sound
	GlobalSound.play_sound(GlobalSound.menu_click)
	GlobalSound.switch_song(GlobalSound.menu_song)


func entered_back() -> void:
	back_sprite.modulate = Color(0.278431, 0.466667, 0.952941)
	entered = true

func exited_back() -> void:
	back_sprite.modulate = Color.BLACK
	entered = false


func _input(event):
	if event.is_action_pressed("click") and entered:
		GlobalSound.play_sound(GlobalSound.menu_click)
		get_tree().change_scene_to_file("res://Menus/MainMenu.tscn")
