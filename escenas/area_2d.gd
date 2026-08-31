extends Area2D

signal finished

@onready var collision_shape = $CollisionShape2D
@onready var sprite = $ColorRect

@export var sprite_rotation_offset_deg: float = 0
@export var tiempo_antes_aparecer: float = 0.7
@export var tiempo_visible: float = 1.5

func _ready() -> void:
	
	area_entered.connect(_on_area_entered)
	
	sprite.visible = false
	collision_shape.set_deferred("disabled", true)
	rotation += deg_to_rad(sprite_rotation_offset_deg)

	var timer_aparecer = get_tree().create_timer(tiempo_antes_aparecer)
	timer_aparecer.timeout.connect(_hacer_aparecer)

func mirar_hacia(target_pos: Vector2) -> void:
	look_at(target_pos)
	rotation += deg_to_rad(sprite_rotation_offset_deg)

func _hacer_aparecer() -> void:
	
	sprite.visible = true
	collision_shape.set_deferred("disabled", false)

	var timer_desaparecer = get_tree().create_timer(tiempo_visible)
	timer_desaparecer.timeout.connect(_desaparecer)

func _desaparecer() -> void:
	sprite.visible = false
	collision_shape.set_deferred("disabled", true)
	finished.emit()
	queue_free()
	
func _on_area_entered(area: Area2D) -> void:
	print("Área detectada: ", area.name, " | grupos: ", area.get_groups())
	if area.is_in_group("hurtbox"):
		print("¡Es el hurtbox! Restando vida...")
		Global.minigame_win= 0
		Global.lives -= 1
		Global.minigames_done -= 1
		get_tree().call_deferred("change_scene_to_file", "res://escenas/level_scene.tscn")
