class_name Enemy extends CharacterBody2D # similar to player script
# enemy movement direction and velocity is handled in state scripts

signal direction_changed(new_direction : Vector2)
signal enemy_damaged()

const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

@export var hp : int = 3

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var player : Player
var invulnerable : bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
#@onready var hit_box : HitBox = $Hitbox
@onready var state_machine : EnemyStateMachine = $EnemyStateMachine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine.Initialize(self)
	player = GlobalPlayerManager.player
	pass # Replace with function body.

func _physics_process(_delta: float) -> void:
	move_and_slide()
	pass

# Method to update cardinal direction variable
func SetDirection(_new_direction : Vector2) -> bool:
	if _new_direction == Vector2.ZERO: # No movement input, don't set direction
		return false
	
	var new_dir : Vector2
	
	# Prioritize horizontal movement for diagonal inputs
	if abs(_new_direction.x) >= abs(_new_direction.y):
		# More horizontal than vertical movement (or equal - prioritize side)
		new_dir = Vector2.RIGHT if _new_direction.x > 0 else Vector2.LEFT
	else:
		# More vertical than horizontal movement
		new_dir = Vector2.DOWN if _new_direction.y > 0 else Vector2.UP
	
	if new_dir == cardinal_direction: # Direction did not change, don't set direction
		return false 
	
	# flip sprite if facing left
	sprite_2d.scale.x = -1 if new_dir == Vector2.LEFT else 1
	# Update cardinal direction
	cardinal_direction = new_dir
	direction_changed.emit(new_dir)
	return true

## Method for finding the right animation to play
func UpdateAnimation( state : String ) -> void:
	animation_player.play( state + "_" + AnimDirection())
	pass
	
## Method for finding right direction string using cardinal direction
func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"
