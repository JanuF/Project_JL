extends CharacterBody2D

@export var speed: float = 300.0

@export var light: PointLight2D
@export var light_radius: float = 500.0
@export var darkness_threshold: float = 0.3

var is_in_darkness: bool = false

@export var teleport_distance: float = 300.0

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()

	calculate_brightness()


func calculate_brightness() -> void:
	if Input.is_action_just_pressed("teleport"):
		teleport()
	
	var distance := global_position.distance_to(light.global_position)

	var brightness := 1.0 - (distance / light_radius)
	brightness = clamp(brightness, 0.0, 1.0)
	
	is_in_darkness = brightness <= darkness_threshold
	
	if is_in_darkness:
		$Sprite2D.modulate = Color(0.5, 0.5, 0.8)
	else:
		$Sprite2D.modulate = Color.WHITE
		
	# Check if something is blocking the light
	var space_state := get_world_2d().direct_space_state

	var query := PhysicsRayQueryParameters2D.create(
		global_position,
		light.global_position
	)

	query.exclude = [self]

	var result := space_state.intersect_ray(query)

	if result:
		brightness = 0.0

	print(brightness)

func teleport() -> void:
	if not is_in_darkness:
		return
	
	var target := get_global_mouse_position()
	var distance := global_position.distance_to(target)

	if distance <= teleport_distance:
		global_position = target
