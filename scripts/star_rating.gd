extends VBoxContainer

@export var item_text: String = ""

@onready var stars_progress_bar: TextureProgressBar = $StarsProgressBar

var value: float = -1

func _ready() -> void:
	$Item.text = item_text

func _on_slider_value_changed(s_value: float) -> void:
	stars_progress_bar.value = s_value
	value = s_value
