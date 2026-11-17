extends Control

const HIGHLIGHT_FRAME = preload("res://scenes/highlight_frame.tscn")
const LVL1 = preload("res://scenes/levels/level_1.tscn")

var highlight_frame: Panel    
var highlight_target: Control

func _ready() -> void:
	$TutoLevel/PanelContainer/HBoxContainer/MarginContainer/Stopwatch.hide()
	$Start.show()
	$GiveUp.hide()
	$Markers.hide()
	$Flags.hide()	
	$Validate.hide()
	$Hints.hide()
	
func _process(_delta: float) -> void:
	if highlight_frame and is_instance_valid(highlight_target):
		_update_frame()

func _on_start_pressed() -> void:
	$Start.hide()
	$TutoLevel.show()
	$TutoLevel/PanelContainer/HBoxContainer.hide()
	$GiveUp/HBoxContainer/MarginContainer/VBoxContainer/Ok.disabled = true
	$GiveUp.show()
	var give_up : TextureButton = $TutoLevel/PanelContainer/MarginContainer/GiveUpButton
	highlight(give_up)
	await give_up.pressed
	unhighlight()
	$GiveUp/HBoxContainer/MarginContainer/VBoxContainer/Ok.disabled = false

func _on_ok_pressed() -> void:
	$GiveUp.hide()
	$TutoLevel/PanelContainer/HBoxContainer.show()
	$TutoLevel/PanelContainer/HBoxContainer/MarginContainer2/VBoxContainer/HintButton.hide()
	$Markers.show()
	$Markers/HBoxContainer/MarginContainer/VBoxContainer/OkMarker.disabled = true
	var markers : MarkerButton = $TutoLevel/PanelContainer/HBoxContainer/VBoxContainer/GridContainer/Person/MarginContainer/HBoxContainer/MarkerButton
	highlight(markers)
	await markers.pressed
	await markers.pressed
	await markers.pressed
	await markers.pressed
	unhighlight()	
	$Markers/HBoxContainer/MarginContainer/VBoxContainer/OkMarker.disabled = false
	
	
func _on_ok_marker_pressed() -> void:
	$Markers.hide()
	$Flags/HBoxContainer/MarginContainer/VBoxContainer/OkLiar.disabled = true
	$Flags.show()
	var liar : TextureButton = $TutoLevel/PanelContainer/HBoxContainer/VBoxContainer/GridContainer/Person/MarginContainer/HBoxContainer/TextureButton
	highlight(liar)
	await liar.pressed
	unhighlight()
	$Flags/HBoxContainer/MarginContainer/VBoxContainer/OkLiar.disabled = false
	
func _on_ok_liar_pressed() -> void:
	$Flags.hide()
	$Validate/HBoxContainer/MarginContainer/VBoxContainer/OkValidate.disabled = true
	$Validate.show()
	var validate : Button = $TutoLevel/PanelContainer/HBoxContainer/VBoxContainer/ValidateButton
	highlight(validate)
	await validate.pressed
	unhighlight()
	$Validate/HBoxContainer/MarginContainer/VBoxContainer/OkValidate.disabled = false


func _on_ok_validate_pressed() -> void:
	#Check if there is hints if there is not
	$TutoLevel/PanelContainer/HBoxContainer/MarginContainer2/VBoxContainer/HintButton.show()
	$Validate.hide()	
	var label : Label = $Hints/HBoxContainer/MarginContainer/VBoxContainer/Label
	if (Global.VERSION == Global.Version.NO_HELP):
		label.text = "You are now ready for your first level !"
		$Hints.show()
		
	else:	
		$Hints/HBoxContainer/MarginContainer/VBoxContainer/OkHints.disabled = true
		label.text = "And don't hesitate to ask me for bit of help at anytime !"
		$Hints.show()
		var help : TextureButton = $TutoLevel/PanelContainer/HBoxContainer/MarginContainer2/VBoxContainer/HintButton
		highlight(help)
		await help.pressed
		unhighlight()
		label.text = "You are now ready for your first level !"
		$Hints/HBoxContainer/MarginContainer/VBoxContainer/OkHints.disabled = false
		

func _on_ok_hints_pressed() -> void:
	get_tree().change_scene_to_packed(LVL1)
	
	
func highlight(target: Control) -> void:
	unhighlight()
	await get_tree().process_frame   # let containers finish sizing
	highlight_target = target

	highlight_frame =  HIGHLIGHT_FRAME.instantiate()
	add_child(highlight_frame)   # last child = drawn on top of everything
	_update_frame()

func unhighlight() -> void:
	if highlight_frame:
		highlight_frame.queue_free()
	highlight_frame = null
	highlight_target = null
	
func _update_frame() -> void:
	var pad := 6.0
	highlight_frame.global_position = highlight_target.global_position - Vector2(pad, pad)
	highlight_frame.size = highlight_target.size + Vector2(pad, pad) * 2
