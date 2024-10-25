extends Node2D


@onready var menu_click:= $MenuClick
@onready var jump:= $Jump
@onready var hurt:= $Hurt
@onready var vulture:= $Vulture
@onready var snake:= $Snake

@onready var death:= $Death
@onready var menu_song:= $MenuSong
@onready var main_song:= $MainSong
@onready var end_level:= $EndLevel
@onready var end_game:= $EndGame


var current_song: AudioStreamPlayer


func _ready():
	current_song = main_song


func play_sound(sound: AudioStreamPlayer) -> void:
	if Global_UI.sound:
		sound.play()


func stop_sound(sound: AudioStreamPlayer) -> void:
	sound.stop()


func switch_song(song: AudioStreamPlayer) -> void:
	current_song.stop()
	current_song = song
	if Global_UI.sound:
		current_song.play()
