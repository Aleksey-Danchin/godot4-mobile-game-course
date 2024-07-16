extends PanelContainer

enum State { OPENED, ACTIVE }

const COLORS := {
	State.OPENED: Color("a1a1a4"),
	State.ACTIVE: Color("294639"),
}

@onready var color_rect = $ColorRect
@onready var texture_rect = $MarginContainer/TextureRect

var knife_index := 0

func _ready ():
	Events.active_knife_changed.connect(update_knife_status)

func change_state (state: State):
	color_rect.color = COLORS[state]
	texture_rect.texture = Globals.KNIFE_TEXTURES[knife_index]

func initialize (knife_idx: int):
	knife_index = knife_idx
	
	if Globals.active_knife_inde == knife_index:
		change_state(State.ACTIVE)
	elif Globals.is_knife_unlocked(knife_idx):
		change_state(State.OPENED)
		
func unlock ():
	change_state(State.OPENED)

func update_knife_status (knife_idx: int):
	if knife_index == knife_idx:
		change_state(State.ACTIVE)
	elif Globals.is_knife_unlocked(knife_index):
		change_state(State.OPENED)

func _on_button_pressed():
	if not Globals.is_knife_unlocked(knife_index):
		return
	Globals.change_knife(knife_index)
	Globals.save_game()
