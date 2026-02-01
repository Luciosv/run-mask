extends ColorRect

func _ready():
	# Centrar el pivot en el centro del ColorRect
	pivot_offset = size / 2
	# Iniciar invisible (escala 0)
	scale = Vector2.ZERO

func set_pivot_center():
	# Por si cambia el tamaño de la pantalla
	pivot_offset = size / 2
