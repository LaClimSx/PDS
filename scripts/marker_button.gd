extends TextureButton
class_name MarkerButton

@export_group("Enum Textures")
@export var default_texture: CompressedTexture2D
@export var first_texture: CompressedTexture2D
@export var second_texture: CompressedTexture2D
@export var third_texture: CompressedTexture2D
@export_group("")

@onready var textures : Array[CompressedTexture2D] = [default_texture, first_texture, second_texture, third_texture]
var idx : int = 0

func _on_pressed() -> void:
	idx = (idx + 1) % textures.size()
	texture_normal = textures[idx]


func reset() -> void:
	idx = 0
	texture_normal = textures[idx]


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			accept_event()
			reset()
