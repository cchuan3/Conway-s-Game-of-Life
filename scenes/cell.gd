class_name Cell
extends Control

@onready var color_rect: ColorRect = $ColorRect

var neighbors: Array[Cell]
var alive: bool : set = _set_alive
var neighbors_alive: int

func _ready() -> void:
	alive = false

func _set_alive(value: bool) -> void:
	alive = value
	if alive:
		color_rect.self_modulate = Color(0, 0, 0)
	else:
		color_rect.self_modulate = Color(1, 1, 1)

func check_neighbors() -> void:
	neighbors_alive = 0
	for neighbor: Cell in neighbors:
		if neighbor.alive:
			neighbors_alive += 1
	print(neighbors_alive)

func apply_rule() -> void:
	if alive:
		if neighbors_alive < 2 or neighbors_alive > 3:
			alive = false
	else:
		if neighbors_alive == 3:
			alive = true

func _on_color_rect_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("L_Mouse"):
		alive = !alive
