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
const LIAR_IDX = 1
#TODO: Changer le fonctionnement de la validation avec les nouveaux boutons

func _on_pressed() -> void:
	idx = (idx + 1) % 4
	texture_normal = textures[idx]
