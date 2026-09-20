@tool
class_name GameLight
extends Node2D

const VISUAL_RADIUS_MULTIPLIER: float = 5.0

@export_range(100.0, 5000.0, 100.0) var light_radius: float = 500.0:
	set(value):
		light_radius = value
		_update_visual_radius()

@onready var hitbox: StaticBody2D = $StaticBody2D

var is_on: bool = true


func _ready() -> void:
	if not Engine.is_editor_hint():
		add_to_group("lights")

	_update_visual_radius()


func _update_visual_radius() -> void:
	var point_light := get_node_or_null("PointLight2D") as PointLight2D

	if point_light == null or point_light.texture == null:
		return

	var gradient_texture := point_light.texture as GradientTexture2D

	if gradient_texture == null:
		return

	var base_radius: float = float(min(
		gradient_texture.width,
		gradient_texture.height
	)) * 0.5

	if base_radius <= 0.0:
		return

	var scale_factor: float = (
		light_radius / base_radius
	) * VISUAL_RADIUS_MULTIPLIER

	point_light.scale = Vector2.ONE * scale_factor


func shot() -> void:
	if Engine.is_editor_hint():
		return

	is_on = false
	$PointLight2D.enabled = false
	$Sprite2D.modulate = Color.DIM_GRAY
