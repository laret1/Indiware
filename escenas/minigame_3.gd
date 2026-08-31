extends Node2D

@onready var themed_timer: Node2D = $ThemedTimer
var timer_end = false

@onready var positions: Array[Marker2D] = [
	$posiciones/pos1,
	$posiciones/pos2,
	$posiciones/pos3,
	$posiciones/pos4
]
@onready var gasterblaster = $GasterBlasterSoundEffect1
var blaster_scene = preload("res://escenas/gaster_blaster.tscn")

# Nombre del nodo objetivo (lo puedes cambiar desde el editor o por código)
@export var target_name: String = "Player"

func _ready() -> void:
	spawn_blaster_sequence()

	await themed_timer.Timer(7.0)
	# after this is completed...
	timer_end = true

func spawn_blaster_sequence() -> void:
	var target_node = get_tree().root.find_child(target_name, true, false)
	if target_node == null:
		push_warning("No se encontró el nodo objetivo: " + target_name)
		return

	var order = positions.duplicate()
	order.shuffle()

	for pos in order:
		if timer_end: # corta la secuencia si ya se acabó el tiempo
			break
		await spawn_blaster_at(pos.global_position, target_node.global_position)
		await get_tree().create_timer(0.4).timeout

func spawn_blaster_at(pos: Vector2, target_pos: Vector2) -> void:
	var blaster = blaster_scene.instantiate()
	add_child(blaster)              # <- primero se agrega al árbol
	blaster.global_position = pos   # <- luego se posiciona
	blaster.mirar_hacia(target_pos) # <- y luego se rota (usa la función del blaster, con su offset)
	gasterblaster.playing = true
	await blaster.finished # espera a que aparezca, se quede visible, y desaparezca

func _process(delta: float) -> void:
	if timer_end:
		get_tree().change_scene_to_file("res://escenas/level_scene.tscn")
		Global.minigame_win= 1
