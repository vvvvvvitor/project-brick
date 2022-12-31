extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	toggled.connect(_on_toggle)
	CoreUiManager.pause_visibility_changed.connect(_on_hide)
	
func _on_toggle(val):
	if val:
		CoreUiManager.show_pause_menu()
	else: CoreUiManager.hide_pause_menu()

func _on_hide(tog):
	if !tog:
		button_pressed = false
