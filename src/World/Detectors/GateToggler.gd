extends Area2D

# choose color
export var color: String
export var flipped = false
onready var gates: Array = get_tree().get_nodes_in_group(color)


func _on_GateToggler_body_entered(_body: Node) -> void:
	for gate in gates:
		# iterate over each tile in the tilemap and simply reverse them ( 0 <-> 1)
		for tile in gate.get_used_cells():
			var cell = gate.is_cell_transposed(tile.x,tile.y)
			gate.set_cellv(tile, int(not bool(gate.get_cellv(tile))),cell,false,cell)
