class_name Player extends CharacterBody2D

@export var speed := 200.0
@export var jump_force := 400.0
@export var gravity := 900.0

@onready var sprite_2d: Sprite2D = $Sprite2D



func _physics_process(delta: float) -> void:
	var direction := Input.get_action_strength("right") - Input.get_action_strength("left")
	
	velocity.x = direction * speed
	
	# flip sprite
	if direction != 0:
		sprite_2d.flip_h = direction < 0
	
	
	if not is_on_floor():
		
