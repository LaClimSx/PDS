extends Control

@onready var persons : Array = $VBoxContainer/GridContainer.get_children()


func _on_validate_button_pressed() -> void:
	var correct: bool = true
	for person: Person in persons:
		if !person.is_guess_correct():
			print("Incorrect for person:", person.name)
			correct = false
	if correct:
		print("Correct!")
	else: 
		print("Déso pas déso je te brise les os")
		
