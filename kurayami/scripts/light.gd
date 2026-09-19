class_name GameLight
extends Node2D

var is_on: bool = true
@onready var hitbox: StaticBody2D = $StaticBody2D

func shot() -> void:
	print("LIGHT SHOT")
	is_on = false
	print("is_on: ", is_on)

	$PointLight2D.enabled = false
	$Sprite2D.modulate = Color.DIM_GRAY
