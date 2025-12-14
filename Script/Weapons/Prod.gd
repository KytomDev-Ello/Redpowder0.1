extends Sprite2D

@export var charac : CharacterBody2D
@export var dmg : int
@export var speed := 1800
@export var pen : int
@export var knockback : float

var lifeTime := 5
var lifeCount := 0.0

var pasPos : Vector2
var dir := Vector2(1,0)


func _physics_process(delta: float) -> void:
	if lifeCount > lifeTime:
		queue_free()
	else:
		lifeCount += delta
	
	global_position += (dir*delta*speed).rotated(global_rotation)
	if pen <= 0:
		queue_free()


func OnHit(area: Area2D) -> void:
	if "health" in area.get_parent() and area.get_parent() != charac:
		if area.get_parent().health > 0:
			var enim = area.get_parent()
			enim.Damage(dmg,(dir*knockback).rotated(global_rotation))
			pen -= 1
