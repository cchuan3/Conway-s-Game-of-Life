class_name Cell
extends Control

const STYLEBOX_CELL_ALIVE = preload("res://scenes/stylebox_cell_alive.tres")
const STYLEBOX_CELL_DEAD = preload("res://scenes/stylebox_cell_dead.tres")

enum CellState {ALIVE, DEAD, LENGTH}

@onready var color_rect: ColorRect = $ColorRect
@onready var panel: Panel = $Panel

var neighbors: Array[Cell]
var state: CellState : set = _set_state
var neighbors_alive: int
var stylebox: StyleBox

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

# Change state on click
func _on_panel_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("L_Mouse"):
		state = state + 1 as CellState
		if state == CellState.LENGTH:
			state = 0 as CellState

# Change state if click is held and moved in
func _on_panel_mouse_entered() -> void:
	if Input.is_action_pressed("L_Mouse"):
		state = state + 1 as CellState
		if state == CellState.LENGTH:
			state = 0 as CellState
