extends CharacterBody2D

signal moved
signal shot
signal ulti_used

@export var speed := 200.0
@export var missile_scene: PackedScene
@export var ulti_scene: PackedScene
@export var fire_cooldown := 0.3
@export var ulti_cooldown := 5.0

var shoot_timer := 0.0
var ulti_timer := 0.0
var casting := false

func _physics_process(delta: float) -> void:
	shoot_timer -= delta
	ulti_timer -= delta

	if casting:
		velocity = Vector2.ZERO
		return

	var dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = dir * speed
	move_and_slide()
	var half := get_viewport_rect().size / 2.0
	position = position.clamp(-half, half)
	if dir != Vector2.ZERO:
		moved.emit()

func _unhandled_input(event: InputEvent) -> void:
	if casting:
		return
	if event.is_action_pressed("shoot") and shoot_timer <= 0.0:
		shoot()
	elif event.is_action_pressed("ulti") and ulti_timer <= 0.0:
		use_ulti()

func shoot() -> void:
	shoot_timer = fire_cooldown
	var m := missile_scene.instantiate()
	m.global_position = $Muzzle.global_position
	m.direction = (get_global_mouse_position() - $Muzzle.global_position).normalized()
	get_parent().add_child(m)
	shot.emit()

func use_ulti() -> void:
	ulti_timer = ulti_cooldown
	casting = true
	var u := ulti_scene.instantiate()
	u.direction = (get_global_mouse_position() - global_position).normalized()
	u.finished.connect(_on_ulti_finished)
	u.position = $Muzzle.position
	add_child(u)
	ulti_used.emit()

func _on_ulti_finished() -> void:
	casting = false
	
signal brightness_changed(value: float)


@export var max_brightness := 100.0
var brightness := 0.0

@onready var light: PointLight2D = $Light

func add_brightness(amount: float) -> void:
	brightness = clampf(brightness + amount, 0.0, max_brightness)
	var s := 1.0 + (brightness / max_brightness) * 0.8
	create_tween().tween_property(light, "texture_scale", s, 0.4)
	brightness_changed.emit(brightness)
