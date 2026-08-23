extends Area2D

var dragging = false
var start_pos: Vector2
var time_start: float

@export var min_time: float = 0.6
@export var max_time: float = 1.5

func _ready() -> void:
	start_pos = position

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and get_rect().has_point(to_local(event.position)):
			dragging = true
			time_start = Time.get_ticks_msec() / 1000.0
		elif not event.pressed and dragging:
			dragging = false
			check_swipe()

func _process(delta: float) -> void:
	if dragging:
		position.x = get_global_mouse_position().x

func check_swipe() -> void:
	var time_elapsed = (Time.get_ticks_msec() / 1000.0) - time_start
	if position.x > 600: # Posición X donde se completa el lector
		if time_elapsed >= min_time and time_elapsed <= max_time:
			print("¡Tarjeta aceptada!")
		else:
			print("Muy rápido o muy lento. Intenta de nuevo.")
			position = start_pos
	else:
		position = start_pos
