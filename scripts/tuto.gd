extends Level

const HIGHLIGHT_FRAME : PackedScene = preload("res://scenes/highlight_frame.tscn")

var highlight_frame: Panel    
var highlight_target: Control

@onready var actual_level: HBoxContainer = $PanelContainer/HBoxContainer
@onready var give_up_button : TextureButton = %GiveUpButton
@onready var marker_button: TextureButton = $PanelContainer/HBoxContainer/VBoxContainer/GridContainer/Person/MarginContainer/HBoxContainer/MarkerButton
@onready var bookmark_button: TextureButton = $PanelContainer/HBoxContainer/VBoxContainer/GridContainer/Person/MarginContainer/HBoxContainer/BookmarkButton
@onready var validate_button: Button = %ValidateButton
@onready var hint_button : TextureButton = %HintButton

func _ready() -> void:
	super()
	$Start.show()
	$Hint1.hide()

func _process(_delta: float) -> void:
	if highlight_frame and is_instance_valid(highlight_target):
		_update_frame()

#How to give up
func _on_start_button_pressed() -> void:
	$Start.queue_free()
	actual_level.hide()
	var give_up_layer : MerlinPopup = new_popup("First, know you can give up a level anytime by clicking on the \"Give up\" button.",
	0, false)
	highlight(give_up_button)
	give_up_button.pressed.connect(unhighlight)
	give_up_layer.pressed.connect(_marker_layer)


func _marker_layer() -> void:
	unhighlight()
	actual_level.show()
	hint_button.hide()
	validate_button.hide()
	var marker_layer : MerlinPopup = new_popup("Use the rounded markers to write down useful info. Right click to reset a marker.")
	highlight(marker_button)
	await marker_button.pressed
	await marker_button.pressed
	await marker_button.pressed
	await marker_button.pressed
	unhighlight()
	marker_layer.enable()
	marker_layer.pressed.connect(_bookmark_layer)


func _bookmark_layer() -> void:
	var bookmark_layer : MerlinPopup = new_popup("Check these bookmarks to flag all liars")
	highlight(bookmark_button)
	await bookmark_button.pressed
	unhighlight()
	bookmark_layer.enable()
	bookmark_layer.pressed.connect(_validate_layer)


func _validate_layer() -> void:
	validate_button.show()
	var validate_layer: MerlinPopup = new_popup("Once you found all the liars, click \"Validate\" to check your answer")
	highlight(validate_button)
	await validate_button.pressed
	unhighlight()
	validate_button.disabled = true
	validate_layer.enable()
	validate_layer.pressed.connect(_hint_layer)


func _hint_layer() -> void:
	var ready_text: String = "You are now ready for your first level!"
	var hint_layer: MerlinPopup = new_popup(ready_text) if Global.VERSION == Global.Version.NO_HELP else new_popup("If you ever get stuck, don't hesitate to ask me for a bit of help!")
	hint_layer.set_button_text("Play")
	hint_layer.pressed.connect(Global.next_level)
	if Global.VERSION != Global.Version.NO_HELP:
		hint_layer.align_bottom()
		hint_button.show()
		highlight(hint_button)
		await hint_button.pressed
		await %HintButtonContainer.pressed
		if Global.VERSION == Global.Version.ITS or Global.VERSION == Global.Version.ALL:
			$Hint1.show()
			%HintButtonContainer.pressed.connect(func(_x:int) -> void : $Hint1.hide())
		unhighlight()
		
		hint_layer.set_label_text(ready_text)
	hint_layer.enable()


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


func end_level(_solved: bool = true) -> void:
	give_up_button.queue_free()

func _on_validate_button_pressed() -> void:
	if is_correct():
		for person: Person in persons: 
			person.reveal_guilty(true)
