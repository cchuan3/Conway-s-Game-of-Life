class_name RuleUI
extends TabContainer

const RULE_GRID_UI = preload("res://scenes/UI/rule_grid_UI.tscn")

var rules_container: RulesContainer : set = _set_rules_container
var tabs: Dictionary

func _ready() -> void:
	for state: Cell.CellState in Cell.get_cell_state_array():
		var new_rule_grid := RULE_GRID_UI.instantiate()
		new_rule_grid.main_state = state
		add_child(new_rule_grid)
		tabs[state] = new_rule_grid

# Send new/changed rules to rule_grid_ui tabs
func _set_rules_container(value: RulesContainer) -> void:
	rules_container = value
	for state: Cell.CellState in Cell.get_cell_state_array():
		tabs[state].rule_dict = rules_container.rules_matrix[state]
