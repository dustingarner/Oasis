extends Node


enum Language {
	ENGLISH,
	PORTUGUESE
}


var sound:= true
var current_lang: int
var paused:= false
var current_level: int
var levels_unlocked:= {
	1: true,
	2: false,
	3: false,
	4: false,
	5: false
}


func _ready():
	current_lang = Language.ENGLISH
