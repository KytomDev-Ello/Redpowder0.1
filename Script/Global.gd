extends Node

@export var Redpowder := 8
@export var RedpowderCapa := 50

@export var Firing := false

func _process(_delta: float) -> void:
	if Redpowder > RedpowderCapa:
		Redpowder = RedpowderCapa
		print("powder capasity reached, cannot add further")
