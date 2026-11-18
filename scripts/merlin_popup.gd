extends PanelContainer
class_name MerlinPopup

signal pressed

func create(text: String, spacing: int = 425) -> void:
	%Label.text = text
	$HBoxContainer.add_theme_constant_override("separation", spacing)


func align_bottom() -> void:
	$HBoxContainer/MarginContainer/VBoxContainer.size_flags_vertical = SIZE_SHRINK_END


func enable() -> void:
	%NextButton.disabled = false


func disable() -> void:
	%NextButton.disabled = true


func set_label_text(txt: String) -> void:
	%Label.text = txt


func set_button_text(txt: String) -> void:
	%NextButton.text = txt


func _on_next_button_pressed() -> void:
	pressed.emit()
	queue_free()
