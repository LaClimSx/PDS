extends Panel

func _ready() -> void:
	var tween := create_tween().set_loops()
	tween.tween_property(self, "modulate:a", 0.3, 0.5).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_SINE)
