extends Node2D

const EXPLOSION_TIME := 1.0

@onready var particles := [$AppleParticles2D, $AppleParticles2D2]
@onready var sprite = $Sprite2D

var is_hited := false

func _on_area_2d_body_entered(body):
	if not is_hited:
		var tween = create_tween()
		
		is_hited = true
		sprite.hide()
		for particle in particles:
			particle.emitting = true
			tween.parallel().tween_property(particle, 'modulate:a', 0, EXPLOSION_TIME)
			
		tween.play()
		await tween.finished
		queue_free()
