extends Node2D

var game_started: bool = false
var last_score: int = 0

@export var score_label: Label
@export var beer_scene: PackedScene


func _ready() -> void:
	_start_game()


func _process(_delta: float) -> void:
	if last_score != ScoreManager.get_score():
		last_score = ScoreManager.get_score()

		_update_score_label()
		_spawn_beer()


func _start_game() -> void:
	ScoreManager.set_score(0)

	last_score = 0
	game_started = true

	_update_score_label()
	_spawn_beer()


func _spawn_beer() -> void:
	if beer_scene == null:
		push_error("No Beer Scene has been assigned to Game.")
		return

	var beer := beer_scene.instantiate()
	add_child(beer)

	var margin := 10.0

	beer.position = Vector2(
		randf_range(-5.0 + margin, 5.0 - margin),
		randf_range(-5.0 + margin, 5.0 - margin)
	)


func _update_score_label() -> void:
	score_label.text = (
		"Score: "
		+ str(ScoreManager.get_score())
	)
