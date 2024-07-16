extends PanelContainer

signal pressed

@onready var knife_cost_label = $HBoxContainer/VBoxContainer2/KnifeCostLabel

func _ready():
	knife_cost_label.text = str(Globals.UNLOCK_COST)

func _on_button_pressed():
	pressed.emit()
