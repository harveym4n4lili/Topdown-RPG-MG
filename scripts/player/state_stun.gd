class_name State_Stun extends State

@export var knockback_speed : float = 100.0
@export var decelerate_speed : float = 10.0
@export var invulnerable_duration : float = 1.4

@onready var idle: State_Idle = $"../Idle"

var step_timer : float = 0.0  # countdown until next footstep

var direction : Vector2 = Vector2.ZERO
var hurt_box : HurtBox = null
var next_state : State = null

## What happens when the enemy initializes this state?
func Init() -> void:
	player.PlayerDamaged.connect(_on_player_damaged)
	pass

## What happens when player ENTERS this state?
func Enter() -> void:
	player.animation_player.animation_finished.connect(_on_animation_finished)
	
	direction = player.global_position.direction_to(hurt_box.global_position)
	player.velocity = direction * -knockback_speed # player knockback set
	player.SetDirection()
	
	player.make_invulnerable(invulnerable_duration)
	player.UpdateAnimation("stun")
	player.effect_animation_player.play("damaged")
	pass

## What happens when player EXITS this state?
func Exit() -> void:
	next_state = null
	player.animation_player.animation_finished.disconnect(_on_animation_finished)
	pass

## What happens during _process update in this state?
func Process(_delta: float) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	return next_state
	
## What happens during _physics_process update in this state?
func Physics(_delta: float) -> State:
	return null
	
## What happens with input events in this state?
func HandleInput(_event: InputEvent) -> State:
	return null

func _on_player_damaged(_hurt_box : HurtBox) -> void:
	hurt_box = _hurt_box
	state_machine.ChangeState(self)
	pass
	
func _on_animation_finished(_a : String) -> void:
	next_state = idle
