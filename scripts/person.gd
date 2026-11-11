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
@onready var label: Label = %Label
@onready var texture_button: TextureButton = %TextureButton

@onready var red_texture : CompressedTexture2D = preload("res://assets/art/cards/redCard.png")
@onready var yellow_texture : CompressedTexture2D = preload("res://assets/art/cards/yellowCard.png")
@onready var blue_texture : CompressedTexture2D = preload("res://assets/art/cards/blueCard.png")

func init_person() -> void:
	match color:
		ColorGroup.RED:
			texture_rect.texture = red_texture
		ColorGroup.GREEN:
			texture_rect.texture = yellow_texture
		ColorGroup.BLUE:
			texture_rect.texture = blue_texture
	label.text = text

func _ready() -> void:
	init_person()

func is_guess_correct() -> bool:
	return (texture_button.button_pressed and is_liar or not texture_button.button_pressed and not is_liar)
