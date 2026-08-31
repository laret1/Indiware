extends Node2D
@onready var timer = $ThemedTimer
var timer_end = false
func _ready() -> void:
	await  timer.Timer(10.0)
	#after this is completed...
	timer_end = true 
func _process(delta: float) -> void:
	if timer_end:
		get_tree().change_scene_to_file("res://escenas/level_scene.tscn")
		Global.minigame_win= 1
