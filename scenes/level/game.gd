extends Node2D

@onready var player = $Objects/Player
var plant_scene: PackedScene = preload("res://scenes/level/plant.tscn") 

func _on_player_tool_use(tool, pos):
	var grid_pos = Vector2i(pos.x / 16, pos.y / 16)
	if tool == player.Tools.HOE:
		var cell = $Layers/GrassLayer.get_cell_tile_data(0, grid_pos, false) as TileData
		if cell and cell.get_custom_data('useable'):
			$Layers/SoilLayer.set_cells_terrain_connect(0, [grid_pos], 0, 0, true)
	
	if tool == player.Tools.WATER:
		# 有soil瓦片才執行water動作
		if $Layers/SoilLayer.get_cell_tile_data(0, grid_pos, false):
			$Layers/SoilWaterLayer.set_cell(0, grid_pos, 0, Vector2i(randi_range(0, 2), 0))

	if tool == player.Tools.AXE:
		for node in get_tree().get_nodes_in_group('Trees'):
			var tree := node as FarmTree
			if tree and tree.global_position.distance_to(pos) < 10:
				tree.hit()
				print('use axe')


func _on_player_seed_use(seed_enum, pos):
	var grid_pos = Vector2i(pos.x / 16, pos.y / 16)
	var cell = $Layers/SoilLayer.get_cell_tile_data(0, grid_pos, false) as TileData
	if cell:
		var plant_pos = Vector2(grid_pos.x * 16 + 8, grid_pos.y * 16 - 4)
		var plant = plant_scene.instantiate() as StaticBody2D
		plant.setup(seed_enum, grid_pos)
		$Objects.add_child(plant)
		plant.position = plant_pos
