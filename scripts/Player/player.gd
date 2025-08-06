class_name Player extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.DOWN # Facing direction
var direction : Vector2 = Vector2.ZERO # Intended movement
var move_speed : float = 100.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine

# Called when node enters tree for the first time.
func _ready() -> void:
	state_machine.Initialize(self)
	pass

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# position update ---
	# referring to input maps
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	pass
	
func _physics_process(delta: float) -> void:
	move_and_slide()
	
## Method to update cardinal direction variable
func SetDirection() -> bool:
	if direction == Vector2.ZERO: # No movement input, don't set direction
		return false

	var new_dir : Vector2 = cardinal_direction
	
	if direction.y == 0: # LEFT or RIGHT
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0: # UP or DOWN
		new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN
	
	if new_dir == cardinal_direction: # Direction did not change, don't set direction
		return false 
	
	# flip sprite if facing left
	animated_sprite_2d.scale.x = -1 if new_dir == Vector2.LEFT else 1
	# Update cardinal direction
	cardinal_direction = new_dir
	return true
	
## Method for finding the right animation to play
func UpdateAnimation( state : String ) -> void:
	animated_sprite_2d.play( state + "_" + AnimDirection())
	pass
	
## Method for finding right direction string using cardinal direction
func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"
