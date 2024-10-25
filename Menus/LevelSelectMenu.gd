extends Node2D

const text:= {
	0: ["Select", "Escolhe"],
	1: ["Level ", "Nivel"],
	2: ["Locked", "Fechado"]
}

 
@onready var title:= $Label
@onready var back:= $Buttons/Back
@onready var back_sprite:= $Buttons/Back/Sprite2D
@onready var level_array:= {
	1: $Buttons/ScrollContainer/VBoxContainer/Level1,
	2: $Buttons/ScrollContainer/VBoxContainer/Level2,
	3: $Buttons/ScrollContainer/VBoxContainer/Level3,
	4: $Buttons/ScrollContainer/VBoxContainer/Level4,
	5: $Buttons/ScrollContainer/VBoxContainer/Level5
}


var entered:= false


func _ready():
	title.text = text[0][Global_UI.current_lang]
	for level in level_array:
		if Global_UI.levels_unlocked[level]:
			level_array[level].text = text[1][Global_UI.current_lang] + String(level)
			level_array[level].connect("pressed", Callable(self, "change_level").bind(level))
		else:
			level_array[level].text = text[2][Global_UI.current_lang]
	back.connect("mouse_entered", Callable(self, "entered_back"))
	back.connect("mouse_exited", Callable(self, "exited_back"))
	back_sprite.modulate = Color.BLACK


func change_level(level: int) -> void:
	GlobalSound.play_sound(GlobalSound.menu_click)
	Global_UI.current_level = level
	if level == 1:
		get_tree().change_scene_to_file("res://Scenes/Intro.tscn")
	else:
		GlobalSound.switch_song(GlobalSound.main_song)
		get_tree().change_scene_to_file("res://Levels/Level " + String(level) + ".tscn")



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
