extends Node

var score: int
var game_started: bool = false
@onready var hud: CanvasLayer = $HUD
@export var snake_scene : PackedScene
@onready var score_label: Label = %ScoreLabel

var cell_size: int = 50
var cells: int = 20

var old_data: Array
var snake_data: Array
var snake: Array

var start_pos =Vector2(9,0)

var up = Vector2(0,-1)
var down = Vector2(0,1)
var left = Vector2(-1,0)
var right = Vector2(1,0)

var move_directino : Vector2
var can_move: bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()
func new_game() -> void:
	score = 0
	game_started = true
	score_label.text = "SCORE: " + (str(score))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
