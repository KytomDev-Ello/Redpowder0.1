extends CharacterBody2D

@onready var Anim := $EnAnim
@export var hurtAnim := "hurt" 

@export var maxHealth := 4
@export var health := 0

@export var invulnerable := false
@export var knockbackRed := 0 # - % knockback

@export var deathName := "death"

@export var redPerHit := 5

var knockDura := .08

var Delta : float

func _ready() -> void:
	health = maxHealth

func _physics_process(delta: float) -> void:
	#check for over heal
	if health > maxHealth:
		health = maxHealth
	#check if die
	elif  health < 1:
		Death()
	#yes
	Delta = delta
	move_and_slide()

func Death():
	Anim.play("Death")
	await Anim.animation_finished
	queue_free()

func Damage(dmg:int,knockback:Vector2):
	if not invulnerable and health > 0:
		health -= dmg
		var count := 0.0
		Anim.play("hurt")
		while count < knockDura:
			knockbackRed = clamp(knockbackRed,-INF,100)
			velocity = knockback - (knockback * 0.01 * knockbackRed)
			count += .01
			await get_tree().create_timer(.01).timeout
		Anim.play("RESET")	
		velocity = Vector2.ZERO
