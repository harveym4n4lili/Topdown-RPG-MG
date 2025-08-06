class_name PlayerStateMachine extends Node


var states : Array[State] # List of all states available as children nodes of this state machine.
var prev_state : State # The previous state before the current one. Useful for returning or state history.
var current_state: State # The currently active state controlling the player.

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

# Forwards input events to the current state's HandleInput method.
func _unhandled_input(event: InputEvent) -> void:
	ChangeState(current_state.HandleInput(event))

# Initializes the state machine by collecting all child states and setting the first active.
# Passes a reference to the player instance to the first state.
func Initialize(_player : Player) -> void:
	states = []

	# Add all children that extend State to the states array.
	for c in get_children():
		if c is State:
			states.append(c)

	# Set the first state as active and assign the player reference.
	if states.size() > 0:
		states[0].player = _player
		ChangeState(states[0])
		process_mode = Node.PROCESS_MODE_INHERIT  # Enable processing for this node.

# Handles changing the current state to a new state.
# Calls Exit on the old state and Enter on the new.
func ChangeState(new_state: State) -> void:
	# Ignore if new_state is null or the same as current.
	if new_state == null || new_state == current_state:
		return

	# Clean up current state.
	if current_state:
		current_state.Exit()

	prev_state = current_state
	current_state = new_state
	current_state.Enter()
