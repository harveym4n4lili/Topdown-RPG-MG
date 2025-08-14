class_name EnemyStateMachine extends Node # similar to player state machine, includes calling of initialization method

var states : Array[EnemyState] # List of all states available as children nodes of this state machine.
var prev_state : EnemyState # The previous state before the current one. Useful for returning or state history.
var current_state: EnemyState # The currently active state controlling the player.

# Disables processing initially; will enable after initialization.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	pass  # Could initialize here or call Initialize externally.

# Called every frame; delegates update to current state's Process method.
func _process(delta: float) -> void:
	ChangeState(current_state.Process(delta))

# Called every physics frame; delegates to current state's Physics method.
func _physics_process(delta: float) -> void:
	ChangeState(current_state.Physics(delta))

# Initializes the state machine by collecting all child states and setting the first active.
# Passes a reference to the player instance to the first state.
func Initialize(_enemy : Enemy) -> void:
	states = []

	# Add all children that extend State to the states array.
	for c in get_children():
		if c is EnemyState:
			states.append(c)

	# Call initialization method for each enemy state
	for s in states:
		s.enemy = _enemy
		s.state_machine = self
		s.Init()
	
	if states.size() > 0:
		ChangeState(states[0])
		process_mode = Node.PROCESS_MODE_INHERIT # when game paused, enemies pause to
		
# Handles changing the current state to a new state.
# Calls Exit on the old state and Enter on the new.
func ChangeState(new_state: EnemyState) -> void:
	# Ignore if new_state is null or the same as current.
	if new_state == null || new_state == current_state:
		return

	# Clean up current state.
	if current_state:
		current_state.Exit()

	prev_state = current_state
	current_state = new_state
	current_state.Enter()
