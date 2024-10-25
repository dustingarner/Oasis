extends Node2D


const text:= {
	0: ["Credit", "Credito"],
	1: ["Design:\nDustin\nGarner\n\nArt:\nLucas\nMaciel\n\nMusic:\nDustin\nGarner", \
			"Arte:\nLucas\nMaciel\n\nCodigo:\nDustin\nGarner\n\nMusica:\nDustin\nGarner"]
}


var entered:= false


@onready var title:= $Label
@onready var main_text:= $HelpStuff/ScrollContainer/VBoxContainer/Text
@onready var back:= $Buttons/Back
@onready var back_sprite:= $Buttons/Back/Sprite2D
@onready var menu_click:= $AudioStreamPlayer


var title_array: Array


func _ready():
	title_array = [title, main_text]
	for key in text:
		title_array[key].text = text[key][Global_UI.current_lang]
	
	back.connect("mouse_entered", Callable(self, "entered_back"))
	back.connect("mouse_exited", Callable(self, "exited_back"))
	back_sprite.modulate = Color.BLACK


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
