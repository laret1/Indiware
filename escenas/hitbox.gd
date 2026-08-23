extends Area2D
# Este nodo no necesita lógica propia, solo existe para ser detectado.
# Puedes dejarlo vacío o agregar una señal propia si quieres manejar el daño desde el jugador:

signal hit(source)
@onready var collisionshape = $Playercollision
func recibir_golpe(source: Node) -> void:
	hit.emit(source)
func _ready() -> void:
	print("Monitoring del hitbox: ", monitoring)
	print("Collision shape disabled: ", collisionshape.disabled)
	print("Layer: ", collision_layer, " Mask: ", collision_mask)
