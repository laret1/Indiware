extends Node2D

# Solución: Inicializar el array vacío []
var tuberias : Array = [] 
var index_control = 0

func _ready() -> void:
	for tubo in $tuberias.get_children():
		tuberias.append(tubo)


func next_index():
	if index_control < tuberias.size() - 1:
		index_control += 1
	else:
		index_control = 0

func _on_timer_timeout() -> void:
	
	tuberias[index_control].position = Vector2(
		$spawn_arriba.position.x, 
		randf_range($spawn_arriba.position.y, $spawn_abajo.position.y)
	)
	next_index()
