extends Sprite2D

@export var hp_current = 10
@export var hp_max = 10
var doubletap = false
var turn = false

signal end_turn
signal death
# Called when the node enters the scene tree for the first time.
func _ready():
	$HPbar.max_value = hp_max
	$HPbar.value = hp_current


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$HPbar.value = hp_current

func start_turn():
	turn = true

func turn_end():
	emit_signal("end_turn")

func _on_battle_main_deal_damage_player(dmg):
	hp_current -= dmg
	if hp_current <= 0:
		emit_signal("death")
	if hp_current > hp_max:
		hp_current = hp_max
	$HPbar.emit_signal("value_changed")
