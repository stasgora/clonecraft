extends Node

signal menu_toggled(open: bool)
var menu_open: bool = false


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(_delta):
	if Input.is_action_just_pressed("menu"):
		menu_open = !menu_open
		menu_toggled.emit(menu_open)
		$MenuOverlay.visible = menu_open
		$GameOverlay.visible = !menu_open
		
		var mouse_mode = Input.MOUSE_MODE_VISIBLE if menu_open else Input.MOUSE_MODE_CAPTURED
		Input.set_mouse_mode(mouse_mode)

