extends HBoxContainer

@onready var pause_menu = $"../../../../.."

var held = false

func _process(delta):
	if held:
		pause_menu.custom_minimum_size.y = get_viewport_rect().size.y - get_global_mouse_position().y
		if pause_menu.custom_minimum_size.y < 64:
			CoreUiManager.hide_pause_menu()
	pause_menu.custom_minimum_size.y = clamp(pause_menu.custom_minimum_size.y, 0, get_viewport_rect().size.y - 128)

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				held = true
			else: held = false
	#print(get_global_mouse_position().y)
