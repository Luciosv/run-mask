extends Enemy

@export var swing_angle := 20.0 # grados máximos
@export var swing_speed := 2.0  # velocidad del balanceo

var time := 0.0

func _process(delta):
	time += delta
	rotation = deg_to_rad(swing_angle) * sin(time * swing_speed)
