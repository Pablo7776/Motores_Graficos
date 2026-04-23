extends Node
	  
var player
var current_state

@onready var idle_state = $IdleState
@onready var run_state = $RunState
@onready var jump_state = $JumpState

func init(owner):
	player = owner
	change_state(idle_state)

func change_state(new_state):
	if current_state:
		current_state.exit(player)

	current_state = new_state
	current_state.enter(player)

func update(delta):
	if current_state:
		current_state.update(player, delta)
