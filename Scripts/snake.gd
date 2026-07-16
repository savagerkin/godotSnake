extends CharacterBody2D

@export var speed: float = 100.0
@export var segment_scene: PackedScene

# Number of recorded physics frames between each segment.
@export var segment_spacing: int = 12

# Collision radius around each segment.
@export var self_collision_distance: float = 0.8

# Ignore the closest segments because they naturally touch the head.
@export var ignored_near_segments: int = 2


var direction := Vector2.ZERO

var position_history: Array[Vector2] = []
var segments: Array[Node2D] = []

var is_dead: bool = false


func _ready() -> void:
	position_history.append(global_position)


func _process(_delta: float) -> void:
	if is_dead:
		return

	if Input.is_action_just_pressed("move_up") \
	and direction != Vector2.DOWN:
		direction = Vector2.UP

	elif Input.is_action_just_pressed("move_down") \
	and direction != Vector2.UP:
		direction = Vector2.DOWN

	elif Input.is_action_just_pressed("move_left") \
	and direction != Vector2.RIGHT:
		direction = Vector2.LEFT

	elif Input.is_action_just_pressed("move_right") \
	and direction != Vector2.LEFT:
		direction = Vector2.RIGHT


func _physics_process(_delta: float) -> void:
	if is_dead:
		return

	if direction == Vector2.ZERO:
		return

	# Remember where the head and segments were before moving.
	var previous_head_position := global_position
	var previous_segment_positions: Array[Vector2] = []

	for segment in segments:
		previous_segment_positions.append(segment.global_position)

	# Move the head.
	velocity = direction * speed
	move_and_slide()

	# Save the new head position and move the body.
	_save_head_position()
	_update_segments()

	# Check the complete movement between the previous and new positions.
	_check_self_collision(
		previous_head_position,
		previous_segment_positions
	)


func grow() -> void:
	if segment_scene == null:
		push_error("No Segment Scene has been assigned to the Snake.")
		return

	var new_segment := segment_scene.instantiate() as Node2D

	# Add it beside the snake, not as a child of the moving head.
	get_parent().add_child(new_segment)
	segments.append(new_segment)

	var history_index := segments.size() * segment_spacing

	if history_index < position_history.size():
		new_segment.global_position = position_history[history_index]
	elif not position_history.is_empty():
		new_segment.global_position = position_history.back()
	else:
		new_segment.global_position = global_position


func _save_head_position() -> void:
	position_history.push_front(global_position)

	# Keep enough history for every segment, plus a little extra.
	var required_history := (
		(segments.size() + 1) * segment_spacing
		+ 1
	)

	if position_history.size() > required_history:
		position_history.resize(required_history)


func _update_segments() -> void:
	for index in range(segments.size()):
		var history_index := (index + 1) * segment_spacing

		if history_index < position_history.size():
			segments[index].global_position = position_history[history_index]


func _check_self_collision(
	previous_head_position: Vector2,
	previous_segment_positions: Array[Vector2]
) -> void:
	if segments.size() <= ignored_near_segments:
		return

	for index in range(
		ignored_near_segments,
		segments.size()
	):
		var segment := segments[index]

		var collided := _movement_paths_collide(
			previous_head_position,
			global_position,
			previous_segment_positions[index],
			segment.global_position,
			self_collision_distance
		)

		if collided:
			_game_over()
			return


func _movement_paths_collide(
	head_start: Vector2,
	head_end: Vector2,
	segment_start: Vector2,
	segment_end: Vector2,
	collision_distance: float
) -> bool:
	# Examine the head's movement relative to the segment's movement.
	var relative_start := head_start - segment_start

	var relative_movement := (
		(head_end - head_start)
		- (segment_end - segment_start)
	)

	var movement_length_squared := relative_movement.length_squared()

	# Neither object moved relative to the other.
	if is_zero_approx(movement_length_squared):
		return relative_start.length() <= collision_distance

	# Find the closest moment between the start and end of this frame.
	var closest_time := clampf(
		-relative_start.dot(relative_movement)
		/ movement_length_squared,
		0.0,
		1.0
	)

	var closest_relative_position := (
		relative_start
		+ relative_movement * closest_time
	)

	return closest_relative_position.length() <= collision_distance


func _game_over() -> void:
	if is_dead:
		return

	is_dead = true
	velocity = Vector2.ZERO

	print("Game over")

	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()
