class_name State_Attack extends State

var attacking : bool = false

@onready var attack: State_Attack = $"../Attack"
@onready var idle: State_Idle = $"../Idle"
@onready var walk: State_Walk = $"../Walk"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

## What happens when player ENTERS this state?
func Enter() -> void:
	player.UpdateAnimation("attack")
	animation_player.animation_finished.connect( EndAttack ) # signals when animation is finished, calls EndAttack
	attacking = true
	pass

## What happens when player EXITS this state?
func Exit() -> void:
	animation_player.animation_finished.disconnect( EndAttack ) # disconnect signal so we can reconnect again
	attacking = false
	pass

## What happens during _process update in this state?
func Process(_delta: float) -> State:
	player.velocity = Vector2.ZERO # player is still
	
	if attacking == false:
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
