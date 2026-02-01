extends TileMapLayer

@export var color : MaskManager.ColorMask

func _ready() -> void:
	Mask.changed_mask.connect(_toggle_tiles)
	_toggle_tiles(Mask.current_mask)


func _toggle_tiles(mask : MaskManager.ColorMask):
	visible = color == mask
	collision_enabled = color == mask
	print("hola")
