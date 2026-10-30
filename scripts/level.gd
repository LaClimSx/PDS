extends Control

@onready var persons : Array = %GridContainer.get_children()
@onready var stopwatch : Label = %Stopwatch

var time_passed: float = 0.0

func _process(delta: float) -> void:
	time_passed += delta
	var minutes : int = int(time_passed / 60.0)
	var min_string: String = "0" + str(minutes) if minutes < 10 else str(minutes)
	var seconds : float = time_passed - 60 * minutes
	var sec_string: String = "0" + str(seconds).pad_decimals(1) if seconds < 10 else str(seconds).pad_decimals(1)
	stopwatch.text = min_string + ":" + sec_string + "s"


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
		
