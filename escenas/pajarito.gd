extends RigidBody2D
@export var velocidad = 1
@onready var aleteo_sonido = $aleteo
var is_alive = true
func die():
    Global.minigames_done -=1
    Global.minigame_win= 0
    get_tree().change_scene_to_file("res://escenas/level_scene.tscn")
func flap(state:PhysicsDirectBodyState2D):
    aleteo_sonido.playing = true
    state.linear_velocity = Vector2.UP * velocidad
    $AnimatedSprite2D.look_at($arriba.global_position)
    
func _ready() -> void:
    is_alive = true
    $AnimatedSprite2D.play("default")
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
    if state.linear_velocity.y>velocidad*0.5:
     $AnimatedSprite2D.rotation = lerp_angle($AnimatedSprite2D.rotation,$abajo.position.normalized().angle(),0.1)
    if not is_alive:
        return
    if Input.is_action_just_pressed("salto"):
        flap(state)
