extends Area2D

signal finished

@export var duration := 1.5
@export var damage := 1
@export var tick := 0.2
@export var start_offset := 40.0

var direction := Vector2.RIGHT
var elapsed := 0.0
var tick_timer := 0.0

func _ready() -> void:
	rotation = direction.angle()
	position += direction * start_offset
	$AnimatedSprite2D.play()

func _physics_process(delta: float) -> void:
	elapsed += delta
	tick_timer -= delta
	if tick_timer <= 0.0:
		tick_timer = tick
		for body in get_overlapping_bodies():
			if body != get_parent() and body.has_method("take_damage"):
				body.take_damage(damage)
	if elapsed >= duration:
		finished.emit()
		queue_free()
