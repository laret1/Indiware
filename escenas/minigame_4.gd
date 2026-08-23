extends Node2D

const CARTA_SCENE = preload("res://escenas/cartas.tscn")
var timer_end = false
@onready var boton_jugar: Button = $BotonJugar
@onready var label_resultado: Label = $LabelResultado
@onready var timer: Node2D = $ThemedTimer 

var palos = ["trebol", "corazon"]
var cartas_en_mano: Array = []

func _ready():
	var mano = repartir_mano_por_tipo()
	mostrar_mano(mano)
	boton_jugar.pressed.connect(_on_boton_jugar_pressed)
	await timer.Timer(3.0)
	#after this is completed...
	timer_end = true 


func generar_mazo() -> Array:
	var mazo = []
	for palo in palos:
		for valor in range(1, 14):
			mazo.append({"palo": palo, "valor": valor})
	return mazo

func generar_mano_par() -> Array:
	var valor_par = randi_range(1, 13)
	var mano = []
	for palo in palos:
		mano.append({"palo": palo, "valor": valor_par})
	var valores_usados = [valor_par]
	while mano.size() < 5:
		var valor = randi_range(1, 13)
		if valor in valores_usados:
			continue
		valores_usados.append(valor)
		var palo = palos[randi_range(0, 1)]
		mano.append({"palo": palo, "valor": valor})
	mano.shuffle()
	return mano

func generar_mano_doble_par() -> Array:
	var valores = range(1, 14)
	valores.shuffle()
	var valor1 = valores[0]
	var valor2 = valores[1]
	var valor_extra = valores[2]
	var mano = []
	for palo in palos:
		mano.append({"palo": palo, "valor": valor1})
	for palo in palos:
		mano.append({"palo": palo, "valor": valor2})
	mano.append({"palo": palos[randi_range(0, 1)], "valor": valor_extra})
	mano.shuffle()
	return mano

func generar_mano_color() -> Array:
	var palo_elegido = palos[randi_range(0, 1)]
	var valores = range(1, 14)
	valores.shuffle()
	var mano = []
	for i in range(5):
		mano.append({"palo": palo_elegido, "valor": valores[i]})
	return mano

func generar_mano_escalera() -> Array:
	var inicio = randi_range(1, 9)  # así inicio+4 nunca pasa de 13
	var mano = []
	for i in range(5):
		mano.append({"palo": palos[i % 2], "valor": inicio + i})
	mano.shuffle()
	return mano

func generar_mano_escalera_color() -> Array:
	var inicio = randi_range(1, 9)
	var palo_elegido = palos[randi_range(0, 1)]
	var mano = []
	for i in range(5):
		mano.append({"palo": palo_elegido, "valor": inicio + i})
	mano.shuffle()
	return mano

func generar_mano_sin_jugada() -> Array:
	var intentos = 0
	while intentos < 200:
		var mazo = generar_mazo()
		mazo.shuffle()
		var mano = mazo.slice(0, 5)
		if evaluar_mano(mano) == "Sin jugada":
			return mano
		intentos += 1
	# fallback por si en 200 intentos no salió "Sin jugada" (muy poco probable)
	var mazo = generar_mazo()
	mazo.shuffle()
	return mazo.slice(0, 5)

func repartir_mano_por_tipo() -> Array:
	var tipos = ["Par", "Doble Par", "Color", "Escalera", "Escalera de Color", "Sin Jugada"]
	var indice = randi_range(0, tipos.size() - 1)
	match tipos[indice]:
		"Par": return generar_mano_par()
		"Doble Par": return generar_mano_doble_par()
		"Color": return generar_mano_color()
		"Escalera": return generar_mano_escalera()
		"Escalera de Color": return generar_mano_escalera_color()
		_: return generar_mano_sin_jugada()

func repartir_mano(cantidad: int) -> Array:
	var mazo = generar_mazo()
	mazo.shuffle()
	return mazo.slice(0, cantidad)

func repartir_mano_garantizada(cantidad: int) -> Array:
	var mazo = generar_mazo()
	mazo.shuffle()
	# Elegir un valor al azar para forzar el par
	var valor_par = mazo[0].valor
	var candidatas = mazo.filter(func(c): return c.valor == valor_par)
	var resto = mazo.filter(func(c): return c.valor != valor_par)
	resto.shuffle()
	var mano = [candidatas[0], candidatas[1]]
	mano.append_array(resto.slice(0, cantidad - 2))
	mano.shuffle()  # para que el par no siempre quede en las primeras posiciones visuales
	return mano

func mostrar_mano(mano: Array):
	var espacio_x = 150
	var pos_y = 400
	var ancho_total = (mano.size() - 1) * espacio_x
	var inicio_x = ancho_total / 2.0  # centrado real (antes tenías un signo cambiado aquí)
	for i in range(mano.size()):
		var carta_instancia = CARTA_SCENE.instantiate()
		add_child(carta_instancia)
		carta_instancia.position = Vector2(inicio_x + i * espacio_x, pos_y)
		carta_instancia.configurar(mano[i].palo, mano[i].valor)
		cartas_en_mano.append(carta_instancia)

func _on_boton_jugar_pressed():
	var mano_completa = []
	for carta in cartas_en_mano:
		mano_completa.append({"palo": carta.palo, "valor": carta.valor})

	var resultado = evaluar_mano(mano_completa)
	print("Jugada: ", resultado)

	if label_resultado:
		label_resultado.text = resultado
		if es_jugada_valida(resultado):
			label_resultado.modulate = Color.GREEN
			get_tree().change_scene_to_file("res://escenas/level_scene.tscn")
		else:
			label_resultado.modulate = Color.RED

func evaluar_mano(mano: Array) -> String:
	if mano.size() != 5:
		return "Mano incompleta (%d cartas)" % mano.size()

	var valores = []
	var palos_mano = []
	for c in mano:
		valores.append(c.valor)
		palos_mano.append(c.palo)

	var conteo = {}
	for v in valores:
		conteo[v] = conteo.get(v, 0) + 1
	var repeticiones = conteo.values()
	repeticiones.sort()
	repeticiones.reverse()

	var es_color = palos_mano.count(palos_mano[0]) == palos_mano.size()

	valores.sort()
	var es_escalera = true
	for i in range(1, valores.size()):
		if valores[i] != valores[i-1] + 1:
			es_escalera = false
			break

	if es_color and es_escalera:
		return "Escalera de color"
	if repeticiones[0] == 4:
		return "Poker"
	if repeticiones[0] == 3 and repeticiones.size() > 1 and repeticiones[1] == 2:
		return "Full"
	if es_color:
		return "Color"
	if es_escalera:
		return "Escalera"
	if repeticiones[0] == 3:
		return "Trío"
	if repeticiones[0] == 2 and repeticiones.size() > 1 and repeticiones[1] == 2:
		return "Doble par"
	if repeticiones[0] == 2:
		return "Par"
	return "Sin jugada"

func es_jugada_valida(resultado: String) -> bool:
	var jugadas_ganadoras = ["Par", "Trío", "Doble par", "Full", "Color", "Escalera", "Poker", "Escalera de color"]
	return resultado in jugadas_ganadoras
func _process(delta: float) -> void:
	if timer_end:
		Global.lives -= 1
		Global.minigames_done -=1
		get_tree().change_scene_to_file("res://escenas/level_scene.tscn")
