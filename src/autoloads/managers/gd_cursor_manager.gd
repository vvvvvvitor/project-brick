extends Control

var cursor_atlas:Texture2D = preload("res://textures/UI/cursor.png")

enum CURSOR_STATES {
	NORMAL,
	HAND_OPEN,
	HAND_CLOSED,
	AIM
}
var current_cursor_state = CURSOR_STATES.HAND_CLOSED


func _process(delta):
	#if event is InputEventMouseMotion:
	queue_redraw()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _draw():
	draw_texture_rect_region(
		cursor_atlas, 
		Rect2(get_local_mouse_position(), Vector2.ONE * cursor_atlas.get_height()), 
		Rect2(cursor_atlas.get_height() * current_cursor_state, 0, cursor_atlas.get_height(), cursor_atlas.get_height()), 
		Color.WHITE
		)
	
