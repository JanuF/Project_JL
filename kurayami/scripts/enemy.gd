class_name Enemy
extends CharacterBody2D

@export var health: int = 3
@export var speed: float = 100.0

var player: CharacterBody2D

var last_known_position: Vector2
var has_last_known_position: bool = false


func _physics_process(_delta: float) -> void:
	if player == null:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if can_see_player():
		last_known_position = player.global_position
		has_last_known_position = true

		var direction: Vector2 = global_position.direction_to(
			player.global_position
		)
		velocity = direction * speed

	elif has_last_known_position:
		var direction: Vector2 = global_position.direction_to(
			last_known_position
		)
		velocity = direction * speed

		if global_position.distance_to(last_known_position) < 10.0:
			has_last_known_position = false
			velocity = Vector2.ZERO

	else:
		velocity = Vector2.ZERO

	move_and_slide()

func can_see_player() -> bool:
	if player == null:
		return false

	# Player is hidden by darkness.
	if player.is_in_darkness:
		return false

	var space_state := get_world_2d().direct_space_state

	var query := PhysicsRayQueryParameters2D.create(
		global_position,
		player.global_position
	)

	# Don't let the ray immediately hit the enemy itself.
	query.exclude = [self.get_rid()]

	var result := space_state.intersect_ray(query)

	if result.is_empty():
		return false

	# The first thing the ray hits must be the player.
	return result.collider == player


func shot() -> void:
	health -= 1

	print("Enemy hit! Health: ", health)

	if health <= 0:
		queue_free()


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		print("PLAYER DETECTED")


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		print("PLAYER LOST")
