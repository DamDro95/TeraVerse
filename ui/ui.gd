extends CanvasLayer

func _on_button_pressed() -> void:
	NetworkController.start_server()
	hide()


func _on_button_2_pressed() -> void:
	%StartMenu.hide()
	%ConnectMenu.show()


func _on_connect_button_pressed() -> void:
	NetworkController.start_client(%IPAddressTextEdit.text)
	hide()
