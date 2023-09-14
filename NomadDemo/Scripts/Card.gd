extends MarginContainer

#Unitinfo = [Name,Type,Class,Requirement,Level,Damage,Description]
#Typeinfo = [Attack, Effect, Spell]

@onready var CardDatabase = preload("res://Data/CardDictionary.tres")
@onready var CardInfo = CardDatabase.DATA[Cardname]
var Cardname = 2
var played = false
const PATH = "res://Art/Sprites/Cards/"

signal to_play(id : Control, t : int)

var white = Color.WHITE
var beige = Color.NAVAJO_WHITE
var brown = Color.SADDLE_BROWN
var orange = Color.SANDY_BROWN

func _ready():
	#print(CardInfo)
	$Area2D.visible = true
	update_card()

func initialize(location):
	position = location

func update_card():
	#USE BOX CONTAINERS
	var CardSize = size
	$Text/Title.text = CardInfo[0]
	$Text/Requirement.text = str(CardInfo[3])
	$Text/Description.text = "[center]"+CardInfo[6]+" [/center]"
	
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
		$CardBG.texture = load(PATH+"Action.png")
	else:
		$CardBG.texture = load(PATH+"Spell.png")
	
	
	if FileAccess.file_exists(PATH+CardInfo[0].replace(" ","")+".png"):
		$CardArt.texture = load(PATH+CardInfo[0].replace(" ","")+".png")
	elif FileAccess.file_exists(PATH+CardInfo[0].replace(" ","")+".jpeg"):
		$CardArt.texture = load(PATH+CardInfo[0].replace(" ","")+".jpeg")
	else:
		$CardArt.texture = load("res://Art/Sprites/icon.svg")
	
	if CardInfo[1] == 0:
		$Text/Title.add_theme_color_override("font_color", brown)
		$Text/Description.add_theme_color_override("default_color", brown)
		$Text/Level.add_theme_color_override("font_color", brown)
		$Text/Requirement.add_theme_color_override("font_color", brown)
		return
	if CardInfo[1] == 1:
		$Text/Title.add_theme_color_override("font_color", orange)
		$Text/Description.add_theme_color_override("default_color", orange)
		$Text/Level.add_theme_color_override("font_color", orange)
		$Text/Requirement.add_theme_color_override("font_color", orange)
		return
	else:
		$Text/Title.add_theme_color_override("font_color", brown)
		$Text/Description.add_theme_color_override("default_color", brown)
		$Text/Level.add_theme_color_override("font_color", brown)
		$Text/Requirement.add_theme_color_override("font_color", brown)
		return

func set_card(n):
	Cardname = n

func get_card():
	return Cardname

func _on_mouse_entered():
	if played:
		return
	self.set_scale(Vector2(1.2,1.2))

func _on_mouse_exited():
	if played:
		return
	self.set_scale(Vector2(1,1))

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			emit_signal("to_play", self, 0)

func set_played():
	self.set_scale(Vector2(1,1))
	played = true

func get_type():
	return CardInfo[1]

func get_damage():
	return CardInfo[5]
