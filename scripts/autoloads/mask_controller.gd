extends Control

@onready var blue_mask  : ColorRect = $Blue
@onready var green_mask : ColorRect = $Green
@onready var red_mask   : ColorRect = $Red

func _ready() -> void:
	# Conectamos al autoload MaskManager
	Mask.changed_mask.connect(_on_mask_changed)
	# Estado inicial (por si ya hay una mask seteada)
	if Mask.current_mask != null:
		_on_mask_changed(Mask.current_mask)

func _on_mask_changed(mask : MaskManager.ColorMask) -> void:
	# Apagamos todas primero
	_disable_mask(blue_mask)
	_disable_mask(green_mask)
	_disable_mask(red_mask)
	
	# Activamos solo la correspondiente
	match mask:
		MaskManager.ColorMask.BLUE:
			_enable_mask(blue_mask)
		MaskManager.ColorMask.GREEN:
			_enable_mask(green_mask)
		MaskManager.ColorMask.RED:
			_enable_mask(red_mask)

func _enable_mask(mask_node : ColorRect) -> void:
	mask_node.visible = true
	mask_node.set_process(true)
	mask_node.set_physics_process(true)

func _disable_mask(mask_node : ColorRect) -> void:
	mask_node.visible = false
	mask_node.set_process(false)
	mask_node.set_physics_process(false)
