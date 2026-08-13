extends Button




func _on_pressed() -> void:
	Global.lives = 5
	get_tree().change_scene_to_file("res://escenas/level_scene.tscn")
