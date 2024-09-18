class_name Cell
extends Control

enum CellState {ALIVE, DEAD, LENGTH}

@onready var color_rect: ColorRect = $ColorRect

var neighbors: Array[Cell]
var state: CellState : set = _set_state
var neighbors_alive: int

func _ready() -> void:
	state = CellState.DEAD

# Change color on state change
func _set_state(value: CellState) -> void:
	state = value
	match state:
		CellState.ALIVE:
			color_rect.self_modulate = Color(0, 0, 0)
		CellState.DEAD:
			color_rect.self_modulate = Color(1, 1, 1)

# Change state on click
func _on_color_rect_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("L_Mouse"):
		state = state + 1 as CellState
		if state == CellState.LENGTH:
			state = 0 as CellState
