extends CanvasLayer

@onready var base := $Base
@onready var RedpowderCount = $Base/RedpowderDisplay/MarginContainer/HBoxContainer/Label

var redpowder : int

func _process(_delta: float) -> void:
	redpowder = Global.Redpowder
	if redpowder > 1000000:
		RedpowderCount.text = "too much damit"
	else:
		RedpowderCount.text = str(redpowder)
