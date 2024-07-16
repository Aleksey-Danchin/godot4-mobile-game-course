extends Control

@onready var knife_texture_rect = $MarginContainer/VBoxContainer/CenterContainer/KnifeTextureRect

func _ready():
	knife_texture_rect.texture = Globals.KNIFE_TEXTURES[Globals.active_knife_inde]

func _on_button_pressed():
	Events.location_changed.emit(Events.LOCATIONS.GAME)


func _on_texture_button_pressed():
	Events.location_changed.emit(Events.LOCATIONS.SHOP)
