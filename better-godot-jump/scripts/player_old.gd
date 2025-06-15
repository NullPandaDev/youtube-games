extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -270.0

@onready var player = Player.new(SPEED, JUMP_VELOCITY, $".")

# Local class
class Player:
	# FIXME: Just get this stuff globably within class
	var speed: int
	#var power_up: PowerUp = PowerUp.NORMAL
	var power_up = "NORMAL"
	var jump_velocity: float
	var player: CharacterBody2D
	var sprite: AnimatedSprite2D
	var coyote_time = 0.1
	var coyote_timer = 0.0
	var jump_buffer_time = 0.1
	var jump_buffer_timer = 0.0
	var gun_flash_right_sprite: AnimatedSprite2D
	var gun_flash_left_sprite: AnimatedSprite2D
	var amo = 10
	var alive: bool = true
	var death_time: float = 3.0
	var death_timer: float = 0.0
	
	func _init(speed: float, jump_velocity: float, player: CharacterBody2D):
		self.speed = speed
		self.jump_velocity = jump_velocity
		self.player = player
		self.sprite = player.get_node("AnimatedSprite2D")

	
	func tick_animation(direction: int, is_on_floor: bool):
		if is_on_floor:
			if direction == 0:
				sprite.animation = "idle_with_gun"
			else:
				sprite.animation = "run_with_gun"
		else:
			sprite.animation = "jump_with_gun"

	# Movement
	func _move():
		if Input.is_action_just_pressed("move_left"):
			sprite.flip_h = true
		elif Input.is_action_just_pressed("move_right"):
			sprite.flip_h = false
	
	func _jump(on_floor: bool, delta: float):
		if on_floor and Input.is_action_just_pressed("jump"):
			player.velocity.y = jump_velocity
		#if on_floor:
			#coyote_timer = coyote_time
		#else:
			#coyote_timer -= delta
		#
		#if Input.is_action_just_pressed("jump"):
			#jump_buffer_timer = jump_buffer_time
		#else:
			#jump_buffer_timer -= delta
#
		##if Input.is_action_just_pressed("jump"):
		#if jump_buffer_timer > 0 and (on_floor or coyote_timer > 0):
			#player.velocity.y = jump_velocity
			#jump_buffer_timer = 0  # Consume the buffered jump
			#coyote_timer = 0       # Optional: prevent double jumps
			
	
	func tick(on_floor: bool, delta: float):
		_jump(on_floor, delta)
		_move()
	
	func kill_player() -> void:
		self.player.global_position = Vector2(200, 200)
		self.alive = false
		self.death_time = 0
		self.amo = int(self.amo/2)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * player.speed
	else:
		velocity.x = move_toward(velocity.x, 0, player.speed)
	
	player.tick_animation(direction, is_on_floor())
	player.tick(is_on_floor(), delta)
	
	
	self.player.death_timer += delta
	if self.player.death_timer >= self.player.death_time and !self.player.alive:
		self.global_position = Vector2(-184.0, 88.99691)
		self.player.alive = true
	move_and_slide()

# Methods for Game object
func get_direction():
	if $AnimatedSprite2D.flip_h:
		return -1
	else:
		return 1
