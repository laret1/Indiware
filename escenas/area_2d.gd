extends Area2D

@onready var collision_shape = $CollisionShape2D # Cambia el nombre si es necesario
@onready var sprite = $ColorRect               # Cambia el nombre si es necesario

func _ready():
	# 1. Hacer el objeto invisible al inicio
	sprite.visible = false
	
	# 2. Desactivar las colisiones (se usa set_deferred por seguridad física)
	collision_shape.set_deferred("disabled", true)
	
	# 3. Crear y configurar un temporizador de 1 segundo
	var timer = get_tree().create_timer(2.0)
	
	# 4. Conectar el final del temporizador a la función que lo activa
	timer.timeout.connect(_hacer_aparecer)

func _hacer_aparecer():
	# 5. Volverlo visible y activar sus colisiones
	sprite.visible = true
	collision_shape.set_deferred("disabled", false)

func _on_area_entered(area: Area2D) -> void:
	Global.lives -= 1
	Global.minigames_done -=1
	get_tree().change_scene_to_file("res://escenas/level_scene.tscn")
