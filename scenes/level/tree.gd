extends StaticBody2D

func _ready():
	$Sprite2D.frame = [0, 1].pick_random()
