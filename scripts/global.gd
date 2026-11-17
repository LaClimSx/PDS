extends Node

const NB_OF_LEVELS: int = 10
var current_level: int = 0

enum Version {
	NO_HELP,
	ITS,
	BOTTOM_OUT,
	ALL
}

var VERSION: Version
#V1 : No help, V2: Point and teach, V3: Bottom-out, V4: Point, teach, bottom-out
@onready var rng : RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	VERSION = rng.randi_range(0, 3) as Version

func next_level() -> void:
	if current_level < NB_OF_LEVELS:
		current_level += 1
		var path: String = "res://scenes/levels/level_" + str(current_level) + ".tscn"
		get_tree().change_scene_to_file(path)
