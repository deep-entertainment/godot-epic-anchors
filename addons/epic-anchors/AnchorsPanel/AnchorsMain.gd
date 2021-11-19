tool
extends Control

var interface : EditorInterface

var selected_nodes : = []

onready var panel : Panel = $Panel

var toggled : bool = true
var modifier : = false

func _ready() -> void:
	interface.get_selection().connect("selection_changed", self, "on_selection_changed")
	panel.hide()
	hide()


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.scancode == KEY_SHIFT:
			if event.pressed:
				modifier = true
				panel.mod_on()
			else:
				modifier = false
				panel.mod_off()
				


func selected_anchor(which : int) -> void:
	if selected_nodes:
		for i in selected_nodes:
			if !modifier:
				i.set_anchors_and_margins_preset(which, panel.layout_preset_mode_selected, 0)
			else:
				i.set_anchors_preset(which)
				


func on_main_screen_changed(which : String) -> void:
	pass
#	if which == "2D":
#		show()
#	else:
#		hide()
#

func on_selection_changed() -> void:
	selected_nodes = interface.get_selection().get_selected_nodes()
	
	if selected_nodes:
		if selected_nodes[0] is Control:
			show()
		else:
			hide()
	else:
		hide()
