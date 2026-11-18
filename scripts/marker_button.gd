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
