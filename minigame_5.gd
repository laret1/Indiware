extends Node2D

@onready var tarjeta: Area2D = $Tarjeta
@onready var inicio_tarjeta: Marker2D = $InicioTarjeta
@onready var fin_tarjeta: Marker2D = $FinTarjeta
@onready var timer: Timer = $Timer
@onready var ganar: TextureRect = $TextureRect4
@onready var themed_timer: Node2D = $ThemedTimer

var timer_end = false
var arrastrando = false
var bloqueada = false
var cronometro_iniciado = false
var mouse_anterior: Vector2
var juego_activo = true

var tiempo_minimo = 0.5
var tiempo_maximo = 1.5
var margen_llegada = 10.0

func _ready():
	ganar.visible = false
	tarjeta.position.x = inicio_tarjeta.position.x
	tarjeta.position.y = inicio_tarjeta.position.y

	tarjeta.input_event.connect(_on_tarjeta_input_event)

	timer.one_shot = true
	timer.wait_time = tiempo_maximo
	timer.timeout.connect(_on_timer_timeout)
	await themed_timer.Timer(5.0)
	
	timer_end = true 
func _on_tarjeta_input_event(_viewport, event, _shape_idx):
	if not juego_activo or bloqueada:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			arrastrando = true
			tarjeta.position.y = inicio_tarjeta.position.y  # snap y bloqueo de Y, aquí mismo
			mouse_anterior = get_global_mouse_position()
		elif arrastrando:
			arrastrando = false

func _process(_delta):
	if not juego_activo or bloqueada or not arrastrando:
		return

	var mouse_actual = get_global_mouse_position()
	var movimiento = mouse_actual - mouse_anterior
	mouse_anterior = mouse_actual

	if movimiento != Vector2.ZERO:
		if not cronometro_iniciado:
			cronometro_iniciado = true
			timer.start()

		tarjeta.position.x += movimiento.x  # ← solo X se mueve; Y se queda fijo
		# tarjeta.position.y NO se toca aquí — permanece bloqueado en inicio_tarjeta.position.y

	if cronometro_iniciado and abs(tarjeta.position.x - fin_tarjeta.position.x) <= margen_llegada:
		tarjeta.position.x = fin_tarjeta.position.x
		bloqueada = true
		arrastrando = false
		evaluar_resultado()
	if timer_end:
		Global.lives -= 1
		Global.minigames_done -=1
		get_tree().change_scene_to_file("res://escenas/level_scene.tscn")

func _on_timer_timeout():
	if juego_activo and not bloqueada:
		terminar_ronda(false)

func evaluar_resultado():
	var tiempo_usado = tiempo_maximo - timer.time_left
	timer.stop()
	if tiempo_usado < tiempo_minimo:
		terminar_ronda(false)
	else:
		terminar_ronda(true)

func terminar_ronda(acierto: bool):
	if not juego_activo:
		return
	juego_activo = false
	mostrar_resultado(acierto)

func mostrar_resultado(acierto: bool):
	if acierto:
		ganar.visible = true
		get_tree().change_scene_to_file("res://escenas/level_scene.tscn")
	else:
		Global.lives -= 1
		Global.minigames_done -=1
		get_tree().change_scene_to_file("res://escenas/level_scene.tscn")
