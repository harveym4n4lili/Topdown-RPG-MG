extends Area2D

@onready var teleporter_animation_player = $"../AnimationPlayer"
var player_effect_animation_player = null
var player = null

func _ready():
	player = GlobalPlayerManager.player
	player_effect_animation_player = player.effect_animation_player
	if not area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)
	
func _on_area_entered(body):
	if body == player:
		# Play teleporter animation
		teleporter_animation_player.play("teleport")
		# Play player teleport animation
		player_effect_animation_player.play("teleport")  # Adjust node path if different
		# Connect to teleporter animation finished signal
		teleporter_animation_player.animation_finished.connect(_on_teleporter_animation_finished)

func _on_teleporter_animation_finished(anim_name: String) -> void:
	if anim_name == "teleport":
		teleporter_animation_player.animation_finished.disconnect(_on_teleporter_animation_finished)
		# Trigger scene load
		load_new_scene()

func load_new_scene():
	# Implement your scene change logic here
	print("Scene load triggered!")
	# Example:
	# get_tree().change_scene("res://path_to_your_new_scene.tscn")
