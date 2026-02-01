extends Enemy

@export var detection_area: Area2D
@export var speed := 500.0

@export var move_time := 0.4
@export var wait_time := 0.6

@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var sprite: AnimatedSprite2D = $Sprite


enum State {
	IDLE,
	MOVING
}

var state: State = State.IDLE

var target: Node2D
var init_position: Vector2

var timer := 0.0
var move_dir := Vector2.ZERO


func _ready() -> void:
	super._ready()

	init_position = global_position

	agent.path_desired_distance = 4.0
	agent.target_desired_distance = 4.0

	detection_area.body_entered.connect(_on_target_enter)
	detection_area.body_exited.connect(_on_target_exit)


func _physics_process(delta: float) -> void:
	if not can_move:
		return

	timer += delta

	match state:
		State.IDLE:
			_update_idle()
		State.MOVING:
			_update_moving()


# -------------------------
# STATE: IDLE
# -------------------------
func _update_idle():
	if timer >= wait_time:
		_start_move()


# -------------------------
# STATE: MOVING
# -------------------------
func _update_moving():
	_move_step()

	if timer >= move_time:
		_stop_move()


# -------------------------
# START / STOP MOVE
# -------------------------
func _start_move():
	state = State.MOVING
	timer = 0.0
	
	
	# Elegimos destino UNA vez
	if target:
		agent.target_position = target.global_position
	else:
		agent.target_position = init_position
	
	
	if agent.is_navigation_finished():
		move_dir = Vector2.ZERO
		return

	var next_pos := agent.get_next_path_position()
	var dir := next_pos - global_position

	# Elegimos eje dominante (no diagonal)
	if abs(dir.x) > abs(dir.y):
		move_dir = Vector2(sign(dir.x), 0)
		sprite.play("BlueH")
		sprite.flip_h = move_dir.x < 0
		sprite.flip_v = false
	else:
		move_dir = Vector2(0, sign(dir.y))
		sprite.play("BlueV")
		sprite.flip_v = move_dir.y > 0
		sprite.flip_h = false


func _stop_move():
	state = State.IDLE
	move_dir = Vector2.ZERO
	timer = 0.0
	sprite.play("BlueIDLE")


# -------------------------
# MOVEMENT
# -------------------------
func _move_step():
	if move_dir == Vector2.ZERO:
		return

	velocity = move_dir * speed
	move_and_slide()


# -------------------------
# TARGET DETECTION
# -------------------------
func _on_target_enter(body: Node2D):
	target = body
	_start_move()


func _on_target_exit(_body: Node2D):
	target = null
	_stop_move()
