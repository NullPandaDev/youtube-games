extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -270.0

const coyote_time = 0.1
var coyote_timer = 0.0
const jump_buffer_time = 0.1
var jump_buffer_timer = 0.0

func _handle_jump(delta: float) -> void:
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer -= delta

	#if Input.is_action_just_pressed("jump"):
	if jump_buffer_timer > 0 and (is_on_floor() or coyote_timer > 0):
		velocity.y = JUMP_VELOCITY
		jump_buffer_timer = 0  # Consume the buffered jump
		coyote_timer = 0       # Optional: prevent double jumps

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	_handle_jump(delta)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if position.y > 300:
		get_tree().reload_current_scene()
	move_and_slide()
