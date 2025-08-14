class_name EnemyState extends Node # similar to state script for player

## stores reference to enemy that state belongs to
var enemy: Enemy # not static, as many enemies will have different behaviours
var state_machine : EnemyStateMachine

## Called when the node enters the scene tree initially.
## What happens when the enemy initializes this state?
func Init() -> void:
	pass

## Called when the enemy ENTERS this state.
## Use this to set up animations, variables, or reset flags.
func Enter() -> void:
	pass

## Called when the enemy EXITS this state.
## Clean up or reset anything related to this state here.
func Exit() -> void:
	pass

## Called every frame during _process while this state is active.
## _delta is frame time. Return a new State to change to it, or null to stay.
func Process(_delta: float) -> EnemyState:
	return null

## Called every physics frame during _physics_process while state is active.
## _delta is fixed physics step time. Return a new State to transition.
func Physics(_delta: float) -> EnemyState:
	return null
