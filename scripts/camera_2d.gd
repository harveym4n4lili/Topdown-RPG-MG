extends Camera2D

@onready var player: Player = $".."
@onready var window_scale : float
@onready var actual_cam_pos = global_position

var game_size = Vector2(960, 540)
var window_size := DisplayServer.window_get_size()

@export var move_speed : float = 2

func _physics_process(delta):
	# Copy the current window size to a local variable 'a' (Vector2i: integers)
	var a = window_size
	
	# Convert 'a' (Vector2i) to Vector2 of floats so we can do float division safely
	var b = Vector2(a.x, a.y)
	
	# Calculate the camera scale factor by dividing window size by the designed game size.
	# We only take the x-component here assuming uniform scaling or aspect ratio handling elsewhere.
	window_scale = (b / game_size).x
	
	# COMMENTED OUT: If using mouse-based camera offset, get mouse position normalized to viewport scale
	# var mouse_pos = Global.viewport.get_mouse_position() / window_scale - (game_size / 2) + player.global_position
	# var cam_pos = lerp(player.global_position, mouse_pos, 0.7)
	
	# Our target position for the camera is simply the player's global position.
	# You can modify this to add offsets like mouse position if desired.
	var target_pos = player.global_position
	
	# Smoothly move the actual camera position towards the target position.
	# 'lerp' here interpolates between current and target positions.
	# The interpolation factor is delta * move_speed, so it is frame-rate independent.
	actual_cam_pos = lerp(actual_cam_pos, target_pos, delta * move_speed)
	
	# Calculate the fractional subpixel offset between the rounded position and the actual position.
	# This is used for subtle shader effects to correct pixel alignment and avoid blur.
	var subpixel_position = actual_cam_pos.round() - actual_cam_pos
	
	# Update the 'cam_offset' shader parameter on the global viewport container material with this subpixel offset.
	# This allows the shader to compensate for subpixel camera movements for crisp rendering.
	Global.viewport_container.material.set_shader_parameter("cam_offset", subpixel_position)
	
	# Finally, set the Camera2D's global position to the rounded actual camera position.
	# Rounding snaps the camera to whole pixels to avoid pixel-blurring artifacts.
	global_position = actual_cam_pos.round()
