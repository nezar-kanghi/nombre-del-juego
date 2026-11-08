extends Node2D

@export var enemy_scene: PackedScene
@export var next_scene := "res://scene/levels/prueba.tscn"
@export var enemies_needed := 3
@export var spot_energy := 0.5
@export var spot_scale := 1.0

@onready var player = $Player
@onready var label: Label = $UI/Label
@onready var spawn: Marker2D = $SpawnPoint
@onready var darkness: CanvasModulate = $CanvasModulate

var killed := 0

func _ready() -> void:
	label.text = "Muévete con W, A, S, D"
	await player.moved
	await get_tree().create_timer(1.5).timeout

	label.text = "Clic izquierdo (M1) para disparar un misil hacia el ratón"
	await player.shot
	await get_tree().create_timer(1.5).timeout

	label.text = "La sala está a oscuras. Cada enemigo que derrotes la iluminará y aumentará tu brillo"
	await get_tree().create_timer(3.5).timeout

	label.text = "¡Un enemigo se acerca! Derrótalo con tus misiles"
	await fight_enemy()

	label.text = "Pulsa X para usar la ULTI (no podrás moverte mientras dura)"
	var enemy2 = spawn_enemy()
	await player.ulti_used
	await get_tree().create_timer(2.0).timeout
	if is_instance_valid(enemy2):
		label.text = "Termina con el enemigo"
		await enemy2.died
	await get_tree().create_timer(1.5).timeout

	label.text = "¡Último! Derrótalo para iluminar toda la sala"
	await fight_enemy()

	label.text = "¡Sala iluminada! Entrando al bosque..."
	var t := create_tween().set_parallel(true)
	t.tween_property(darkness, "color", Color.WHITE, 1.5)
	t.tween_property(player.get_node("Light"), "energy", 0.0, 1.5)
	for l in get_tree().get_nodes_in_group("spots"):
		t.tween_property(l, "energy", 0.0, 1.5)
	await t.finished
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file(next_scene)

func fight_enemy() -> void:
	var enemy = spawn_enemy()
	await enemy.died
	await get_tree().create_timer(1.5).timeout

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	enemy.global_position = spawn.global_position
	enemy.target = player
	enemy.died.connect(_on_enemy_died)
	return enemy

func _on_enemy_died(pos: Vector2) -> void:
	killed += 1
	label.text = "¡Luz! Sala iluminada %d/%d" % [killed, enemies_needed]
	player.add_brightness(20.0)
	light_up(pos)

func light_up(pos: Vector2) -> void:
	var l := PointLight2D.new()
	l.texture = player.get_node("Light").texture
	l.energy = spot_energy
	l.texture_scale = 0.0
	l.add_to_group("spots")
	add_child(l)
	l.global_position = pos
	create_tween().tween_property(l, "texture_scale", spot_scale, 0.8)
