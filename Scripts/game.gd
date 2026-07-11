extends Node2D

var game_started: bool = false
var last_score: int = 0

@export var score_label: Label
@export var beer_scene: PackedScene

# Start the game, initialization
func _ready() -> void:
	_start_game()


func _process(_delta: float) -> void:
	# Check if the score has changed if so ->
	if last_score != ScoreManager.get_score():
		last_score = ScoreManager.get_score()
		# Update the score in the  label
		_update_score_label()
		# Spawn a new beer
		_spawn_beer()

# Initialization for the scores, beers and points.
func _start_game() -> void:
	ScoreManager.set_score(0)
	last_score = 0
	game_started = true

	_update_score_label()
	_spawn_beer()

# A funciton to create the beer, between a random range
func _spawn_beer() -> void:
	var beer := beer_scene.instantiate()
	add_child(beer)
	# So it dosent spill through the screen.
	var margin := 10.0

	beer.position = Vector2(
		randf_range(-100.0 + margin, 100.0 - margin),
		randf_range(-100.0 + margin, 100.0 - margin)
	)

#Function updates the score label.
func _update_score_label() -> void:
	score_label.text = "Score: " + str(ScoreManager.get_score())
