extends Level


func _on_win_area_body_entered(body: Node2D) -> void:
	win.emit()
