extends Sprite2D

@export var speed: float = 240.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Jugador preparado")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print("Hola mundo")

	
	
	if Input.is_action_just_pressed("jump"):
		sumar_puntos()

var puntos: int = 0
func sumar_puntos() -> void:
	puntos += 1
	if puntos >= 5:
		print("Objetivo alcanzado")

#Si accion puntos+1
#si puntos = 5 print -----

	
