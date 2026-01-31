extends Enemy


@export var speed := 350

var direction : int
var timer := 0.0

const change_direction_delay = 0.1

@onready var sprite: AnimatedSprite2D = $Sprite


func _ready() -> void:
	super._ready()
	var directions = [-1,1]
	direction = directions.pick_random()


func _physics_process(delta: float) -> void:
	if not can_move : return
	
	if not is_on_floor() and timer > change_direction_delay: 
		direction *= -1
		sprite.flip_h = direction < 0
		timer = 0.0
	
	timer += delta
	
	velocity = Vector2.RIGHT * direction * speed
	move_and_slide()
	
