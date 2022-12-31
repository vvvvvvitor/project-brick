extends Control


func _ready():
	CoreUiManager.pause_menu = self
	custom_minimum_size = Vector2.ZERO
	visible = false
