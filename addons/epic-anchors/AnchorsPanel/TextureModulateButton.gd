tool
extends TextureButton

export(Color) var normal_col
export(Color) var hover_col


func _ready() -> void:
	connect("toggled", self, "on_toggled")
	modulate = normal_col

func on_toggled(really : bool) -> void:
	if really:
		modulate = hover_col
	else:
		modulate = normal_col
