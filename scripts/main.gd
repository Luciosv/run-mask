extends Node


# LEVELS
const LEVEL_1 = preload("res://scenes/Levels/level_1.tscn")



var current_level : Level

@onready var player : Player = $Player
@onready var phantom : PhantomCamera2D = $PhantomCamera2D
@onready var win_screen: Control = $CanvasLayer/WinScreen


func _ready() -> void:
	load_level(LEVEL_1)
	
	player.hurt.connect(_on_hurt_player)
	current_level.win.connect(_on_win)


func load_level(level_scene : PackedScene) -> void:
	# Si hay un nivel previo, lo borramos
	if current_level:
		current_level.queue_free()

	# Instanciamos el nuevo nivel
	current_level = level_scene.instantiate() as Level
	add_child(current_level)

	# Inicializamos jugador y cámara
	_setup_player()
	_setup_camera()


func _setup_player() -> void:
	if current_level.init_level:
		player.global_position = current_level.init_level.global_position
	else:
		push_warning("El nivel no tiene init_level asignado")


func _setup_camera() -> void:
	if current_level.limit_level:
		phantom.limit_target = current_level.limit_level.get_path()
	else:
		push_warning("El nivel no tiene limit_level asignado")


func _on_hurt_player():
	_setup_player()
	player.restart_player()


func _on_win():
	win_screen.show()
