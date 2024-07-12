extends CharacterBody2D
class_name  Target

const GENERATION_LIMIT := 10
const KNIFE_POSITION := Vector2(0, 180)
const APPLE_POSITION := Vector2(0, 176)
const OBJECT_MARGIN := PI / 6

var knife_scene := load("res://elements/knife/knife.tscn")
var apple_scene := load("res://elements/apple/apple.tscn")

var speed := PI

@onready var items_container = $ItemsContainer

func _ready():
	add_default_items(3, 2)

func _physics_process(delta: float):
	rotation += speed * delta

func add_object_with_pivot (object: Node2D, object_rotation: float):
	var pivot := Node2D.new()
	pivot.rotation = object_rotation
	pivot.add_child(object)
	items_container.add_child(pivot)

func add_default_items (knives: int, apples: int):
	var occupied_rotation := []

	for i in range(knives):
		var pivot_rotation = get_free_random_ratation(occupied_rotation)
		
		if pivot_rotation == null:
			return
			
		occupied_rotation.append(pivot_rotation)
		var knife = knife_scene.instantiate()
		knife.position = KNIFE_POSITION
		add_object_with_pivot(knife, pivot_rotation)
	
	for i in range(apples):
		var pivot_rotation = get_free_random_ratation(occupied_rotation)
		
		if pivot_rotation == null:
			return
			
		occupied_rotation.append(pivot_rotation)
		var apple = apple_scene.instantiate()
		apple.position = APPLE_POSITION
		add_object_with_pivot(apple, pivot_rotation)

func get_free_random_ratation (occupied_rotations: Array):
	for i in GENERATION_LIMIT:
		var random_rotation = Globals.rng.randf_range(0, PI * 2)
		var is_correct = true
		
		for occupied in occupied_rotations:
			if random_rotation <= occupied + OBJECT_MARGIN / 2.0 and random_rotation >= OBJECT_MARGIN / 2.0:
				is_correct = false
				break
		
		if is_correct:
			return random_rotation
	
	return null
