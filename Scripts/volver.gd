extends Button




func _on_pressed() -> void:
	
	var minigames_done = 0
	Global.lives = 5
	get_tree().change_scene_to_file("res://escenas/level_scene.tscn")
