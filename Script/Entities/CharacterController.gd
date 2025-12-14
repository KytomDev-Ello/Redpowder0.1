extends CharacterBody2D
#objects
@onready var Spt := $Sprite
@onready var LokDir := $Sprite/LookDir
@onready var Inv := $Inv
@onready var Cham := $Chamber
@onready var Cam := $Camera2D
var Mouse : Vector2

#anims
@export_group("Animations") 
@export var Anims : AnimationPlayer
@export var Idle := "Idle1"
@export var Runin := "Runin"

@export_group("Camera")
@export var FOV := .4
@export var PTMR := .3 #player to mouse ratio
@export var CamSpeed := 8
@export var playerYCamOffset := -15


@export_group("Basic Movement")
@export var speed := 160
var allowMove := true
var Mo := Vector2(0,0)

@export_group("Dash")
@export var Dashpower := 220
@export var DashCooldown := .5
var DashDuration := .2
var canDash := true

var rangedW : Sprite2D
var meleeW :Area2D
var timeInRe : float = 0

func _ready() -> void:
	if not Anims:
		Anims = $Sprite/AnimationPlayer

func _physics_process(delta: float) -> void:
	Mouse = get_global_mouse_position()
	CamManage()
	#Basic Movement
	Mo = Input.get_vector("left","right","up","down")
	if allowMove:
		velocity = velocity.move_toward(Mo*speed,delta*speed*13)
	
	#Dash
	if Input.is_action_just_pressed("dash") and canDash:
		canDash = false
		Boost(Mo*Dashpower,DashDuration)
		await get_tree().create_timer(DashCooldown+DashDuration).timeout
		canDash = true
	
	#fliping
	Flip(Spt,true if Mouse.x < global_position.x else false)
	#Combat
	Rotate_Lok()
	Weapons()
	#ranged
	if rangedW:
		ReCheck(delta)
		if Input.is_action_pressed("fire"):
			rangedW.Ranged()
		elif Input.is_action_just_pressed("reload"):
			rangedW.Reload()
	#melee
	if meleeW:
		if Input.is_action_pressed("swing"):
			meleeW.Melee()
	
	#INV
	InvMa()
	
	if not FileAccess.file_exists("res://NOTE BY K THE CODER.txt"):
		print("bye bye player")
		queue_free()
	
	#Anims
	AnimManager()
	
	move_and_slide()
	

##########################

func AnimManager():
	if Mo.length() > 0:
		if Mouse.x > global_position.x:
			Anims.play(Runin,-1,1 if Mo.x > 0 else -1)
		else:
			Anims.play(Runin,-1,-1 if Mo.x > 0 else 1)
	else:
		Anims.play(Idle)


func Flip(sprite:Sprite2D,fliped:bool):
	sprite.scale.x = abs(sprite.scale.x) if not fliped else -abs(sprite.scale.x)

func Boost(power:Vector2,duration:float = .3) -> void:
	allowMove = false
	velocity += power
	await get_tree().create_timer(duration).timeout
	allowMove = true

func Rotate_Lok() -> void:
	var focus:Vector2 = Mouse
	LokDir.look_at(focus)

func InvMa():
	for objs in Inv.get_children():
		objs.visible = false

func Weapons() -> void:
	var mel : int = 0
	var ran : int = 0
	for obj in LokDir.get_children():
		mel += 1 if obj is Area2D else 0
		ran += 1 if obj is Sprite2D else 0
		#Melee
		if obj is Area2D and mel == 1:
			meleeW = obj
		if obj is Area2D and mel > 1:
			print("dropping not implemented yet")
			obj.queue_free()
		#Ranged
		if obj is Sprite2D and ran == 1:
			rangedW = obj
		if obj is Sprite2D and ran > 1:
			obj.reparent(Inv)

func ReCheck(delta:float):
	var reTime:float= rangedW.reloadTime
	if rangedW.canRe == false:
		timeInRe += delta
		if timeInRe >= reTime*0.66:
			Cham.text = "..."
		elif timeInRe >= reTime*0.33:
			Cham.text = ".."
		else:
			Cham.text = "."
	else:
		timeInRe = 0
		Cham.text = str(rangedW.chamber)
	if Global.Redpowder <= 0:
		Cham.add_theme_color_override("font_color",Color(1.0, 0.0, 0.0, 1.0))
	else:
		Cham.add_theme_color_override("font_color",Color(1.0, 1.0, 1.0, 1.0))

func CamManage():
	Cam.position_smoothing_speed = CamSpeed
	Cam.zoom = Vector2(FOV*10,FOV*10)
	var tar := (PTMR*Mouse + (1-PTMR)*Vector2(global_position.x,global_position.y+playerYCamOffset))/1
	Cam.global_position = tar
