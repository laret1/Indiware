extends Area2D

signal finished # <- para que el spawner sepa cuándo terminó este blaster

@onready var collision_shape = $CollisionShape2D
@onready var sprite = $ColorRect

@export var sprite_rotation_offset_deg: float = 0 # ajusta según cómo esté dibujado tu sprite
@export var tiempo_antes_aparecer: float = 0.5 # tiempo esperando antes de mostrarse
@export var tiempo_visible: float = 1.0        # cuánto tiempo se queda activo/visible

func _ready() -> void:
	# 1. Invisible y sin colisión al inicio
	sprite.visible = false
	collision_shape.set_deferred("disabled", true)

	# 2. Aplicar el offset de rotación (por si ya viene rotado con look_at desde afuera)
	rotation += deg_to_rad(sprite_rotation_offset_deg)

	# 3. Timer antes de aparecer
	var timer_aparecer = get_tree().create_timer(tiempo_antes_aparecer)
	timer_aparecer.timeout.connect(_hacer_aparecer)

func mirar_hacia(target_pos: Vector2) -> void:
	# Llamar a esto desde el spawner ANTES o justo cuando se instancia
	look_at(target_pos)
	rotation += deg_to_rad(sprite_rotation_offset_deg)

func _hacer_aparecer() -> void:
	# 4. Volverlo visible y activar colisión
	sprite.visible = true
	collision_shape.set_deferred("disabled", false)

	# 5. Programar el momento de desaparecer
	var timer_desaparecer = get_tree().create_timer(tiempo_visible)
	timer_desaparecer.timeout.connect(_desaparecer)

func _desaparecer() -> void:
	sprite.visible = false
	collision_shape.set_deferred("disabled", true)

	# 6. Avisar al spawner que ya terminó todo su ciclo
	finished.emit()
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	Global.lives -= 1
	Global.minigames_done -= 1
	get_tree().change_scene_to_file("res://escenas/level_scene.tscn")
