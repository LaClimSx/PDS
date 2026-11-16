extends Control
class_name Level

@export_range(1, 9) var liar_quantity: int = 1
@export var point_persons : Array[Person] = []
@export var teach_text : String = ""
@export var bottom_out_text : String = ""

@onready var persons : Array = %GridContainer.get_children()
@onready var stopwatch : Label = %Stopwatch
@onready var hint_text: RichTextLabel = %HintText

var time_passed: float = 0.0
var stopped: bool = false

func _ready() -> void:
	$DebugLabel.text = "Debug label: VERSION = " + str(Global.VERSION)
	%LiarLabel.text = "Find the 1 liar" if liar_quantity == 1 else "Find the " + str(liar_quantity) + " liars" 
	%HintButtonContainer.visible = false
	%HintButtonContainer.create(Global.VERSION)
	if Global.VERSION == Global.Version.NO_HELP:
		%HintButton.visible = false
	edit_hint_text("", false)
	stopped = false


func _process(delta: float) -> void:
	if !stopped:
		time_passed += delta
		var minutes : int = int(time_passed / 60.0)
		var min_string: String = "0" + str(minutes) if minutes < 10 else str(minutes)
		var seconds : float = time_passed - 60 * minutes
		var sec_string: String = "0" + str(seconds).pad_decimals(1) if seconds < 10 else str(seconds).pad_decimals(1)
		stopwatch.text = min_string + ":" + sec_string + "s"


func _on_validate_button_pressed() -> void:
	stopped = true
	%HintButton.visible = false
	%HintButtonContainer.visible = false
	var correct: bool = true
	var idx: int = 0
	for person: Person in persons:
		if  not person.is_guess_correct():
			person.reveal_guilty(false)
			print("Incorrect for person:", idx_to_position(idx, %GridContainer.columns))
			correct = false
		else:
			person.reveal_guilty(true)
		idx += 1
	if correct:
		print("Correct!")
	else: 
		print("You made at least one mistake")


func _on_hint_button_pressed() -> void:
	%HintButton.visible = false
	%HintButtonContainer.visible = true

func asked_for_hint(hint: int) -> void:
	match Global.VERSION:
		Global.Version.NO_HELP:
			print("Impossible")
			return
		Global.Version.ITS:
			match hint:
				1: point_hint()
				2: teach_hint()
		Global.Version.BOTTOM_OUT:
			assert(hint == 1)
			bottom_out_hint()
		Global.Version.ALL:
			match hint:
				1: point_hint()
				2: teach_hint()
				3: bottom_out_hint()


func point_hint() -> void:
	for p: Person in point_persons:
		p.highlight()

func teach_hint() -> void:
	edit_hint_text(teach_text)


func bottom_out_hint() -> void:
	edit_hint_text(bottom_out_text)


func edit_hint_text(txt: String, additive: bool = true) -> void:
	hint_text.text = hint_text.text + txt + "\n \n" if additive else txt


static func idx_to_position(idx: int, nb_columns: int) -> String:
	var column_str : String = String.chr(65 + (idx % nb_columns))
	@warning_ignore("integer_division")
	return column_str + str((idx / nb_columns) + 1)
