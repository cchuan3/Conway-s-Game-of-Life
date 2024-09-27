class_name RulesContainer
extends Resource

# Basic Rules
const BASIC_RULES := {
	Cell.CellState.ALIVE: preload("res://cell_rules/rule_alive_basic.tres"),
	Cell.CellState.DEAD: preload("res://cell_rules/rule_dead_basic.tres")
}

# Custom Rules
const CUSTOM_RULES := {
	Cell.CellState.ALIVE: preload("res://cell_rules/rule_alive.tres"),
	Cell.CellState.DEAD: preload("res://cell_rules/rule_dead.tres")
}

# TODO: Change resource to take easier notation instead of exporting this bs
# <Current state><Neighbor state to check><Resulting State><Number of neighbors>
# Example: AAD0145678
# 1. Cell is alive
# 2. Check alive neighbors
# 3. If # of alive neighbors = 0, 1, 4, 5, 6, 7, or 8
#	-> cell.state = DEAD
@export var rules_notation: Array[String]

var rules_matrix := {
	Cell.CellState.ALIVE: {Cell.CellState.ALIVE: [], Cell.CellState.DEAD: []},
	Cell.CellState.DEAD: {Cell.CellState.ALIVE: [], Cell.CellState.DEAD: []}
}

func setup() -> void:
	rules_notation_to_rules_matrix()

# Fill rules to stay in the same state
# This is for convenience of creating new rules_container rulesets,
# as only changes in state need to be added to the set
func _fill_basic_rules(state: Cell.CellState, rule: CustomRule) -> void:
	for i in range(9):
		for dependency_state in range(Cell.CellState.LENGTH):
			if not rules_matrix[state][dependency_state][i]:
				rules_matrix[state][dependency_state][i] = rule.duplicate()
				#print("%s:%s" % [dependency_state, i])

# Conversion variables
const char_to_state := {
	'A': Cell.CellState.ALIVE,
	'D': Cell.CellState.DEAD
}

# Convert rules_notation to rules_matrix
func rules_notation_to_rules_matrix() -> void:
	# Clear rules matrix
	for state_base in Cell.get_cell_state_array():
		for state_neighbor in Cell.get_cell_state_array():
			rules_matrix[state_base][state_neighbor] = [null, null, null, null, null, null, null, null, null]
	_fill_basic_rules(Cell.CellState.ALIVE, BASIC_RULES[Cell.CellState.ALIVE])
	_fill_basic_rules(Cell.CellState.DEAD, BASIC_RULES[Cell.CellState.DEAD])
	# Add custom rules
	for rule_change: String in rules_notation:
		var rule_array := rule_change.split('')
		var state_base := char_to_state[rule_array[0]] as Cell.CellState
		var state_dependency := char_to_state[rule_array[1]] as Cell.CellState
		var state_result := char_to_state[rule_array[2]] as Cell.CellState
		# Remove states from rules -> only numbers left
		for i in range(3):
			rule_array.remove_at(0)
		# Insert rules
		for i_str in rule_array:
			var i = str_to_var(i_str)
			var temp = rules_matrix[state_base][state_dependency]
			temp[i] = CUSTOM_RULES[state_result].duplicate()

# Based on the cell's neighbors, find the first rule that applies
# ORDER:
# 1. First change in state
# 	a. Based on Alive neighbors
# 	b. Based on Dead neighbors
# 2. Stay the same state
# TODO: Allow different orders specified by ruleset
func get_rule(cell: Cell) -> CustomRule:
	# Get neighbor status
	var neighbors_state := {Cell.CellState.ALIVE: 0, Cell.CellState.DEAD: 0}
	for neighbor: Cell in cell.neighbors:
		neighbors_state[neighbor.state] += 1
	# Find custom rule result
	var first_basic_rule: CustomRule
	for dependency_state: Cell.CellState in range(Cell.CellState.LENGTH) as Array[Cell.CellState]:
		var neighbor_num: int = neighbors_state[dependency_state]
		var rule_to_check: CustomRule = rules_matrix[cell.state][dependency_state as Cell.CellState][neighbor_num]
		if not rule_to_check.basic_rule:
			return rule_to_check
		elif first_basic_rule == null:
			first_basic_rule = rule_to_check
			#print("Basic %s : %s" % [rule_to_check.rule_result, neighbor_num])
	# Fall back to basic rule result
	return first_basic_rule
