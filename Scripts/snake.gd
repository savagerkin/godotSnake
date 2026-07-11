extends CharacterBody2D

var direction := Vector2.ZERO	

func _process(delta: float) -> void:
	
	#Check which button has pressed last, and make the direction equal to it
	if Input.is_action_just_pressed("move_up") && direction != Vector2.DOWN :
		direction = Vector2.UP
	elif Input.is_action_just_pressed("move_down") && direction != Vector2.UP:
		direction = Vector2.DOWN
	elif Input.is_action_just_pressed("move_left") && direction != Vector2.RIGHT:
		direction = Vector2.LEFT
	elif Input.is_action_just_pressed("move_right") && direction != Vector2.LEFT:
		direction = Vector2.RIGHT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += direction * 100.0 * delta
