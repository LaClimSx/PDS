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
@onready var info_label: Label = %Info
@onready var bookmark_button: TextureButton = %BookmarkButton

@onready var red_texture : CompressedTexture2D = preload("res://assets/art/cards/redCard.png")
@onready var yellow_texture : CompressedTexture2D = preload("res://assets/art/cards/yellowCard.png")
@onready var blue_texture : CompressedTexture2D = preload("res://assets/art/cards/blueCard.png")

@onready var red_liar_texture : CompressedTexture2D = preload("res://assets/art/cards/redCardLiar.png")
@onready var yellow_liar_texture : CompressedTexture2D = preload("res://assets/art/cards/yellowCardLiar.png")
@onready var blue_liar_texture : CompressedTexture2D = preload("res://assets/art/cards/blueCardLiar.png")

@onready var highlight_stylebox : StyleBoxFlat = preload("res://assets/highlight_stylebox.tres")
@onready var liar_stylebox : StyleBoxFlat = preload("res://assets/liar_stylebox.tres")
@onready var innocent_stylebox : StyleBoxFlat = preload("res://assets/innocent_stylebox.tres")


func init_person() -> void:
	match color:
		ColorGroup.RED:
			texture_rect.texture = red_texture
		ColorGroup.GREEN:
			texture_rect.texture = yellow_texture
		ColorGroup.BLUE:
			texture_rect.texture = blue_texture
	info_label.text = text

func _ready() -> void:
	%IndexLabel.visible = false
	init_person()

func is_guess_correct() -> bool:
	return (bookmark_button.button_pressed and is_liar or not bookmark_button.button_pressed and not is_liar)

func highlight() -> void:
	add_theme_stylebox_override("panel", highlight_stylebox)

func show_index(idx: String) -> void:
	%IndexLabel.text = idx
	%IndexLabel.visible = true

func reveal_guilty(correct_guess: bool) -> void:
	if not correct_guess:
		add_theme_stylebox_override("panel", liar_stylebox)
	else:
		add_theme_stylebox_override("panel", innocent_stylebox)
	if is_liar:
		match color:
			ColorGroup.RED:
				texture_rect.texture = red_liar_texture
			ColorGroup.GREEN:
				texture_rect.texture = yellow_liar_texture
			ColorGroup.BLUE:
				texture_rect.texture = blue_liar_texture
