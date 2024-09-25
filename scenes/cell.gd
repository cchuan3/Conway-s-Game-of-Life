class_name Cell
extends Control

const STYLEBOX_CELL_ALIVE = preload("res://scenes/stylebox_cell_alive.tres")
const STYLEBOX_CELL_DEAD = preload("res://scenes/stylebox_cell_dead.tres")

enum CellState {ALIVE, DEAD, LENGTH}

@onready var panel: Panel = $Panel
@onready var selected_border: Panel = $SelectedBorder

var neighbors: Array[Cell]
var state: CellState : set = _set_state
var neighbors_alive: int
var stylebox: StyleBox
var selected := false : set = _set_selected

func _ready() -> void:
	state = CellState.DEAD

# Change color on state change
func _set_state(value: CellState) -> void:
	state = value
	match state:
		CellState.ALIVE:
			panel.add_theme_stylebox_override("panel", STYLEBOX_CELL_ALIVE)
		CellState.DEAD:
			panel.add_theme_stylebox_override("panel", STYLEBOX_CELL_DEAD)

# Change border on selected change
func _set_selected(value: bool) -> void:
	selected = value
	if selected:
		selected_border.show()
		Events.cell_selected.emit(self)
	else:
		selected_border.hide()
		Events.cell_deselected.emit()

# Change state on click
func _on_panel_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("Action_1"):
		state = Cell.get_next_cell_state(state)
	if event.is_action_pressed("Action_2"):
		selected = !selected

# Change state if click is held and moved in
func _on_panel_mouse_entered() -> void:
	if Input.is_action_pressed("Action_2"):
		state = Cell.get_next_cell_state(state)

# Static func to iterate through states
# if loop empty/true: ignore LENGTH and return to 1st state
# if loop false: allow LENGTH
static func get_next_cell_state(value: CellState, loop: bool = true) -> CellState:
	value = value + 1 as CellState
	if loop and value == CellState.LENGTH:
		value = 0 as CellState
	return value

# Static func to get an array of all cell states (Exclude LENGTH)
static func get_cell_state_array() -> Array[CellState]:
	var output: Array[CellState] = []
	for i in range(CellState.LENGTH):
		output.append(i as CellState)
	return output
