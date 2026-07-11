extends Node2D

var game_started: bool = false

@export var score_label: Label
@export var beer_scene: PackedScene


func _ready() -> void:
	_start_game()


func _start_game() -> void:
	ScoreManager.set_score(0)
	_update_score_label()
	game_started = true

func _process(delta: float) -> void:
	_update_score_label()


func _update_score_label() -> void:
	score_label.text = "Score: " + str(ScoreManager.get_score())
