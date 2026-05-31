extends CanvasLayer

func _on_button_pressed() -> void:
	NetworkController.start_server()
	hide()

func _on_button_2_pressed() -> void:
	NetworkController.start_client()
	hide()
