class_name RuleGridUI
extends GridContainer

const STYLEBOX_CELL_ALIVE = preload("res://scenes/stylebox_cell_alive.tres")
const STYLEBOX_CELL_DEAD = preload("res://scenes/stylebox_cell_dead.tres")

# Format:
# 1. Entire dict is for one CellState, determines which states to go to
# 2. Each key is for each CellState (including ^ one)
# 3. Each entry is an array of length 9, representing 0-8 neighbors of the key state
# 		The arrays contain CustomRule entries, which determine what the next state should be
# 		Null array entries mean that the state should stay the same as (1)
# This corresponds to one entry of a RulesContainer
var rule_dict: Dictionary : set = _set_rule_dict
var panel_dict: Dictionary
var stylebox_dict: Dictionary
# CellState that the rules affect (the "from" state)
var main_state: Cell.CellState : set = _set_main_state

func _ready() -> void:
	# Add panels to match rule_dict
	var i = 0
	var panel_children = find_children("*", "Panel") as Array[Panel]
	for state: Cell.CellState in Cell.get_cell_state_array():
		panel_dict[state] = []
		for _i in range(9):
			panel_dict[state].append(panel_children[i])
			i += 1
	# Setup stylebox dict
	stylebox_dict[Cell.CellState.ALIVE] = STYLEBOX_CELL_ALIVE
	stylebox_dict[Cell.CellState.DEAD] = STYLEBOX_CELL_DEAD
	
	#main_state = Cell.CellState.ALIVE
	#var temp_rules = preload("res://cell_rules/Conway's_original.tres")
	#rule_dict = temp_rules.rules_matrix[Cell.CellState.ALIVE]

# change visuals to match rules
func _set_rule_dict(value: Dictionary) -> void:
	# TODO: Error check
	rule_dict = value
	# Change panel visuals
	for state: Cell.CellState in Cell.get_cell_state_array():
		for i in range(9):
			var panel: Panel = panel_dict[state][i]
			var new_state_rule = rule_dict[state][i] as CustomRule
			var new_state: Cell.CellState
			if new_state_rule == null:
				new_state = main_state
			else:
				new_state = new_state_rule.rule_result
			panel.add_theme_stylebox_override("panel", stylebox_dict[new_state])

# Change name to match main state (for tab container)
func _set_main_state(value: Cell.CellState) -> void:
	main_state = value
	name = ' ' + Cell.CellState.find_key(main_state) + ' '
