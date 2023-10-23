extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite2D = $AnimatedSprite2D

func _physics_process(delta):
	_apply_gravity(delta)
	handle_jump()
	
	var input_axis = Input.get_axis("ui_left", "ui_right")
	if input_axis:
		velocity.x = input_axis * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	update_animations(input_axis)
	move_and_slide()

func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func handle_jump():
	if is_on_floor():
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = JUMP_VELOCITY
	else:
		if Input.is_action_just_pressed("ui_accept") and velocity.y < JUMP_VELOCITY / 4:
			velocity.y = JUMP_VELOCITY / 4

func update_animations(input_axis):
	if input_axis != 0:
		animated_sprite2D.flip_h = (input_axis < 0)
		animated_sprite2D.play("running")
	else:
		animated_sprite2D.play("idle")
	if not is_on_floor():
		animated_sprite2D.play("jump")
		
