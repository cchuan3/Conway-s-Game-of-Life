class_name RuleGridElementUI
extends Panel

const STYLEBOX_CELL_ALIVE = preload("res://scenes/stylebox_cell_alive.tres")
const STYLEBOX_CELL_DEAD = preload("res://scenes/stylebox_cell_dead.tres")
const STYLEBOX_DICT := {
	Cell.CellState.ALIVE: STYLEBOX_CELL_ALIVE,
	Cell.CellState.DEAD: STYLEBOX_CELL_DEAD
}

@onready var highlighted: Panel = $Highlighted

var custom_rule: CustomRule : set = _set_custom_rule

func _set_custom_rule(value: CustomRule) -> void:
	custom_rule = value
	custom_rule.changed.connect(_toggle_highlight)
	add_theme_stylebox_override("panel", STYLEBOX_DICT[custom_rule.rule_result])

func _toggle_highlight() -> void:
	if custom_rule.selected:
		highlighted.show()
	else:
		highlighted.hide()
