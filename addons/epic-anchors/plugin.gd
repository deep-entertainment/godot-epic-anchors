tool
extends EditorPlugin

var plugin_name : String = "Ultimate UI"
var anchors_instance : Control

var widget_set_up : = false

func get_plugin_name() -> String:
	return plugin_name

func _enter_tree():
	anchors_instance = preload("res://addons/epic-anchors/AnchorsPanel/Anchors.tscn").instance()
	anchors_instance.interface = get_editor_interface()
	anchors_instance.undo_redo = get_undo_redo()
	connect("main_screen_changed", anchors_instance, "on_main_screen_changed")
	
func _process(delta: float) -> void:
	if not widget_set_up and \
			get_editor_interface().get_edited_scene_root() != null:
		var view_2d_control = get_editor_interface().get_edited_scene_root().get_parent().get_parent().get_parent()
		view_2d_control.add_child(anchors_instance)
		widget_set_up = true
	if widget_set_up:
		set_process(false)

func _exit_tree():
	anchors_instance.queue_free()
