extends Node2D

@onready var cards = preload("res://Card.tscn")
@onready var inHand = [0,0,0,0,0]
@onready var timer = $UI/TimerBar
@export var noOfCards = 8
var turn = 0
var doubleTap = [0,0]
var currenthandcount = [4,4]
var tempo = [4,4]
var battleOver = false
var emptystack = true
var center
signal dealDamagePlayer(dmg : int)
signal dealDamageEnemy(dmg : int)

# Called when the node enters the scene tree for the first time.
func _ready():
	center = $UI/Path/Loc.position
	randomize()
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var wait = rng.randf_range(1.0, 7.0)
	emptystack = true
	print(wait)
	$UI/Flash.visible = true
	$UI.visible = false
	$StartTimer.wait_time = wait
	# Random quickdraw
	# $StartTimer.wait_time = wait
	$StartTimer.start()
	draw_cards()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !battleOver:
		if timer.value == 0:
			end_turn()
			timer.value = 10000
			timer.emit_signal("value_changed")
			begin_turn()
		else:
			timer.value = timer.value-0.1
			timer.emit_signal("value_changed")

# Quickdraw start
func _on_timer_timeout():
	$UI.visible = true
	$UI/FlashTimer.start()
	timer.value = 10000
	return

# Flash screen
func _on_flash_timer_timeout():
	$UI/Flash.visible = 0
	return

func draw_cards():
	if turn == 0:
		var cardWidth = 270
		var startLoc = center
		startLoc.x = startLoc.x - (cardWidth*(tempo[turn])/2.0)
		$UI/Path/Loc.position = startLoc
		for n in tempo[turn]:
			var instance = cards.instantiate()
			var rng = RandomNumberGenerator.new()
			rng.randomize()
			instance.set_card(rng.randi_range(1, noOfCards-1))
			$UI/Hand.add_child(instance)
			instance.connect("to_play", play_card)
			instance.initialize($UI/Path/Loc.position)
			$UI/Path/Loc.position.x += cardWidth
	$UI/Path/Loc.position = center

# Card being played
func play_card(id, t):
	if t == turn:
		var instance = cards.instantiate()
		instance.set_card(id.get_card())
		instance.set_played()
		if !emptystack:
			var under = $UI/Placement.get_child(0)
			under.queue_free()
		else:
			emptystack = false
		$UI/Placement.add_child(instance)
		calculate_card(id)
		id.queue_free()

func end_turn():
	if turn == 0:
		
		for n in $UI/Hand.get_child_count():
			print(str($UI/Hand.get_child(0).get_card()))
			$UI/Hand.get_child(n).queue_free()
		turn = 1
	else:
		turn = 0

func begin_turn():
	currenthandcount[turn] = tempo[turn]
	if turn == 0:
		draw_cards()
	else:
		var instance = cards.instantiate()
		instance.set_card(1)
		add_child(instance)
		play_card(instance, 1)
		

func calculate_card(id):
	var cardType = id.get_type()
	# damage cards
	if cardType == 0:
		if turn == 0:
			#Double tap check
			if doubleTap[turn] == 1:
				emit_signal("dealDamageEnemy",id.get_damage()*2)
				doubleTap[turn] = 0
			else :
				emit_signal("dealDamageEnemy",id.get_damage())
			#Tempo Checks
			if id.get_card() == 7:
				up_tempo(turn)
		if turn == 1:
			if doubleTap[turn] == 1:
				emit_signal("dealDamagePlayer",id.get_damage()*2)
				doubleTap[turn] = 0
			else :
				emit_signal("dealDamagePlayer",id.get_damage())
	
	# effect cards
	if cardType == 1:
		doubleTap[turn] = 1
	
	#Spell cards
	if cardType == 2:
		if turn == 0:
			emit_signal("dealDamagePlayer",id.get_damage())
		if turn == 1:
			emit_signal("dealDamageEnemy",id.get_damage())
	#Debugging
	$UI/Debug.text = "DoubleTap: " + str(doubleTap) + "\nTempo: " + str(tempo)

func _on_enemy_death():
	$UI/Win.visible = true
	battleOver = true

func up_tempo(t):
	tempo[t] += 1

func down_tempo(t):
	tempo[t] -= 1
