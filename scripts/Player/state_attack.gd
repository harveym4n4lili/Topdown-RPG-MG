class_name State_Attack extends State

var attacking : bool = false

@export_category("Attack Attributes")
@export_range(1, 20, 0.5) var decelerate_speed : float = 5 # decelerate effect vars
@export var cooldown_time: float = 0.2  # seconds

@export_category("Sound")
@export var attack_sound : AudioStream
@export_range(-10, 10, 0.5) var volume : float
@onready var audio_stream_player: AudioStreamPlayer = $"../../Audio/AudioStreamPlayer"

@onready var attack: State_Attack = $"../Attack"
@onready var idle: State_Idle = $"../Idle"
@onready var walk: State_Walk = $"../Walk"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var attack_animation_player: AnimationPlayer = $"../../Sprite2D/Attack/AttackAnimation"

signal attack_performed(cooldown: float)

## What happens when player ENTERS this state?
func Enter() -> void:
	# HANDLE ANIMATION
	player.UpdateAnimation("attack")
	attack_animation_player.play("attack_"+player.AnimDirection())

	# PLAY SOUND
	audio_stream_player.stream = attack_sound
	audio_stream_player.volume_db = volume
	audio_stream_player.pitch_scale = randf_range(0.8, 1.4)
	audio_stream_player.play()
	
	attacking = true
	animation_player.animation_finished.connect( EndAttack ) # signals when animation is finished, calls EndAttack
	pass

## What happens when player EXITS this state?
func Exit() -> void:
	animation_player.animation_finished.disconnect( EndAttack ) # disconnect
	audio_stream_player.volume_db = 0
	attacking = false
	pass

## What happens during _process update in this state?
func Process(_delta: float) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta # decelerate player when attacking (slide effect)
	
	if not attacking: # handle transition ot other nodes
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null
	
## What happens during _physics_process update in this state?
func Physics(_delta: float) -> State:
	return null
	
## What happens with input events in this state?
func HandleInput(_event: InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	return null

func EndAttack( _newAnimName : String) -> void:
	attacking = false
