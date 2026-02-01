# PortalTransicion.gd
extends Area2D

@export var siguiente_nivel: String = "res://scenes/nivel_1.tscn"

func _on_body_entered(body):
	if body.name == "Player":  # O si tiene un grupo "player"
		# Transición básica
		get_tree().change_scene_to_file(siguiente_nivel)
		
		# O con efecto de fade (necesitas un ColorRect en la escena)
		# var tween = get_tree().create_tween()
		# tween.tween_property($ColorRect, "modulate:a", 1.0, 0.5)
		# await tween.finished
		# get_tree().change_scene_to_file(siguiente_nivel)
