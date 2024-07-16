extends Node

@onready var KNIFE_TEXTURES := [
	preload("res://assets/knife1.png"),
	preload("res://assets/knife2.png"),
	preload("res://assets/knife3.png"),
	preload("res://assets/knife4.png"),
	preload("res://assets/knife5.png"),
	preload("res://assets/knife6.png"),
	preload("res://assets/knife7.png"),
	preload("res://assets/knife8.png"),
	preload("res://assets/knife9.png"),
]

@onready var TARGETS := [
	load("res://elements/targets/target/target.tscn"),
	load("res://elements/targets/target_accelerated/target_accelerated.tscn"),
]

@onready var BOSSES := [
	load("res://elements/targets/target_sheese_boss/target_cheese_boss.tscn"),
]

const BOSS_LEVEL := 5

const location_to_scene = {
	Events.LOCATIONS.START: preload("res://scenes/start_scene/start_screen.tscn"),
	Events.LOCATIONS.GAME: preload("res://scenes/game/game.tscn"),
	Events.LOCATIONS.SHOP: preload("res://scenes/knifes_shop/knife_shop.tscn"),
}

const SAVE_GAME_FILE := "user://savegame.save"
const SAVE_VARIABLES := ['apples', 'unlocked_knifes', 'active_knife_inde']
const UNLOCK_COST := 10
const MAX_STAGE_APPLES := 3
const MAX_STAGE_KNIFES := 2
const MIN_KNIFES := 5
const MAX_KNIFES := 8

var rng := RandomNumberGenerator.new()

var current_stage := 1
var points := 0
var knifes := 0
var apples := 0

var active_knife_inde := 0
var unlocked_knifes := 0b000000001

func _ready():
	load_game()
	rng.randomize()
	seed(rng.seed)
	print_debug(rng.seed)
	Events.location_changed.connect(handle_location_change)

func unlock_knife (knife_index: int):
	unlocked_knifes |= (1 << knife_index)
	
func is_knife_unlocked (knife_index: int) -> bool:
	return unlocked_knifes & (1 << knife_index) != 0

func change_knife (knife_index: int):
	active_knife_inde = knife_index
	Events.active_knife_changed.emit(knife_index)

func load_game ():
	if not FileAccess.file_exists(SAVE_GAME_FILE):
		return

	var save_game_file = FileAccess.open(SAVE_GAME_FILE, FileAccess.READ)
	if save_game_file == null:
		printerr('save failed with error code {0}'.format([FileAccess.get_open_error()]))
		return
	
	var json_object := JSON.new()
	var error = json_object.parse(save_game_file.get_line())
	if error != OK:
		return

	var game_data = json_object.get_data()
	for variable in SAVE_VARIABLES:
		if variable in game_data:
			set(variable, game_data[variable])

func save_game ():
	var save_game_file = FileAccess.open(SAVE_GAME_FILE, FileAccess.WRITE)
	
	if save_game_file == null:
		printerr('save failed with error code {0}'.format([FileAccess.get_open_error()]))
		return
	
	var game_data := {}
	for variable in SAVE_VARIABLES:
		game_data[variable] = get(variable)
	
	var json_object := JSON.new()
	save_game_file.store_line(json_object.stringify(game_data))
	print('game saved')

func add_apples (amount: int):
	apples += amount
	Events.apples_changed.emit(apples)

func change_stage (starge_i: int):
	current_stage = starge_i
	var stage: Stage
	if current_stage % BOSS_LEVEL == 0:
		stage = Stage.new(BOSSES.pick_random())
	else:
		stage = Stage.new() if current_stage == 1 else get_random_stage()
	knifes = rng.randi_range(MIN_KNIFES, MAX_KNIFES)
	Events.knifes_changed.emit(knifes)
	Events.stage_changed.emit(stage)

func get_random_stage () -> Stage:
	var stage := Stage.new(TARGETS.pick_random())
	stage.apples = rng.randi_range(0, MAX_STAGE_APPLES)
	stage.knifes = rng.randi_range(0, MAX_STAGE_KNIFES)
	return stage

func remove_knife():
	knifes -= 1
	Events.knifes_changed.emit(knifes)

func add_point():
	points += 1
	Events.points_changed.emit(points)

func reset_points():
	points = 0
	Events.points_changed.emit(points)

func handle_location_change (location: Events.LOCATIONS):
	get_tree().change_scene_to_packed(location_to_scene.get(location))
