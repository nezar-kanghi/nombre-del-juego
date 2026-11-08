extends CharacterBody2D

signal died(pos: Vector2)

@export var speed := 60.0
@export var health := 3

var target: Node2D

func _physics_process(_delta: float) -> void:
	if target == null:
		return
	velocity = (target.global_position - global_position).normalized() * speed
	move_and_slide()

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		died.emit(global_position)
		queue_free()
