class_name RuleGridUI
extends GridContainer

# Format:
# 1. Entire dict is for one CellState, determines which states to go to
# 2. Each key is for each CellState (including ^ one)
# 3. Each entry is an array of length 9, representing 0-8 neighbors of the key state
# 		The arrays contain CustomRule entries, which determine what the next state should be
# 		Null array entries mean that the state should stay the same as (1)
# This corresponds to one entry of a RulesContainer
var rule_dict: Dictionary : set = _set_rule_dict
var element_dict: Dictionary
# CellState that the rules affect (the "from" state)
var main_state: Cell.CellState : set = _set_main_state

func _ready() -> void:
	# Add panels to match rule_dict
	var i = 0
	var panel_children = find_children("*", "RuleGridElementUI") as Array[RuleGridElementUI]
	for state: Cell.CellState in Cell.get_cell_state_array():
		element_dict[state] = []
		for _i in range(9):
			element_dict[state].append(panel_children[i])
			i += 1

# change visuals to match rules
func _set_rule_dict(value: Dictionary) -> void:
	# TODO: Error check
	rule_dict = value
	# Change panel visuals
	for state: Cell.CellState in Cell.get_cell_state_array():
		for i in range(9):
			var element: RuleGridElementUI = element_dict[state][i]
			var new_state_rule = rule_dict[state][i] as CustomRule
			element.custom_rule = new_state_rule

# Change name to match main state (for tab container)
func _set_main_state(value: Cell.CellState) -> void:
	main_state = value
	name = ' ' + Cell.CellState.find_key(main_state) + ' '
