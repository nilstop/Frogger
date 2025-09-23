extends TileMapLayer

func _ready() -> void:
	await get_tree().process_frame
	print(Global.driveway_tiles)
	BetterTerrain.update_terrain_area(self, Rect2i(Vector2i(-Global.camera_x_divide * Global.cell_size,720), Vector2i(get_viewport_rect().size.x + Global.camera_x_divide * Global.cell_size * 2, -10)), true)
