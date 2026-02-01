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
