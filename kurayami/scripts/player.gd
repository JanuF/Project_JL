extends CharacterBody2D

@export var speed: float = 300.0
@export var darkness_threshold: float = 0.3
@export var gun_range: float = 1000.0

var is_in_darkness: bool = false

@export var teleport_distance: float = 300.0

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()
	
	if Input.is_action_just_pressed("shoot"):
		shoot()

	calculate_brightness()
	update_teleport_indicator()

	if Input.is_action_just_pressed("teleport"):
		teleport()

func calculate_brightness() -> void:
	var brightness := get_brightness_at(global_position)

	is_in_darkness = brightness <= darkness_threshold

	if is_in_darkness:
		$Sprite2D.modulate = Color(0.5, 0.5, 0.8)
	else:
		$Sprite2D.modulate = Color.WHITE

func get_brightness_at(target_position: Vector2) -> float:
	var brightest: float = 0.0

	for node in get_tree().get_nodes_in_group("lights"):
		var game_light := node as GameLight

		if game_light == null:
			continue

		var brightness: float = get_light_brightness(
			target_position,
			game_light
		)

		brightest = max(brightest, brightness)

	return brightest


func get_light_brightness(
	target_position: Vector2,
	game_light: GameLight
) -> float:
	if not game_light.is_on:
		return 0.0

	var distance: float = target_position.distance_to(
		game_light.global_position
	)

	if distance > game_light.light_radius:
		return 0.0

	var brightness: float = 1.0 - (
		distance / game_light.light_radius
	)

	# Check whether an object blocks this light.
	var space_state := get_world_2d().direct_space_state

	var query := PhysicsRayQueryParameters2D.create(
		target_position,
		game_light.global_position
	)

	# Don't let the ray hit the player or any of the light hitboxes.
	var exclusions: Array[RID] = [self.get_rid()]

	for node in get_tree().get_nodes_in_group("lights"):
		var other_light := node as GameLight

		if other_light != null:
			exclusions.append(other_light.hitbox.get_rid())

	query.exclude = exclusions

	var result := space_state.intersect_ray(query)

	if result:
		return 0.0

	return brightness
	
func teleport() -> void:
	var target := get_global_mouse_position()

	if can_teleport_to(target):
		global_position = target

func can_teleport_to(target: Vector2) -> bool:
	var target_brightness: float = get_brightness_at(target)

	print(
		"PLAYER DARK: ", is_in_darkness,
		" | TARGET BRIGHTNESS: ", target_brightness
	)

	if not is_in_darkness:
		return false

	if global_position.distance_to(target) > teleport_distance:
		return false

	if target_brightness > darkness_threshold:
		return false

	return true

func update_teleport_indicator() -> void:
	var target := get_global_mouse_position()

	$TeleportIndicator.global_position = target

	if can_teleport_to(target):
		$TeleportIndicator.modulate = Color.GREEN
	else:
		$TeleportIndicator.modulate = Color.RED

func shoot() -> void:
	var direction := global_position.direction_to(get_global_mouse_position())
	var end_position := global_position + direction * gun_range

	var space_state := get_world_2d().direct_space_state

	var query := PhysicsRayQueryParameters2D.create(
		global_position,
		end_position
	)

	query.exclude = [self]

	var result := space_state.intersect_ray(query)

	if result:
		var collider = result.collider

		if collider.get_parent().has_method("shot"):
			collider.get_parent().shot()
