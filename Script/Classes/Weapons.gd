extends Node
class_name	Weapons

#Melee
var CanAtk := true
var Combo := 0
var ComboDura := .1
var CurTick : float
var tick : float

func Melee(Anim:AnimationPlayer,AtkAnims:Array,atkDura:float):
	CurTick = Time.get_ticks_msec()*1000
	tick = CurTick if tick else tick
	if CanAtk:
		CanAtk = false
		Combo = 0 if abs(CurTick-tick) >= ComboDura+atkDura or Combo >= len(AtkAnims)-1 else Combo
		Anim.play(AtkAnims[Combo])
		Combo += 1
		tick = Time.get_ticks_msec() * 1000
		await get_tree().create_timer(atkDura).timeout
		CanAtk = true
		
