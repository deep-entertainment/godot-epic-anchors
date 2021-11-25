tool
extends Control

export var use_editor_theme_color : bool = true
export var custom_hover_color := Color("f63c3c")

var interface : EditorInterface
var undo_redo : UndoRedo

var selected_nodes : = []

onready var panel : Panel = $Panel
onready var anchor_button : TextureButton = $ButtonPanel/AnchorButton

var toggled : bool = true
var modifier : = false
	
func _ready() -> void:
	setup_project_setting_variables()
	interface.get_selection().connect("selection_changed", self, "on_selection_changed")
	interface.get_editor_settings().connect("settings_changed", self, "on_settings_changed")
	on_settings_changed() # Update
	panel.hide()
	hide()


func setup_project_setting_variables() -> void:
	if ProjectSettings.has_setting("global/use_editor_theme_color"):
		use_editor_theme_color = ProjectSettings.get_setting("global/use_editor_theme_color")
	else:
		ProjectSettings.set_initial_value("global/use_editor_theme_color", use_editor_theme_color)
		ProjectSettings.set_setting("global/use_editor_theme_color", use_editor_theme_color)
	
	if ProjectSettings.has_setting("global/custom_hover_color"):
		custom_hover_color = ProjectSettings.get_setting("global/custom_hover_color")
	else:
		ProjectSettings.set_initial_value("global/custom_hover_color", custom_hover_color)
		ProjectSettings.set_setting("global/custom_hover_color", custom_hover_color)
	


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


func on_settings_changed() -> void:
	var settings = interface.get_editor_settings()
	
	var editor_accent_color = settings.get_setting("interface/theme/accent_color")
	var hover_color = editor_accent_color if use_editor_theme_color else custom_hover_color
	panel.hover_col = hover_color
	anchor_button.hover_col = hover_color
