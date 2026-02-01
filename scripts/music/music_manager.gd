extends Node

@export var music_resource : Resource  # Rep
@export var crossfade_duration : float = 1.0
@export var master_volume_db : float = 0.0  # Volumen general de la música
@export var fade_out_volume_db : float = -80.0  # Volumen al hacer fade out

@onready var mask_manager : MaskManager = get_node("/root/Mask")

# Audio players para cada pista
var player_red : AudioStreamPlayer
var player_blue : AudioStreamPlayer
var player_green : AudioStreamPlayer

var current_mask : MaskManager.ColorMask

func _ready():
	# Crear los audio players
	player_red = AudioStreamPlayer.new()
	player_blue = AudioStreamPlayer.new()
	player_green = AudioStreamPlayer.new()
	
	add_child(player_red)
	add_child(player_blue)
	add_child(player_green)
	
	# Asignar las pistas desde el resource
	player_red.stream = music_resource.RED
	player_blue.stream = music_resource.BLUE
	player_green.stream = music_resource.GREEN
	
	# Configurar para loop
	player_red.stream.loop = true
	player_blue.stream.loop = true
	player_green.stream.loop = true
	
	# Iniciar todas las pistas sincronizadas
	player_red.play()
	player_blue.play()
	player_green.play()
	
	# Configurar volúmenes iniciales (silencio total)
	player_red.volume_db = fade_out_volume_db
	player_blue.volume_db = fade_out_volume_db
	player_green.volume_db = fade_out_volume_db
	
	# Conectar señal del MaskManager
	mask_manager.changed_mask.connect(_on_mask_changed)
	
	# Obtener máscara inicial y activar su música
	current_mask = mask_manager.current_mask
	set_active_track(current_mask, true)  # Activar sin fade al inicio

func _on_mask_changed(mask : MaskManager.ColorMask) -> void:
	if mask == current_mask:
		return
	
	# Fade out de la pista actual
	fade_out_track(current_mask)
	
	# Fade in de la nueva pista
	fade_in_track(mask)
	
	current_mask = mask

func fade_in_track(mask : MaskManager.ColorMask):
	var player = get_player_by_mask(mask)
	if not player:
		return
	
	var tween = create_tween()
	tween.tween_property(player, "volume_db", master_volume_db, crossfade_duration)

func fade_out_track(mask : MaskManager.ColorMask):
	var player = get_player_by_mask(mask)
	if not player:
		return
	
	var tween = create_tween()
	tween.tween_property(player, "volume_db", fade_out_volume_db, crossfade_duration)

func set_active_track(mask : MaskManager.ColorMask, instant : bool = false):
	"""Activa una pista sin fade (para inicio del juego)"""
	var player = get_player_by_mask(mask)
	if not player:
		return
	
	if instant:
		player.volume_db = master_volume_db
	else:
		fade_in_track(mask)

func get_player_by_mask(mask : MaskManager.ColorMask) -> AudioStreamPlayer:
	match mask:
		MaskManager.ColorMask.RED:
			return player_red
		MaskManager.ColorMask.BLUE:
			return player_blue
		MaskManager.ColorMask.GREEN:
			return player_green
	return null
