extends Node2D
@export var velocidad = 1

func _process(delta: float) -> void:
	position += Vector2.LEFT * velocidad


func _on_tuberia_body_entered(body: Node2D) -> void:
	if  body.name == "pajarito":
		body.die()
