class_name RuleUI
extends TabContainer

const RULE_GRID_UI = preload("res://scenes/UI/rule_grid_UI.tscn")

var rules_container: RulesContainer : set = _set_rules_container
var tabs: Dictionary
var tab_ids: Dictionary
var selected_rule: CustomRule
var selected_cell: Cell

func _ready() -> void:
	var i = 0
	for state: Cell.CellState in Cell.get_cell_state_array():
		var new_rule_grid := RULE_GRID_UI.instantiate()
		new_rule_grid.main_state = state
		add_child(new_rule_grid)
		tabs[state] = new_rule_grid
		tab_ids[state] = i
		i += 1
	Events.cell_selected.connect(_on_cell_selected)
	Events.cell_deselected.connect(_on_cell_deselected)
	Events.selected_cell_changed.connect(_on_cell_selected)

# Send new/changed rules to rule_grid_ui tabs
func _set_rules_container(value: RulesContainer) -> void:
	rules_container = value
	for state: Cell.CellState in Cell.get_cell_state_array():
		tabs[state].rule_dict = rules_container.rules_matrix[state]

# Set rule as selected for highlighting
func _on_cell_selected(cell: Cell) -> void:
	if selected_rule:
		selected_rule.selected = false
	selected_cell = cell
	selected_rule = rules_container.get_rule(cell)
	selected_rule.selected = true
	current_tab = tab_ids[cell.state]

# Deselect rule
func _on_cell_deselected(cell: Cell) -> void:
	if selected_rule and selected_cell == cell:
		selected_rule.selected = false
		selected_rule = null
