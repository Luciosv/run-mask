class_name Player extends CharacterBody2D

signal hurt

# =========================
# === MOVIMIENTO ==========
# =========================
@export_category("Movement")
@export var max_speed := 180.0
@export var acceleration := 1200.0
@export var deceleration := 1600.0
@export var air_control := 0.8


# =========================
# === SALTO ===============
# =========================
@export_category("Jump")
@export var jump_height := 96.0              # unidades del mundo (ej: 3 tiles de 32)
@export var jump_time_to_peak := 0.4         # segundos
@export var fall_gravity_multiplier := 1.6
@export var low_jump_multiplier := 2.2


# =========================
# === PERDÓN AL JUGADOR ===
# =========================
@export_category("Forgiveness")
@export var coyote_time := 0.12
@export var jump_buffer_time := 0.12


# =========================
# === VARIABLES INTERNAS ==
# =========================
var gravity := 0.0
var jump_velocity := 0.0

var coyote_timer := 0.0
var jump_buffer_timer := 0.0

var can_move = true
var gravity_active = true


@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


# =========================
# === READY ===============
# =========================
func _ready() -> void:
	# Matemática del salto (esto es CLAVE)
	gravity = (2.0 * jump_height) / pow(jump_time_to_peak, 2)
	jump_velocity = gravity * jump_time_to_peak


# =========================
# === PHYSICS PROCESS =====
# =========================
func _physics_process(delta: float) -> void:
	_handle_timers(delta)
	
	if can_move :
		_handle_horizontal(delta)
		_handle_jump()
	
	if gravity_active:
		_apply_gravity(delta)

	move_and_slide()


# =========================
# === MOVIMIENTO HORIZONTAL
# =========================
func _handle_horizontal(delta: float) -> void:
	var input := Input.get_axis("left", "right")
	var target_speed := input * max_speed
	
	if is_on_floor():
		sprite.play("idle")

	var accel := acceleration
	if not is_on_floor():
		accel *= air_control

	if input != 0:
		velocity.x = move_toward(velocity.x, target_speed, accel * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)
	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false
	

# =========================
# === SALTO ===============
# =========================
func _handle_jump() -> void:
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time

	if jump_buffer_timer > 0 and coyote_timer > 0:
		_do_jump()


func _do_jump() -> void:
	velocity.y = -jump_velocity
	jump_buffer_timer = 0
	coyote_timer = 0
	sprite.play("start-jump")


# =========================
# === GRAVEDAD ============
# =========================
func _apply_gravity(delta: float) -> void:
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		var applied_gravity := gravity

		# Cayendo → más pesado
		if velocity.y > 0:
			applied_gravity *= fall_gravity_multiplier

		# Subiendo pero soltó salto → corte natural
		elif velocity.y < 0 and not Input.is_action_pressed("jump"):
			applied_gravity *= low_jump_multiplier

		velocity.y += applied_gravity * delta
		
		if velocity.y < 0:
			sprite.play("jumping")
		else:
			sprite.play("falling")


# =========================
# === TIMERS ==============
# =========================
func _handle_timers(delta: float) -> void:
	if coyote_timer > 0:
		coyote_timer -= delta

	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta


func _on_hurt_area_area_entered(area: Area2D) -> void:
	velocity = Vector2.ZERO
	
	can_move = false
	gravity_active = false
	
	sprite.play("falling")
	
	var original_scale = scale
	var tween = create_tween()
	tween.tween_property(self,'scale',original_scale/2,0.3)
	await tween.finished
	tween = create_tween()
	tween.tween_property(self,'scale',original_scale,0.3)
	await tween.finished
	
	hurt.emit()


func restart_player():
	can_move = true
	gravity_active = true
	sprite.play("idle")
