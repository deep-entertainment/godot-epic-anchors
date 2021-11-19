tool
extends Panel

export(Color) var hover_col
export(Color) var normal_col
export(Color) var text_normal_col
export(Color) var hover_highlight_col

var layout_strings : Array = ["Top left", "Top right", "Bottom left", "Bottom right", "Center left", "Center top", "Center right", "Center bottom", "Center", "Left wide", "Top wide", "Right wide", "Bottom wide", "VCenter wide", "HCenter wide", "Full rect"]

var curr_anchor : int = -1
var layout_preset_mode_selected : int = 3

func _ready() -> void:
	connect_signals()
	
	
func connect_signals() -> void:
	var index : int = 0
	for i in $VBX/MiddlePart/FullRect/HighlightsPoints.get_children():
		i.connect("mouse_entered", self, "on_mouse_entered", [i, i.get_position_in_parent()])
		i.connect("mouse_exited", self, "on_mouse_exited", [i, i.get_position_in_parent()])
		i.connect("gui_input", self, "on_gui_input")
		index += 1
	for i in $VBX/MiddlePart/FullRect/Highlights.get_children():
		i.connect("mouse_entered", self, "on_mouse_entered", [i, i.get_position_in_parent() + index])
		i.connect("mouse_exited", self, "on_mouse_exited", [i, i.get_position_in_parent() + index])
		i.connect("gui_input", self, "on_gui_input")
	$VBX/MiddlePart/FullRect/Full.connect("mouse_entered", self, "on_mouse_entered", [$VBX/MiddlePart/FullRect/Full, 15])
	$VBX/MiddlePart/FullRect/Full.connect("mouse_exited", self, "on_mouse_exited", [$VBX/MiddlePart/FullRect/Full, 15])
	$VBX/MiddlePart/FullRect/Full.connect("gui_input", self, "on_gui_input")
	
	
func update_text(pos : int) -> void:
	$VBX/Label.text = layout_strings[pos]
	$VBX/Label.modulate = hover_col
	
	
func mod_on() -> void:
	$VBX/Modifier.modulate = Color.white
	
	
func mod_off() -> void:
	$VBX/Modifier.modulate = text_normal_col
	
	
### SIGNALS --------------

func on_mouse_entered(i : Node, pos : int) -> void:
	curr_anchor = pos
	if i is Panel:
		i.self_modulate = hover_col
	else:
		i.color = hover_highlight_col
		
	$VBX/MiddlePart/FullRect/Inner.get_child(pos).self_modulate = hover_col
	
	update_text(pos)
	
	
func on_mouse_exited(i : Node, pos : int) -> void:
	if i is Panel:
		i.self_modulate = normal_col
	else:
		i.color = Color.transparent
	
	$VBX/MiddlePart/FullRect/Inner.get_child(pos).self_modulate = normal_col
	
	$VBX/Label.modulate = Color.white
	$VBX/Label.text = "Anchor"
	

func on_gui_input(event : InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		get_parent().selected_anchor(curr_anchor)


func _on_AnchorButton_toggled(button_pressed: bool) -> void:
	visible = button_pressed


func _on_LayoutPresetMode_item_selected(index: int) -> void:
	layout_preset_mode_selected = index
