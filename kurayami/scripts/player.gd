extends CharacterBody2D

@export var speed: float = 300.0

@export var light: GameLight
@export var light_radius: float = 500.0
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


func get_brightness_at(target_position: Vector2) -> float:
	if not light.is_on:
		return 0.0

	var distance := target_position.distance_to(light.global_position)

	var brightness := 1.0 - (distance / light_radius)
	brightness = clamp(brightness, 0.0, 1.0)

	var space_state := get_world_2d().direct_space_state

	var query := PhysicsRayQueryParameters2D.create(
		target_position,
		light.global_position
	)

	query.exclude = [self, light.hitbox]

	var result := space_state.intersect_ray(query)

	if result:
		print("LIGHT RAY HIT: ", result.collider)
		brightness = 0.0

	return brightness

func calculate_brightness() -> void:
	var brightness := get_brightness_at(global_position)

	is_in_darkness = brightness <= darkness_threshold

	if is_in_darkness:
		$Sprite2D.modulate = Color(0.5, 0.5, 0.8)
	else:
		$Sprite2D.modulate = Color.WHITE

	print(brightness)

func teleport() -> void:
	var target := get_global_mouse_position()

	if can_teleport_to(target):
		global_position = target

func can_teleport_to(target: Vector2) -> bool:
	if not is_in_darkness:
		return false

	if global_position.distance_to(target) > teleport_distance:
		return false
	
	var target_brightness := get_brightness_at(target)

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
