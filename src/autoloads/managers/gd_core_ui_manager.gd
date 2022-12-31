extends Node

signal bottom_bar_ready
var bottom_bar:Control:
	get: return bottom_bar
	set(val):
		bottom_bar = val
		emit_signal("bottom_bar_ready")
var pause_menu:Control

enum BOTTOM_BAR_DIRECTION {
	LEFT,
	CENTER,
	RIGHT
}

func add_to_bottom_bar(element:Control, direction:BOTTOM_BAR_DIRECTION):
	bottom_bar.get_children()[direction].add_child(element)

signal pause_visibility_changed
func show_pause_menu():
	emit_signal("pause_visibility_changed", true)
	pause_menu.visible = true
	var show_tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
	show_tween.tween_property(pause_menu, "custom_minimum_size", Vector2(0, 256), 0.2).set_trans(Tween.TRANS_QUAD)
	
func hide_pause_menu():
	emit_signal("pause_visibility_changed", false)
	var hide_tween = get_tree().create_tween().set_ease(Tween.EASE_IN)
	hide_tween.tween_property(pause_menu, "custom_minimum_size", Vector2(0, 0), 0.2).set_trans(Tween.TRANS_QUAD)
	await hide_tween.finished
	pause_menu.visible = false
