extends Node


@export var cooldown := 1.2 
# hay que cambiar el valor tambien en la escena UI

var time := 0.0
var can_use = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("blue_color") and can_use:
		Mask.change_mask(MaskManager.ColorMask.BLUE)
		can_use = false
	
	elif Input.is_action_just_pressed("red_color") and can_use:
		Mask.change_mask(MaskManager.ColorMask.RED)
		can_use = false
	
	elif Input.is_action_just_pressed("green_color") and can_use:
		Mask.change_mask(MaskManager.ColorMask.GREEN)
		can_use = false
	
	if not can_use : _handle_time(delta)


func _handle_time(delta: float):
	time += delta
	if time > cooldown : 
		can_use = true
		time = 0
