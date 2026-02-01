extends Node

# Referencia a la escena de transición
var transition_scene: ColorRect
var current_tween: Tween

# Duración por defecto de las transiciones
var default_duration: float = 0.5

func _ready():
	# Cargar e instanciar la escena de transición
	var scene = load("res://scenes/transition.tscn")
	transition_scene = scene.instantiate()
	
	# Añadir como hijo del autoload para que persista
	add_child(transition_scene)
	
	# Asegurar que esté en la capa más alta
	transition_scene.z_index = 100

# Transición de entrada: escala de 0 a 1 (pantalla se pone negra)
func transition_out(duration: float = -1.0):
	if duration < 0:
		duration = default_duration
	
	# Cancelar tween anterior si existe
	if current_tween and current_tween.is_valid():
		current_tween.kill()
	
	# Centrar el pivot por si acaso
	transition_scene.set_pivot_center()
	
	# Crear nuevo tween
	current_tween = create_tween()
	current_tween.set_ease(Tween.EASE_IN_OUT)
	current_tween.set_trans(Tween.TRANS_CUBIC)
	
	# Animar de escala 0 a 1
	transition_scene.scale = Vector2.ZERO
	current_tween.tween_property(transition_scene, "scale", Vector2.ONE, duration)

# Transición de salida: escala de 1 a 0 (se revela la escena)
func transition_in(duration: float = -1.0):
	if duration < 0:
		duration = default_duration
	
	# Cancelar tween anterior si existe
	if current_tween and current_tween.is_valid():
		current_tween.kill()
	
	# Centrar el pivot por si acaso
	transition_scene.set_pivot_center()
	
	# Crear nuevo tween
	current_tween = create_tween()
	current_tween.set_ease(Tween.EASE_IN_OUT)
	current_tween.set_trans(Tween.TRANS_CUBIC)
	
	# Animar de escala 1 a 0
	transition_scene.scale = Vector2.ONE
	current_tween.tween_property(transition_scene, "scale", Vector2.ZERO, duration)
