extends CharacterBody2D

@export var segment_scene: PackedScene
@export var segment_distance: int = 15

var direction := Vector2.ZERO
var speed := 4.0

var position_history: Array[Vector2] = []
var segments: Array[Node2D] = []
var last_score: int = 0


func _ready() -> void:
	last_score = ScoreManager.get_score()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("move_up") and direction != Vector2.DOWN:
		direction = Vector2.UP
	elif Input.is_action_just_pressed("move_down") and direction != Vector2.UP:
		direction = Vector2.DOWN
	elif Input.is_action_just_pressed("move_left") and direction != Vector2.RIGHT:
		direction = Vector2.LEFT
	elif Input.is_action_just_pressed("move_right") and direction != Vector2.LEFT:
		direction = Vector2.RIGHT

	if last_score != ScoreManager.get_score():
		last_score = ScoreManager.get_score()
		_grow()


func _physics_process(_delta: float) -> void:
	velocity = direction * speed
	move_and_slide()

	if direction != Vector2.ZERO:
		_save_position()
		_move_segments()


func _grow() -> void:
	var new_segment := segment_scene.instantiate() as Node2D
	get_parent().add_child(new_segment)

	segments.append(new_segment)

	if position_history.is_empty():
		new_segment.global_position = global_position
	else:
		new_segment.global_position = position_history.back()


func _save_position() -> void:
	position_history.push_front(global_position)

	var required_history := (segments.size() + 1) * segment_distance

	if position_history.size() > required_history:
		position_history.resize(required_history)


func _move_segments() -> void:
	for index in range(segments.size()):
		var history_index := (index + 1) * segment_distance

		if history_index < position_history.size():
			segments[index].global_position = position_history[history_index]
