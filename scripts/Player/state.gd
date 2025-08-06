class_name State extends Node

## Reference to the Player node that this state controls.
## Declared static so it's shared across all states, assuming one player instance.
static var player: Player

## Called when the node enters the scene tree initially.
## Use this for any setup your base state might require.
func _ready() -> void:
	pass  # Override in child states if needed.

## Called when the player ENTERS this state.
## Use this to set up animations, variables, or reset flags.
func Enter() -> void:
	pass

## Called when the player EXITS this state.
## Clean up or reset anything related to this state here.
func Exit() -> void:
	pass

## Called every frame during _process while this state is active.
## _delta is frame time. Return a new State to change to it, or null to stay.
func Process(_delta: float) -> State:
	return null

## Called every physics frame during _physics_process while state is active.
## _delta is fixed physics step time. Return a new State to transition.
func Physics(_delta: float) -> State:
	return null

## Handles input events passed to this state.
## Return a new State to switch, or null to remain.
func HandleInput(_event: InputEvent) -> State:
	return null
