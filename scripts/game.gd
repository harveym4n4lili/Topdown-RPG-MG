extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.viewport_container = get_node("SubViewportContainer")
	Global.viewport = get_node("SubViewportContainer/SubViewport")
	pass # Replace with function body.
