class_name Man extends CharacterBody2D

const JUMP_VELOCITY = -400.0

signal player_died

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func died():
	player_died.emit()

func _input(event):
	if event.is_action("ui_jump"):
		velocity.y = JUMP_VELOCITY

func _physics_process(delta):
	move_and_collide(velocity * delta)

	if !is_on_floor():
		velocity.y += gravity * delta
