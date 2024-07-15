extends CanvasLayer

@onready var knifes_counter = %KnifesCounter
@onready var stage_label = %StageLabel
@onready var apples_counter_label = %ApplesCounter/Label
@onready var stage_counter = %StageCounter
@onready var points_label = %PointsLabel
@onready var home_button = %HomeButton

func _ready ():
	Events.location_changed.connect(update_hud_location)
	Events.points_changed.connect(update_points)
	Events.apples_changed.connect(update_apples)
	update_apples(Globals.apples)
	update_hud_location(Events.LOCATIONS.START)

func _on_home_button_pressed():
	Events.location_changed.emit(Events.LOCATIONS.START)

func update_apples (apples: int):
	print('apples', apples)
	apples_counter_label.text = str(apples)

func update_points (points: int):
	points_label.text = str(points)

func update_hud_location(location: Events.LOCATIONS):
	match location:
		Events.LOCATIONS.START:
			knifes_counter.hide()
			home_button.hide()
			points_label.hide()
			stage_label.hide()
			stage_counter.hide()
		Events.LOCATIONS.GAME:
			knifes_counter.show()
			home_button.hide()
			points_label.show()
			stage_label.show()
			stage_counter.show()
		Events.LOCATIONS.SHOP:
			knifes_counter.hide()
			home_button.show()
			points_label.hide()
			stage_label.hide()
			stage_counter.hide()

func update_hud_restart():
	knifes_counter.hide()
	home_button.show()
	points_label.hide()
	stage_label.hide()
	stage_counter.hide()