extends Node


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
