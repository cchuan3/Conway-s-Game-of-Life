class_name RuleHandler
extends Node

var rules_container: RulesContainer

var cells: Array[Cell]
var num_cells: int

func setup() -> void:
	num_cells = cells.size()

# Process every cell to the next state, return number of non-dead cells
func process_turn() -> int:
	var num_alive = num_cells
	var cell_results: Array[Cell.CellState] = []
	for cell: Cell in cells:
		cell_results.append(rules_container.get_rule(cell).rule_result)
	for i in range(num_cells):
		cells[i].state = cell_results[i]
		if cells[i].state == Cell.CellState.DEAD:
			num_alive -= 1
	return num_alive
