extends VBoxContainer
class_name ItemizedRating

@export var item_name: String = "How familiar are you with logic games?"
@export var labels: Array[String] = ["Not at all familiar", "Slightly familiar", "Somewhat familiar", "Moderately familiar", "Extremely familiar"]

@export_group("Internal nodes")
@export var checkboxes: Array[CheckBox]
@export var checkbox_labels: Array[Label]

@onready var button_group: ButtonGroup = checkboxes[0].button_group

func _ready() -> void:
	$Item.text = item_name
	for i in range(checkbox_labels.size()):
		checkbox_labels[i].text = labels[i]


func get_selected_index() -> int:
	if button_group.get_pressed_button():
		return checkboxes.find(button_group.get_pressed_button())
	return -1
