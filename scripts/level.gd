extends Control
class_name Level

@export_range(1, 9) var liar_quantity: int = 1
@export var point_persons : Array[Person] = []
@export_multiline var teach_text : String = ""
@export_multiline var bottom_out_text : String = ""

@onready var grid_container: GridContainer = %GridContainer
@onready var persons : Array = grid_container.get_children()
@onready var stopwatch : Label = %Stopwatch
@onready var hint_text: RichTextLabel = %HintText

const TWO_BUTTON_PANEL : PackedScene = preload("res://scenes/two_button_panel.tscn")
const MERLIN_POPUP : PackedScene = preload("res://scenes/merlin_popup.tscn")


var time_passed: float = 0.0
var stopped: bool = false

var nb_tries: int = 0

func _ready() -> void:
	$DebugLabel.text = "Debug label: VERSION = " + str(Global.VERSION) + "\n" + name
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


#VALIDATION

func _on_validate_button_pressed() -> void:
	stopped = true
	var validation_panel: TwoButtonPanel = TWO_BUTTON_PANEL.instantiate()
	add_child(validation_panel)
	validation_panel.create("Are you sure?", "Yes", "No")
	validation_panel.pressed_1.connect(validate)
	validation_panel.pressed_2.connect(resume)


func validate() -> void:
	nb_tries += 1
	%RightSide.hide()
	%ValidateButton.disabled = true
	if is_correct():
		for person: Person in persons: 
			person.reveal_guilty(true)
		end_level()
	else: 
		$PanelContainer/HBoxContainer.hide()
		for person: Person in persons:
			person.reset_markers()
		var incorrect_popup : MerlinPopup = new_popup("It appears you made at least one mistake, care to try again?", 440, false)
		incorrect_popup.set_button_text("Try again")
		await incorrect_popup.pressed
		%RightSide.show()
		%ValidateButton.disabled = false
		$PanelContainer/HBoxContainer.show()
		stopped = false


func is_correct() -> bool:
	var correct: bool = true
	var idx: int = 0
	for person: Person in persons:
		if not person.is_guess_correct():
			print("Incorrect for person:", idx_to_position(idx))
			correct = false
		idx += 1
	return correct
	
	
func new_popup(text: String, separation: int = 425, disable_default: bool = true) -> MerlinPopup:
	var layer: MerlinPopup = MERLIN_POPUP.instantiate()
	layer.create(text, separation)
	add_child(layer)
	if disable_default: 
		layer.disable()
	return layer


func resume() -> void:
	stopped = false


func end_level(solved: bool = true) -> void:
	if solved:
		var end_popup : MerlinPopup = new_popup("Congrats, you found all the shapeshifters, ready for the next level?", 460, false)
		end_popup.set_button_text("Next Level")
		end_popup.pressed.connect(Global.next_level)
	else:
		print("given up huh ?")
		Global.next_level()


#HINTS

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
	for i: int in range(persons.size()):
		var person: Person = persons[i]
		person.show_index(idx_to_position(i))
	%TopSpacing.size_flags_vertical = SIZE_SHRINK_BEGIN
	edit_hint_text(bottom_out_text)


func edit_hint_text(txt: String, additive: bool = true) -> void:
	hint_text.text = hint_text.text + txt + "\n \n" if additive else txt


#HELPER FUNCS

func idx_to_position(idx: int, nb_columns: int = grid_container.columns) -> String:
	var column_str : String = String.chr(65 + (idx % nb_columns))
	@warning_ignore("integer_division")
	return column_str + str((idx / nb_columns) + 1)

#God mode to go to next level when clicking on debug label
func _on_debug_label_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			accept_event()
			Global.next_level()
