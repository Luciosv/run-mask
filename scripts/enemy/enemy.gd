class_name Enemy extends CharacterBody2D

@export var color : MaskManager.ColorMask
var can_move := false


func _ready() -> void:
	Mask.changed_mask.connect(_on_changed_mask)
	can_move = not Mask.current_mask == color


func _on_changed_mask(mask:MaskManager.ColorMask):
	can_move = not mask == color
