extends Node2D

@onready var map: TileMapLayer = get_tree().get_first_node_in_group("tilemap")


@export var tilemap_atlas_coord : Vector2

var cell : int

func _ready() -> void:
	
	cell = get_parent().cell
	get_parent().global_position = Vector2(Global.screen_rect.x/2.0, Global.screen_rect.y - cell * Global.cell_size + Global.cell_size / 2.0)
	set_map(30)

func set_map(width):
	
	for ccell in width:
		#tile if driveway
		map.set_cell(map.local_to_map(global_position + Vector2(ccell * Global.cell_size,0)), 0, tilemap_atlas_coord)
		map.set_cell(map.local_to_map(global_position - Vector2(ccell * Global.cell_size,0)), 0, tilemap_atlas_coord)
		BetterTerrain.update_terrain_cell(map,map.local_to_map(global_position + Vector2(ccell * Global.cell_size,0)))
		BetterTerrain.update_terrain_cell(map,map.local_to_map(global_position - Vector2(ccell * Global.cell_size,0)))
		if tilemap_atlas_coord.y == 2.0:
			Global.driveway_tiles.append(global_position + Vector2(ccell * Global.cell_size,0))
			Global.driveway_tiles.append(global_position - Vector2(ccell * Global.cell_size,0))
