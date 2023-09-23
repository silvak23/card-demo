extends Node3D

@onready var Cards = preload("res://Card.tscn")
@onready var Tempo = preload("res://Tempo.tscn")

@export var noOfCards = 8

var currTurn
var cardsToDraw
#temp Tempo var
@export var playerTempo = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	currTurn = 1
	cardsToDraw = 5
	draw_cards()
	draw_tempo()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$UI/VertContainer/TurnTimerBar.value = $UI/TurnTimer.time_left*10.0
	$Light.rotation.y += delta/4


func draw_cards():
	if currTurn == 0 || 1:
		for n in cardsToDraw:
			var instance = Cards.instantiate()
			var rng = RandomNumberGenerator.new()
			rng.randomize()
			instance.set_card_id(rng.randi_range(1, noOfCards-1))
			$UI/VertContainer/HBoxContainer3/MarginContainer/CardHand.add_child(instance)
			instance.z_index = n
			instance.connect("to_play", play_card)
			instance.layout_mode = 1
			instance.anchors_preset = 8

func draw_tempo():
	if currTurn == 0:
		var instance = Tempo.instantiate()
		$UI/VertContainer/MarginContainer/TempoContainer.add_child(instance)
	elif currTurn == 1:
		for n in playerTempo:
			var instance = Tempo.instantiate()
			$UI/VertContainer/MarginContainer/TempoContainer.add_child(instance)
	else:
		return


func play_card(id, turn):
	#Quickdraw or Player's turn
	if currTurn == 0 || currTurn == turn:
		var tempoArr = $UI/VertContainer/MarginContainer/TempoContainer
		for n in tempoArr.get_child_count():
			#Check for empty tempo slots
			if tempoArr.get_child(n).get_child_count() == 0:
				#Move from hand to tempo slot
				$UI/VertContainer/HBoxContainer3/MarginContainer/CardHand.remove_child(id)
				id.position = Vector2(5,5)
				id.set_played()
				tempoArr.get_child(n).add_child(id)
				id.set_owner(tempoArr.get_child(n))
				return
			else:
				pass
	else:
		return
