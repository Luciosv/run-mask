extends Node

# Configuración de velocidad de saturación
@export_group("Saturation Speed")
@export var volume_saturation_speed : float = 2.0  # dB por segundo
@export var alpha_saturation_speed : float = 0.1  # Interpolación por segundo (0-1)
@export var particles_saturation_speed : float = 10.0  # Amount por segundo

# Configuración de límites
@export_group("Volume Limits")
@export var volume_min : float = 0.0
@export var volume_max : float = 6.0  # Máximo antes de saturar

# Configuración de alpha (por cada máscara)
@export_group("Alpha Limits")
@export var alpha_min : float = 0.0
@export var alpha_max : float = 1.0

# Configuración de partículas
@export_group("Particles Limits")
@export var particles_min : int = 10
@export var particles_max : int = 500

# Referencias
@onready var mask_manager : MaskManager = get_node("/root/Mask")
@onready var music_manager: Node2D = $"../MusicManager"
@onready var red: ColorRect = $"../RGB/Red"
@onready var red_particles: CPUParticles2D = $Red/RedParticles
@onready var blue: ColorRect = $"../RGB/Blue"
@onready var blue_particles: CPUParticles2D = $Blue/BlueParticles
@onready var green: ColorRect = $"../RGB/Green"
@onready var green_particles: CPUParticles2D = $Green/GreenParticles

# Estado actual
var current_mask : Mask.ColorMask
var saturation_time : float = 0.0

func _ready():
	mask_manager.changed_mask.connect(_on_mask_changed)
	current_mask = mask_manager.current_mask
	reset_saturation()

func _on_mask_changed(mask : MaskManager.ColorMask):
	current_mask = mask
	reset_saturation()

func reset_saturation():
	saturation_time = 0.0
	
	# Resetear volumen
	if music_manager:
		music_manager.master_volume_db = volume_min
	
	# Resetear partículas
	set_particles_amount(red_particles, particles_min)
	set_particles_amount(blue_particles, particles_min)
	set_particles_amount(green_particles, particles_min)

func _process(delta: float):
	saturation_time += delta
	
	# Saturar volumen
	saturate_volume(delta)
	
	# Saturar alpha del ColorRect activo
	
	# Saturar partículas activas
	saturate_particles(delta)

func saturate_volume(delta: float):
	if not music_manager:
		return
	
	var new_volume = music_manager.master_volume_db + (volume_saturation_speed * delta)
	music_manager.master_volume_db = clamp(new_volume, volume_min, volume_max)

func saturate_particles(delta: float):
	var amount_increase = particles_saturation_speed * delta
	
	match current_mask:
		MaskManager.ColorMask.RED:
			increase_particles_amount(red_particles, amount_increase)
		MaskManager.ColorMask.BLUE:
			increase_particles_amount(blue_particles, amount_increase)
		MaskManager.ColorMask.GREEN:
			increase_particles_amount(green_particles, amount_increase)

func increase_particles_amount(particles: CPUParticles2D, increase: float):
	if not particles:
		return
	var new_amount = particles.amount + int(increase)
	particles.amount = clamp(new_amount, particles_min, particles_max)

func set_particles_amount(particles: CPUParticles2D, amount: int):
	if not particles:
		return
	particles.amount = amount
