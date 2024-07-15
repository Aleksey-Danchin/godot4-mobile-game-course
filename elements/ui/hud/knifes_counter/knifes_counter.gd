extends VBoxContainer

const KNIFE_ICO_2: Texture2D = preload("res://assets/knife_ico_2.png")

func _ready():
	Events.knifes_changed.connect(update_knife_counter)

func update_knife_counter (knifes: int):
	var knifes_diff = knifes - get_child_count()
	
	if knifes_diff > 0:
		add_knifes(knifes_diff)
	elif knifes_diff< 0:
		remove_knifes(-knifes_diff)

func create_knife_icon () -> TextureRect:
	var texture_rect := TextureRect.new()
	texture_rect.texture = KNIFE_ICO_2
	return texture_rect

func add_knifes (amount: int):
	for i in amount:
		add_child(create_knife_icon())
		
func remove_knifes (amount: int):
	for i in amount:
		get_child(i).queue_free()
