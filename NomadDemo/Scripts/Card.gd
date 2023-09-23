extends Control

@onready var CardDatabase = preload("res://Data/CardDictionary.tres")
@onready var KeywordTooltip = preload("res://Data/KeywordTooltips.tres")
@onready var CardInfo = CardDatabase.DATA[cardID]
const CARD_ART_PATH = "res://Art/Sprites/Cards/"

var cardID = 1
var isPlayed = false
var toolTips = ["tempo"]
var z = 0

signal to_play(id : Control, turn : int)

var white = Color.WHITE
var beige = Color.NAVAJO_WHITE
var brown = Color.SADDLE_BROWN
var orange = Color.SANDY_BROWN

# Called when the node enters the scene tree for the first time.
func _ready():
	$Control/Text/HBoxContainer2/CardArt/Popup.visible = false
	update_card()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# Changes the words and art displayed on the card using its ID
func update_card():
	z = z_index
	$Control/Text/HBoxContainer/Title.text = CardInfo[0]
	$Control/Text/HBoxContainer2/Requirement.text = str(CardInfo[3])
	$Control/Text/MarginContainer/Description.text = "[center]"+CardInfo[6]+" [/center]"
	
	# Card Level
#	if CardInfo[4] == 1:
#		$Text/Level.text = "I"
#	elif CardInfo[4] == 2:
#		$Text/Level.text = "II"
#	elif CardInfo[4] == 3:
#		$Text/Level.text = "III"
#	elif CardInfo[4] == 4:
#		$Text/Level.text = "IV"
#	elif CardInfo[4] == 5:
#		$Text/Level.text = "V"
#	else:
#		$Text/Level.text = "0"
	#Sprite
	
	if CardInfo[2] == 0:
		$Control/Text/HBoxContainer2/CardArt.texture = load(CARD_ART_PATH+"Action.png")
	else:
		$Control/Text/HBoxContainer2/CardArt.texture = load(CARD_ART_PATH+"Spell.png")
	
	
	if FileAccess.file_exists(CARD_ART_PATH+CardInfo[0].replace(" ","")+".png"):
		$Control/Text/HBoxContainer2/CardArt.texture = load(CARD_ART_PATH+CardInfo[0].replace(" ","")+".png")
	elif FileAccess.file_exists(CARD_ART_PATH+CardInfo[0].replace(" ","")+".jpeg"):
		$Control/Text/HBoxContainer2/CardArt.texture = load(CARD_ART_PATH+CardInfo[0].replace(" ","")+".jpeg")
	else:
		$Control/Text/HBoxContainer2/CardArt.texture = load("res://Art/Sprites/icon.svg")
	
	if CardInfo[1] == 0:
		$Control/Text/HBoxContainer/Title.add_theme_color_override("font_color", brown)
		$Control/Text/MarginContainer/Description.add_theme_color_override("default_color", brown)
		$Control/Text/Level.add_theme_color_override("font_color", brown)
		$Control/Text/HBoxContainer2/Requirement.add_theme_color_override("font_color", brown)
		return
	if CardInfo[1] == 1:
		$Control/Text/HBoxContainer/Title.add_theme_color_override("font_color", orange)
		$Control/Text/MarginContainer/Description.add_theme_color_override("default_color", orange)
		$Control/Text/Level.add_theme_color_override("font_color", orange)
		$Control/Text/HBoxContainer2/Requirement.add_theme_color_override("font_color", orange)
		return
	else:
		$Control/Text/HBoxContainer/Title.add_theme_color_override("font_color", brown)
		$Control/Text/MarginContainer/Description.add_theme_color_override("default_color", brown)
		$Control/Text/Level.add_theme_color_override("font_color", brown)
		$Control/Text/HBoxContainer2/Requirement.add_theme_color_override("font_color", brown)
		return


func _on_mouse_entered():
	if isPlayed:
		return
	z_index = 20
	self.set_scale(Vector2(1.1,1.1))

func _on_mouse_exited():
	if isPlayed:
		return
	z_index = z
	self.set_scale(Vector2(1,1))


func set_played():
	self.set_scale(Vector2(1,1))
	isPlayed = true

func set_card_id(n):
	cardID = n

func get_card():
	return cardID

func get_type():
	return CardInfo[1]

func get_damage():
	return CardInfo[5]

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			emit_signal("to_play", self, 1)


func _show_tooltip(r):
	$Control/Text/HBoxContainer2/CardArt/Popup.visible = 1
	print(r)
	var tip = KeywordTooltip.DATA[toolTips.find(r)]
	$Control/Text/HBoxContainer2/CardArt/Popup/PopupText.text = "[u]"+tip[0]+"[/u]\n"+tip[1]
	return

func _hide_tooltip(_r):
	$Control/Text/HBoxContainer2/CardArt/Popup.visible = 0
	return
