extends Node2D

const CELL_SCENE := preload("res://scenes/cell.tscn")

@onready var grid: HBoxContainer = $Grid

@export_range(1,100) var column_size: int
@export_range(1,100) var row_size: int

var cells: Array[Cell]
var num_alive := 0
var turn_number := 0

func _ready() -> void:
	if not grid.is_node_ready():
		await grid.ready
	
	for i in range(row_size):
		var new_column = VBoxContainer.new()
		new_column.name = "Column%s" % i
		new_column.add_theme_constant_override("Separation", 40)
		grid.add_child(new_column)
		for j in range(column_size):
			var new_cell = CELL_SCENE.instantiate()
			new_column.add_child(new_cell)
			cells.append(new_cell)
	
	var x := 0
	var y := 0
	for cell in cells:
		print("%s,%s---" % [x, y])
		for i in range(x-1, x+2):
			for j in range(y-1, y+2):
				if i != x or j != y:
					if i > -1 and i < row_size and j > -1 and j < column_size:
						print("%s,%s" % [i, j])
						cell.neighbors.append(cells[i * column_size + j])
		y += 1
		if y % column_size == 0:
			y = 0
			x += 1
	
	#var rows := grid.get_children()
	#for row: Node in rows:
		#for cell: Cell in row.get_children():
			#cells.append(cell)
			#for i in range(x-1, x+2):
				#for j in range(y-1, y+2):
					#if i >= 0 and i < column_size and j >= 0 and j < row_size:
						#cell.neighbors.append(rows[j].get_children()[i])
					#y += 1
				#x += 1
	
	_reset()

func _reset() -> void:
	num_alive = 0
	turn_number = 0
	for cell: Cell in cells:
		cell.alive = false

func process_turn() -> void:
	turn_number += 1
	num_alive = 0
	for cell: Cell in cells:
		cell.check_neighbors()
	for cell: Cell in cells:
		cell.apply_rule()
		if cell.alive:
			num_alive += 1

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Turn"):
		process_turn()
