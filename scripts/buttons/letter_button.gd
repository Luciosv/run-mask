extends Control

@export var my_mask : MaskManager.ColorMask
@export var base_color : Color = Color.WHITE  # Color base del borde
@export var glow_color : Color  # Color del resplandor
@export var cooldown_time : float = 1.2
@export var glow_duration : float = 0.3  # Duración del destello en segundos

@onready var border : TextureRect = $Border
@onready var cooldown_bar : TextureProgressBar = $CooldownBar
@onready var mask_manager : MaskManager = get_node("/root/Mask")

var cooling_down := false
var cooldown_left := 0.0

func _ready():
	# Configurar estado inicial del borde con su color base
	border.modulate = base_color
	
	# Configurar la barra de cooldown
	cooldown_bar.min_value = 0
	cooldown_bar.max_value = 100
	cooldown_bar.value = 100  # Empieza llena (lista para usar)
	
	# Configurar para llenar en sentido horario desde las 12
	cooldown_bar.fill_mode = TextureProgressBar.FILL_CLOCKWISE
	
	# Conectar señal del MaskManager
	mask_manager.changed_mask.connect(_on_mask_changed)

func _on_mask_changed(mask : MaskManager.ColorMask) -> void:
	# Si la máscara cambiada coincide con la nuestra, activar
		# Solo resplandece el borde correspondiente
	create_glow_flash()
	
	# Si no está en cooldown, iniciar cooldown
	if not cooling_down:
		start_cooldown()

func start_cooldown():
	cooling_down = true
	cooldown_left = cooldown_time
	cooldown_bar.value = 0  # Empieza vacía

func create_glow_flash():
	# Resplandor instantáneo del borde
	border.modulate = glow_color
	
	# Crear tween para volver al color base
	var tween = create_tween()
	tween.tween_property(border, "modulate", base_color, glow_duration)

func _process(delta: float) -> void:
	if not cooling_down:
		return
	
	# Reducir el cooldown
	cooldown_left -= delta
	
	# Calcular progreso: va de 0 a 100 mientras cooldown_left va de cooldown_time a 0
	var progress = ((cooldown_time - cooldown_left) / cooldown_time) * 100.0
	cooldown_bar.value = progress
	
	# Cuando termina el cooldown
	if cooldown_left <= 0:
		cooling_down = false
		cooldown_bar.value = 100  # Llenarla completamente y mantenerla ahí
		border.modulate = base_color  # Asegurar que esté en color base
