class_name EnemyState_Wander extends EnemyState

@export var anim_name : String = "walk"
@export var wander_speed : float = 20.0

# Enemy AI is programmed based on timers, which means being in a state will take a random time, which will move to the next guranteed state
@export_category("AI")
@export var state_animation_duration_min : float = 0.5 # duration of walk animation
@export var state_cycles_min : int = 1
@export var state_cycles_max : int = 3
# random number of times the state repeats
@export var next_state : EnemyState # for flexibility, unique enemies can transition differently

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
	pass

## Called every frame during _process while this state is active.
## _delta is frame time. Return a new State to change to it, or null to stay.
func Process(_delta: float) -> EnemyState:
	_timer -= _delta
	if _timer <= 0:
		return next_state
	return null

## Called every physics frame during _physics_process while state is active.
## _delta is fixed physics step time. Return a new State to transition.
func Physics(_delta: float) -> EnemyState:
	return null
