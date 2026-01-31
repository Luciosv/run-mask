class_name MaskManager extends Node

enum ColorMask {
	RED,
	BLUE,
	GREEN
}

signal changed_mask(mask:ColorMask)

var current_mask : ColorMask


func change_mask(mask : ColorMask):
	current_mask = mask
	changed_mask.emit(current_mask)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("blue_color"):
		change_mask(ColorMask.BLUE)
	
	elif Input.is_action_just_pressed("red_color"):
		change_mask(ColorMask.RED)
	
	elif Input.is_action_just_pressed("green_color"):
		change_mask(ColorMask.GREEN)
