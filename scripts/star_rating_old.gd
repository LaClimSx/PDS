extends HBoxContainer

signal rating_changed(value: float)

@export var star_empty : Texture2D = preload("res://assets/art/rating/starEmpty.png")
@export var star_half : Texture2D = preload("res://assets/art/rating/starHalf.png")
@export var star_full : Texture2D = preload("res://assets/art/rating/starFull.png")

@export var rating: float = 0.0

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	_update_stars()

func _update_stars() -> void:
	var stars := get_children()
	for i in stars.size():
		var fill := rating - i
		if fill >= 1.0:
			stars[i].texture = star_full
		elif fill >= 0.5:
			stars[i].texture = star_half
		else:
			stars[i].texture = star_empty


func _gui_input(event: InputEvent) -> void:
	var is_click: bool = event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT
	var is_drag: bool = event is InputEventMouseMotion and event.button_mask == MOUSE_BUTTON_MASK_LEFT
	
	if is_click or is_drag :
		var x: float = clamp(event.position.x, 0.0, size.x - 1.0)
		for i in get_child_count():
			var star: Control = get_child(i)
			if event.position.x < star.position.x + star.size.x:
				var half: float = event.position.x - star.position.x < star.size.x / 2.0
				rating = i + (0.5 if half else 1.0)
				rating_changed.emit(rating)
				_update_stars()
				return

func _on_rating_changed(value: float) -> void:
	rating = value
