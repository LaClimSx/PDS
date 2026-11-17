extends MarginContainer
class_name TwoButtonPanel

@export var text: String = "Are you sure?"
@export var button1_text : String = "Yes"
@export var button2_text : String = "No"

signal pressed_1
signal pressed_2

func create(txt: String = text, btn1_text: String = button1_text, btn2_text : String = button2_text) -> void:
	$PanelContainer/MarginContainer/VBoxContainer/Label.text = txt
	$PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Button1.text = btn1_text
	$PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Button2.text = btn2_text


func _on_button_1_pressed() -> void:
	pressed_1.emit()
	queue_free()


func _on_button_2_pressed() -> void:
	pressed_2.emit()
	queue_free()
