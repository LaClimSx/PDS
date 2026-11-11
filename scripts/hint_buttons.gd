extends HBoxContainer
class_name HintButtonContainer

signal pressed(hint: int)

@onready var first_button: Button = $Button1
@onready var buttons : Array[Button] = [first_button]

func create(VERSION: Global.Version) -> void :
	first_button.pressed.connect(func() -> void : on_button_pressed(0))
	match VERSION:
		Global.Version.NO_HELP:
			first_button.text = "Impossible"
			print("Shouldn't even be possible")
			return
		Global.Version.BOTTOM_OUT:
			first_button.text = "Show solution"
			
		#The last 2 cases, ITS and ALL are very similar
		_:
			var nb_buttons : int = 1 if VERSION == Global.Version.ITS else 2
			first_button.text = "1"
			for i in range(nb_buttons):
				var new_button: Button = first_button.duplicate()
				add_child(new_button)
				new_button.disabled = true
				buttons.append(new_button)
				new_button.text = str(i + 2)
				new_button.pressed.connect(func() -> void : on_button_pressed(i + 1))


func on_button_pressed(idx: int) -> void:
	var button: Button = buttons[idx]
	button.disabled = true
	#If button is not the last, enable next one
	if idx < buttons.size() - 1 :
		buttons[idx + 1].disabled = false
	pressed.emit(idx)
