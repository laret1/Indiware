extends Area2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var palo: String
var valor: int
var seleccionada: bool = false
var posicion_base: Vector2   # ← nueva variable

func _ready():
	input_event.connect(_on_input_event)



func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		seleccionada = !seleccionada
		_actualizar_visual()

func _actualizar_visual():
	var offset = Vector2(0, -20) if seleccionada else Vector2.ZERO
	var tween = create_tween()
	tween.tween_property(self, "position", posicion_base + offset, 0.15)
func configurar(p_palo: String, p_valor: int):
	palo = p_palo
	valor = p_valor
	posicion_base = position
	sprite.play(obtener_anim_name(palo, valor))
func obtener_anim_name(palo: String, valor: int) -> String:
	if valor == 1:
		return palo  # el As no lleva sufijo: "corazon" o "trebol"
	return "%s_%d" % [palo, valor]
