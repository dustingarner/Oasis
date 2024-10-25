extends Node2D


const LEVEL_SELECT:= "res://Menus/LevelSelectMenu.tscn"
const OPTIONS_MENU:= "res://Menus/OptionsMenu.tscn"
const HELP_MENU:= "res://Menus/HelpMenu.tscn"
const CREDITS_MENU:= "res://Menus/CreditsMenu.tscn"

const text:= {
	0: ["OASIS", "OASIS"],
	1: ["PLAY", "TOQUE"],
	2: ["OPTIONS", "OPCOES"],
	3: ["HELP", "AJUDA"],
	4: ["CREDITS", "CREDITOS"]
}


@onready var title:= $Label
@onready var play_button:= $Buttons/ScrollContainer/VBoxContainer/Play
@onready var options_button:= $Buttons/ScrollContainer/VBoxContainer/Options
@onready var help_button:= $Buttons/ScrollContainer/VBoxContainer/Help
@onready var credits_button:= $Buttons/ScrollContainer/VBoxContainer/Credits


var title_array: Array


func _ready():
	if Global.first_time:
		GlobalSound.switch_song(GlobalSound.menu_song)
		Global.first_time = false
	title_array = [title, play_button, options_button, help_button, credits_button]
	for key in text:
		title_array[key].text = text[key][Global_UI.current_lang]
	
	play_button.connect("pressed", Callable(self, "select").bind(LEVEL_SELECT)) #Change to level menu if add more
	options_button.connect("pressed", Callable(self, "select").bind(OPTIONS_MENU))
	help_button.connect("pressed", Callable(self, "select").bind(HELP_MENU))
	credits_button.connect("pressed", Callable(self, "select").bind(CREDITS_MENU))


func select(new_scene: String) -> void:
	GlobalSound.play_sound(GlobalSound.menu_click)
	get_tree().change_scene_to_file(new_scene)

