extends PanelContainer 
class_name Person

enum ColorGroup {
	RED,
	GREEN,
	BLUE,
}


@export var color: ColorGroup
@export var is_liar: bool = false
@export var text : String

@onready var texture_rect : TextureRect = %TextureRect
@onready var marker_button : MarkerButton = %MarkerButton

@onready var red_texture : CompressedTexture2D = preload("res://assets/RedCard.png")
@onready var yellow_texture : CompressedTexture2D = preload("res://assets/YellowCard.png")
@onready var blue_texture : CompressedTexture2D = preload("res://assets/BlueCard.png")

func init_person() -> void:
	match color:
		ColorGroup.RED:
			texture_rect.texture = red_texture
		ColorGroup.GREEN:
			texture_rect.texture = yellow_texture
		ColorGroup.BLUE:
			texture_rect.texture = blue_texture
	$VBoxContainer/Label.text = text

func _ready() -> void:
	init_person()

func is_guess_correct() -> bool:
	return (marker_button.idx == marker_button.LIAR_IDX and is_liar) or (marker_button.idx != marker_button.LIAR_IDX and not is_liar)
