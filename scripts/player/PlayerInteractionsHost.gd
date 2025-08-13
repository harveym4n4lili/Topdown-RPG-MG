class_name PlayersInteractionsHost extends Node2D

@onready var player: Player = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.DirectionChanged.connect(UpdateDirection) # connect to player's update direction signal to retrieve new direction
	pass # Replace with function body.

## Update rotation of interaction child nodes
func UpdateDirection(new_direction:Vector2) -> void:
	# match same as switch case in java
	match new_direction:
		Vector2.ZERO:
			rotation_degrees = 0
		Vector2.UP:
			rotation_degrees = 180
		Vector2.LEFT:
			rotation_degrees = 90
		Vector2.RIGHT:
			rotation_degrees = -90
		_:
			rotation_degrees = 0
	pass
