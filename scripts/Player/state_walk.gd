class_name State_Walk extends State

var step_timer : float = 0.0  # countdown until next footstep

@export var move_speed : float = 100.0
@export var walk_sound : AudioStream
@export var step_interval : float = 0.2

@onready var idle: State_Idle = $"../Idle"
@onready var attack: State_Attack = $"../Attack"
@onready var audio_stream_player: AudioStreamPlayer = $"../../Audio/AudioStreamPlayer"

## What happens when player ENTERS this state?
func Enter() -> void:
	player.UpdateAnimation("walk")
	pass

## What happens when player EXITS this state?
func Exit() -> void:
	pass

## What happens during _process update in this state?
func Process(_delta: float) -> State:
	if player.direction == Vector2.ZERO:
		return idle
	
	player.velocity = player.direction * move_speed
	
	# Step sound timer
	step_timer -= _delta
	if step_timer <= 0.0:
		audio_stream_player.stream = walk_sound
		audio_stream_player.pitch_scale = randf_range(0.8, 1.4)
		audio_stream_player.play()
		step_timer = step_interval  # reset timer
	
	if player.SetDirection():
		player.UpdateAnimation("walk")
	return null
	
## What happens during _physics_process update in this state?
func Physics(_delta: float) -> State:
	return null
	
## What happens with input events in this state?
func HandleInput(_event: InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	return null
