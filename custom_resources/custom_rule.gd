class_name CustomRule
extends Resource

@export var name: String
@export var basic_rule := true
@export var rule_result: Cell.CellState

var selected := false : set = _set_selected

func _set_selected(value: bool) -> void:
	selected = value
	emit_changed()
