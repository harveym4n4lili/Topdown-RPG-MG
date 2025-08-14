class_name EnemyState_Wander extends EnemyState

@export var anim_name : String = "walk"
@export var wander_speed : float = 20.0

@export_category("Sound")
@export var walk_sound : AudioStream
@export var step_interval : float = 0.2
@export var volume : float
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $"../../AudioStreamPlayer2D"

# Enemy AI is programmed based on timers, which means being in a state will take a random time, which will move to the next guranteed state
@export_category("AI")
@export var state_animation_duration_min : float = 0.5 # duration of walk animation
@export var state_cycles_min : int = 1
@export var state_cycles_max : int = 3
# random number of times the state repeats
@export var next_state : EnemyState # for flexibility, unique enemies can transition differently

var step_timer : float = 0.0  # countdown until next footstep

var _timer : float = 0.0
var _direction : Vector2

## What happens when the enemy initializes this state?
func Init() -> void:
	pass

## What happens when enemy ENTERS this state?
func Enter() -> void:
	_timer = randi_range(state_cycles_min, state_cycles_max) * state_animation_duration_min # pick random cycles, multiple of walk animation duration 
	var rand = randi_range(0, 3) # pick random dir
	_direction = enemy.DIR_4[rand] # convert to vector in enemy script

	enemy.velocity = _direction * wander_speed
	enemy.SetDirection(_direction)
	enemy.UpdateAnimation(anim_name)
	pass

## What happens when enemy EXITS this state?
func Exit() -> void:
	if audio_stream_player_2d.pitch_scale != 0:
		audio_stream_player_2d.pitch_scale = 0 # reset pitch
	pass

## Called every frame during _process while this state is active.
## _delta is frame time. Return a new State to change to it, or null to stay.
func Process(_delta: float) -> EnemyState:
	_timer -= _delta
	
	# Step sound timer
	step_timer -= _delta
	if step_timer <= 0.0:
		audio_stream_player_2d.stream = walk_sound
		audio_stream_player_2d.pitch_scale = randf_range(0.8, 1.4)
		audio_stream_player_2d.play()
		step_timer = step_interval  # reset timer
	
	if _timer <= 0:
		return next_state
	return null

## Called every physics frame during _physics_process while state is active.
## _delta is fixed physics step time. Return a new State to transition.
func Physics(_delta: float) -> EnemyState:
	return null
