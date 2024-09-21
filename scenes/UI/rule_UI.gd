class_name RuleUI
extends TabContainer

const RULE_GRID_UI = preload("res://scenes/UI/rule_grid_UI.tscn")

var rules_container: RulesContainer : set = _set_rules_container
var tabs: Dictionary

func _ready() -> void:
	var state := Cell.CellState.ALIVE
	while state != Cell.CellState.LENGTH:
		var new_rule_grid := RULE_GRID_UI.instantiate()
		new_rule_grid.main_state = state
		add_child(new_rule_grid)
		tabs[state] = new_rule_grid
		state = state + 1 as Cell.CellState
	rules_container = preload("res://cell_rules/Conway's_original.tres")

# Send new/changed rules to rule_grid_ui tabs
func _set_rules_container(value: RulesContainer) -> void:
	rules_container = value
	var state := Cell.CellState.ALIVE
	while state != Cell.CellState.LENGTH:
		tabs[state].rule_dict = rules_container.rules_matrix[state]
		state = state + 1 as Cell.CellState
