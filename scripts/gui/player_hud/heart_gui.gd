class_name HeartGUI extends Control

@onready var sprite_2d = $Sprite2D

var value : int = 2 :
	set(_value):
		value = _value
		UpdateSprite()

## update sprite frame to health value as frame = heart value
func UpdateSprite() -> void:
	sprite_2d.frame = value
