extends CharacterBody2D

@export var speed := 200.0


func _physics_process(delta):
	var direction = Input.get_vector(
		"izquierda",
		"derecha",
		"arriba",
        "abajo"
	)

	velocity = direction * speed
	move_and_slide()
