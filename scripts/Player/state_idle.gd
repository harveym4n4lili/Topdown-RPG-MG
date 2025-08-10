class_name State_Idle extends State

@onready var walk: State_Walk = $"../Walk"
@onready var attack: State_Attack = $"../Attack"

## What happens when player ENTERS this state?
func Enter() -> void:
	player.UpdateAnimation("idle")
	pass

## What happens when player EXITS this state?
func Exit() -> void:
	pass

## What happens during _process update in this state?
func Process(_delta: float) -> State:
	if player.direction != Vector2.ZERO:
		return walk
	player.velocity = Vector2.ZERO
	return null
	
## What happens during _physics_process update in this state?
func Physics(_delta: float) -> State:
	return null
	
## What happens with input events in this state?
func HandleInput(_event: InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	return null
