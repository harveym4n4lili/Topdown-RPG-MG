extends CharacterBody2D

var move_speed : float = 100.0

# Called when node enters tree for the irst time.
func _ready() -> void:
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var direction : Vector2 = Vector2.ZERO
	# referring to input maps
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")

	velocity = direction * move_speed
	
	pass
	
func _physics_process(delta: float) -> void:
	move_and_slide()
