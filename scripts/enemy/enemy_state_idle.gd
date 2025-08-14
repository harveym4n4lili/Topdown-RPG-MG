class_name EnemyState_Idle extends EnemyState

@export var anim_name : String = "idle"

# Enemy AI is programmed based on timers, which means being in a state will take a random time, which will move to the next guranteed state
@export_category("AI")
@export var state_duration_min : float = 0.5
@export var state_duration_max : float = 1.5
@export var next_state : EnemyState # for flexibility, unique enemies can transition differently to different states

var _timer : float = 0.0

## What happens when the enemy initializes this state?
func Init() -> void:
	pass

## What happens when enemy ENTERS this state?
func Enter() -> void:
	enemy.velocity = Vector2.ZERO # enemy stops moving
	_timer = randf_range(state_duration_min, state_duration_max)
	enemy.UpdateAnimation(anim_name)
	pass

## What happens when enemy EXITS this state?
func Exit() -> void:
	pass

## Called every frame during _process while this state is active.
## _delta is frame time. Return a new State to change to it, or null to stay.
func Process(_delta: float) -> EnemyState:
	_timer -= _delta # decrement timer
	if _timer <= 0:
		return next_state
	return null

## Called every physics frame during _physics_process while state is active.
## _delta is fixed physics step time. Return a new State to transition.
func Physics(_delta: float) -> EnemyState:
	return null
