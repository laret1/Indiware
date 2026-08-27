extends CharacterBody2D

@export var animacion: AnimatedSprite2D
@export var area_2d: Area2D
@export var sonido_salto:AudioStreamPlayer

var _velocidad: float = 500.0
var _velocidad_salto: float = -600.0
var _muerto: bool




func _physics_process(delta):
	
	# gravedad
	velocity += get_gravity() * delta 
	
	# salto
	if Input.is_action_just_pressed("salto") and is_on_floor():
		velocity.y = _velocidad_salto
		sonido_salto.playing = true
	# movimiento lateral
	if Input.is_action_pressed("derecha"):
		velocity.x = _velocidad
		animacion.flip_h = false
	elif Input.is_action_pressed("izquierda"):
		velocity.x = -_velocidad
		animacion.flip_h = true
	else:
		velocity.x = 0
	move_and_slide()
	
	# animación
	if !is_on_floor():
		animacion.play("saltar")
		
	elif velocity.x != 0:
		animacion.play("correr")
	else:
		animacion.play("idle")
