extends Node2D

const CELL_SCENE := preload("res://scenes/cell.tscn")

@onready var grid_container: GridContainer = %GridContainer

@export_range(1,100) var column_size: int
@export_range(1,100) var row_size: int
@export var rule_handler: RuleHandler

var cells: Array[Cell]
var num_alive := 0
var turn_number := 0

func _ready() -> void:
	_setup_grid()
	_setup_cell_neighbors()
	# Give cells to rule_handler
	rule_handler.cells = cells
	rule_handler.setup()
	_reset()

# Setup grid based on row_size and column_size
func _setup_grid() -> void:
	grid_container.columns = column_size
	for i in range(row_size * column_size):
		var new_cell = CELL_SCENE.instantiate()
		grid_container.add_child(new_cell)
		cells.append(new_cell)
	#grid_container.add_theme_constant_override("h_separation", 40)
	#grid_container.add_theme_constant_override("v_separation", 40)

# Setup cell.neighbors (adjacent cells)
func _setup_cell_neighbors() -> void:
	var x := 0
	var y := 0
	for cell in cells:
		#print("%s,%s---" % [x, y])
		for i in range(x-1, x+2):
			for j in range(y-1, y+2):
				if i != x or j != y:
					if i > -1 and i < row_size and j > -1 and j < column_size:
						#print("%s,%s" % [i, j])
						cell.neighbors.append(cells[i * column_size + j])
		y += 1
		if y % column_size == 0:
			y = 0
			x += 1

# Reset game state
func _reset() -> void:
	num_alive = 0
	turn_number = 0
	for cell: Cell in cells:
		cell.state = Cell.CellState.DEAD

# Process every cell to the next state, reset if all cells are dead
func process_turn() -> void:
	turn_number += 1
	num_alive = rule_handler.process_turn()
	if num_alive == 0:
		print("All Dead Cells!")
		_reset()

# Input
var process_active := false
var process_delay := 0.25
var timer := 0.0

# Input to start processing turn
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Turn"):
		process_turn()
		process_active = true
		timer = 0.0
	elif event.is_action_released("Turn"):
		process_active = false

func _process(delta: float) -> void:
	if process_active:
		timer += delta
		if timer >= process_delay:
			timer = 0.0
			process_turn()
