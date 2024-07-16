extends RefCounted
class_name Stage

var knifes := 0
var apples := 0
var target_scene_resource: PackedScene

func _init (_target_scene = preload("res://elements/targets/target/target.tscn")):
	print('Stage._init ', _target_scene)
	target_scene_resource = _target_scene

