extends TextureButton
@onready var parent = $".."
@export var click:AudioStreamPlayer
func _on_pressed() -> void: #YOU NEED TO CONNECT THIS SIGNAL FROM THE TAB NEXT TO INSPECTOR!!
	hide()
	parent.buttons_pressed += 1
	click.playing = true
