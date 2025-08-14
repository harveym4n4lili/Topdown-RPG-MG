class_name EnemyState_Destroy extends EnemyState

@export var anim_name : String = "destroy"
@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0

@export var next_state : EnemyState # for flexibility, unique enemies can transition differently
var _animation_finished : bool = false

@export_category("Sound")
@export var stream : AudioStream
@export var volume : float
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $"../../AudioStreamPlayer2D"

var _timer : float = 0.0
var _direction : Vector2

## What happens when the enemy initializes this state?
func Init() -> void:
	enemy.enemy_destroyed.connect(_on_enemy_destroyed)
	pass

## What happens when enemy ENTERS this state?
func Enter() -> void:
	enemy.invulnerable = true
	
	_direction = enemy.global_position.direction_to(GlobalPlayerManager.player.global_position) # initialise direction
	
	enemy.SetDirection(_direction)
	enemy.velocity = _direction * -knockback_speed 
	enemy.UpdateAnimation(anim_name)
	
	audio_stream_player_2d.stream = stream
	audio_stream_player_2d.volume_db = volume # custom volume 
	audio_stream_player_2d.pitch_scale = randf_range(0.8, 1.4) # sound randomness
	audio_stream_player_2d.play()
	
	enemy.animation_player.connect("animation_finished", _on_animation_finished)
	pass

## What happens when enemy EXITS this state?
func Exit() -> void:
	enemy.animation_player.disconnect("animation_finished", _on_animation_finished)
	enemy.invulnerable = false
	audio_stream_player_2d.volume_db = 0
	audio_stream_player_2d.pitch_scale = 0
	pass

## Called every frame during _process while this state is active.
## _delta is frame time. Return a new State to change to it, or null to stay.
func Process(_delta: float) -> EnemyState:
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta # apply knockback
	return null

## Called every physics frame during _physics_process while state is active.
## _delta is fixed physics step time. Return a new State to transition.
func Physics(_delta: float) -> EnemyState:
	
	return null
	
func _on_enemy_destroyed() -> void:
	state_machine.ChangeState( self ) # this state can interrupt any transition

func _on_animation_finished(_a : String) -> void:
	#enemy.queue_free()
	pass
