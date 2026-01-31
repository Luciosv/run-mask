extends Enemy

@export_category("Pendulum")
@export var swing_angle := 20.0 # grados máximos
@export var swing_speed := 2.0  # velocidad del balanceo

@export_group("Dependencies")
@export var origin: Marker2D

@onready var line_2d: Line2D = $Line2D

var _time := 0.0
var _length := 0.0
var _base_direction := Vector2.DOWN


func _ready() -> void:
	super._ready()
	
	if not origin:
		push_warning("PendulumEnemy: origin no asignado")
		return

	# Largo del péndulo = distancia inicial
	_length = origin.global_position.distance_to(global_position)

	# Dirección base (desde el origen hacia el enemigo)
	_base_direction = (global_position - origin.global_position).normalized()

	# Configuración visual de la línea
	_update_line()


func _physics_process(delta: float) -> void:
	if not origin:
		return
	
	if not can_move : return
	
	_time += delta * swing_speed

	# Ángulo actual del balanceo
	var angle := sin(_time) * deg_to_rad(swing_angle)

	# Rotamos la dirección base
	var direction := _base_direction.rotated(angle)

	# Nueva posición del enemigo
	global_position = origin.global_position + direction * _length

	_update_line()


func _update_line() -> void:
	line_2d.clear_points()
	line_2d.add_point(Vector2.ZERO)
	line_2d.add_point(to_local(origin.global_position))
