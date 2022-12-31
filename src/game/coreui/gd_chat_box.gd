extends TextEdit


# Called when the node enters the scene tree for the first time.
func _ready():
	focus_entered.connect(_on_focus_enter)
	focus_exited.connect(_on_focus_exited)
	
func _on_focus_enter():
	OnlineManager.local_client.force_idle = true

func _on_focus_exited():
	OnlineManager.local_client.force_idle = false

func _input(event):
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				release_focus()
	if event.is_action_pressed("ui_accept"):
		text = ''
		release_focus()
	if event.is_action_pressed("core_type"):
		if text.is_empty():
			text = ''
		grab_focus()
