extends CharacterBody2D

var direction := Vector2.ZERO
var speed := 100.0


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("move_up") and direction != Vector2.DOWN:
		direction = Vector2.UP
	elif Input.is_action_just_pressed("move_down") and direction != Vector2.UP:
		direction = Vector2.DOWN
	elif Input.is_action_just_pressed("move_left") and direction != Vector2.RIGHT:
		direction = Vector2.LEFT
	elif Input.is_action_just_pressed("move_right") and direction != Vector2.LEFT:
		direction = Vector2.RIGHT


func _physics_process(_delta: float) -> void:
	velocity = direction * speed
	move_and_slide()
