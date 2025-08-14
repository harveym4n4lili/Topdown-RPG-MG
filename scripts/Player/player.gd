class_name Player extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.DOWN # Facing direction
var direction : Vector2 = Vector2.ZERO # Intended movement
var move_speed : float = 100.0

const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: PlayerStateMachine = $StateMachine

signal DirectionChanged(new_direction: Vector2) # used for interaction nodes

# Called when node enters tree for the first time.
func _ready() -> void:
	GlobalPlayerManager.player = self # set global player to this instance
	state_machine.Initialize(self)
	pass
	
func _physics_process(delta: float) -> void:
	# position update ---
	# referring to input maps
	#direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	#direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized() # .normalize fixes increased speed in diagonal movement
	  # Calculate velocity vector scaled by move_speed
	var velocity = direction * move_speed
	
	# Move with subpixel precision (move_and_slide works with Vector2 floats)
	# move_and_slide applies collision, returns actual velocity 
	velocity = move_and_slide()
	pass
	
## Method to update cardinal direction variable
func SetDirection() -> bool:
	if direction == Vector2.ZERO: # No movement input, don't set direction
		return false
	
	var new_dir : Vector2
	
	# Prioritize horizontal movement for diagonal inputs
	if abs(direction.x) >= abs(direction.y):
		# More horizontal than vertical movement (or equal - prioritize side)
		new_dir = Vector2.RIGHT if direction.x > 0 else Vector2.LEFT
	else:
		# More vertical than horizontal movement
		new_dir = Vector2.DOWN if direction.y > 0 else Vector2.UP
	
	if new_dir == cardinal_direction: # Direction did not change, don't set direction
		return false 
	
	# flip sprite if facing left
	sprite_2d.scale.x = -1 if new_dir == Vector2.LEFT else 1
	# Update cardinal direction
	cardinal_direction = new_dir
	DirectionChanged.emit(new_dir)
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
