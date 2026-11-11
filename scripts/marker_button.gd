extends TextureButton
class_name MarkerButton

@export_group("Enum Textures")
@export var default_texture: CompressedTexture2D
@export var yellow_texture: CompressedTexture2D
@export var blue_texture: CompressedTexture2D
@export var red_texture: CompressedTexture2D
@export_group("")

@onready var textures : Array[CompressedTexture2D] = [default_texture, yellow_texture, blue_texture, red_texture]
var idx : int = 0

func _on_pressed() -> void:
	idx = (idx + 1) % textures.size()
	texture_normal = textures[idx]
