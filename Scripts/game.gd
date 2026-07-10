extends Node2D

var score: int = 0
var game_started: bool = false

@export var score_label: Label
@export var beer_scene: PackedScene


func _ready() -> void:
	start_game()


func start_game() -> void:
	score = 0
	game_started = true

	update_score_label()
	spawn_beer()


func increase_score() -> void:
	score += 1
	update_score_label()
	spawn_beer()


func update_score_label() -> void:
	score_label.text = "Score: " + str(score)


func spawn_beer() -> void:
	var beer := beer_scene.instantiate() as Area2D

	beer.collected.connect(increase_score)
	add_child(beer)

	beer.position = Vector2(
		randi_range(0, 20) * 32,
		randi_range(0, 15) * 32
	)
