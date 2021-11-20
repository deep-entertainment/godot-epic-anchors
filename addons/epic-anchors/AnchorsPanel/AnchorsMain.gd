tool
extends Control

var interface : EditorInterface
var undo_redo : UndoRedo

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
			undo_redo.create_action("Change Anchors and Margins" if !modifier else "Change Anchors")
			undo_redo.add_undo_property(i, "anchor_bottom", i.anchor_bottom)
			undo_redo.add_undo_property(i, "anchor_top", i.anchor_top)
			undo_redo.add_undo_property(i, "anchor_left", i.anchor_left)
			undo_redo.add_undo_property(i, "anchor_right", i.anchor_right)
			undo_redo.add_undo_property(i, "margin_bottom", i.margin_bottom)
			undo_redo.add_undo_property(i, "margin_top", i.margin_top)
			undo_redo.add_undo_property(i, "margin_left", i.margin_left)
			undo_redo.add_undo_property(i, "margin_right", i.margin_right)
			if !modifier:
				undo_redo.add_do_method(i, "set_anchors_and_margins_preset", which, panel.layout_preset_mode_selected, 0)
			else:
				undo_redo.add_do_method(i, "set_anchors_preset", which)
			undo_redo.commit_action()



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
