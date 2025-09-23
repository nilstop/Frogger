extends TileMapLayer

func _ready() -> void:
	await get_tree().process_frame
	print(Global.driveway_tiles)
	#FIX THIS
	#BetterTerrain.update_terrain_cells(self,)
