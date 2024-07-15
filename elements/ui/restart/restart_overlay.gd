extends CanvasLayer

func _on_restart_button_pressed():
	Events.location_changed.emit(Events.LOCATIONS.GAME)
