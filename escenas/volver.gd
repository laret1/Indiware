extends Button




func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/background.tscn")
	Global.minigames_done = 0
	Global.minigame_win = 2
