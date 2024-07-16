extends Node

enum LOCATIONS { START, GAME, SHOP }

signal game_over
signal location_changed (location: LOCATIONS)
signal points_changed (points: int)
signal knifes_changed (knifes: int)
signal stage_changed (stage: Stage)
signal apples_changed (apples: int)
signal active_knife_changed (knife_index: int)
