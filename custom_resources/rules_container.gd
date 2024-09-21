class_name RulesContainer
extends Resource

const RULE_STAY_ALIVE = preload("res://cell_rules/AA.tres")
const RULE_STAY_DEAD = preload("res://cell_rules/DD.tres")

@export var rules_matrix := {
	Cell.CellState.ALIVE: {Cell.CellState.ALIVE: [], Cell.CellState.DEAD: []},
	Cell.CellState.DEAD: {Cell.CellState.ALIVE: [], Cell.CellState.DEAD: []}
}

func setup() -> void:
	_fill_basic_rules(Cell.CellState.ALIVE, RULE_STAY_ALIVE)
	_fill_basic_rules(Cell.CellState.DEAD, RULE_STAY_DEAD)

# Fill rules to stay in the same state
# This is for convenience of creating new rules_container rulesets,
# as only changes in state need to be added to the set
func _fill_basic_rules(state: Cell.CellState, rule: CustomRule) -> void:
	for i in range(9):
		for dependency_state in range(Cell.CellState.LENGTH):
			if not rules_matrix[state][dependency_state][i]:
				rules_matrix[state][dependency_state][i] = rule
				#print("%s:%s" % [dependency_state, i])

# Based on the cell's neighbors, find the first rule that applies
# ORDER:
# First change in state
# - Based on Alive neighbors
# - Based on Dead neighbors
# Stay the same state
func get_rule_result(cell: Cell) -> Cell.CellState:
	# Get neighbor status
	var neighbors_state := {Cell.CellState.ALIVE: 0, Cell.CellState.DEAD: 0}
	for neighbor: Cell in cell.neighbors:
		neighbors_state[neighbor.state] += 1
	# Find custom rule result
	for dependency_state: Cell.CellState in range(Cell.CellState.LENGTH) as Array[Cell.CellState]:
		var neighbor_num: int = neighbors_state[dependency_state]
		var rule_to_check: CustomRule = rules_matrix[cell.state][dependency_state as Cell.CellState][neighbor_num]
		if not rule_to_check.basic_rule:
			return rule_to_check.rule_result
	# Fall back to basic rule result
	match cell.state:
		Cell.CellState.ALIVE:
			return RULE_STAY_ALIVE.rule_result
		Cell.CellState.DEAD:
			return RULE_STAY_DEAD.rule_result
		_:
			print("Error: Unknown CellState")
			return RULE_STAY_ALIVE.rule_result
