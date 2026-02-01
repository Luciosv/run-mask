extends Node

# Duración de cada transición
@export var transition_duration: float = 0.5
# Pausa entre transiciones
@export var pause_between: float = 0.3

func _ready():
	# Esperar un frame para que todo esté inicializado
	await get_tree().process_frame
	# Iniciar el loop
	start_transition_loop()

func start_transition_loop():
	while true:
		# Transición OUT (0 a 1 - pantalla a negro)
		TransitionManager.transition_out(transition_duration)
		await get_tree().create_timer(transition_duration).timeout
		
		# Pausa en negro
		await get_tree().create_timer(pause_between).timeout
		
		# Transición IN (1 a 0 - revela escena)
		TransitionManager.transition_in(transition_duration)
		await get_tree().create_timer(transition_duration).timeout
		
		# Pausa transparente
		await get_tree().create_timer(pause_between).timeout
