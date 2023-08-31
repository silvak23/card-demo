extends MarginContainer

#Unitinfo = [Name,Type,Class,Requirement,Level,Damage,Description,]
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
	print(CardInfo)
	update_card()

func initialize(location):
	position = location

func update_card():
	#USE BOX CONTAINERS
	var CardSize = size
	$Text/Title.text = CardInfo[0]
	$Text/Requirement.text = str(CardInfo[3])
	$Text/Description.text = CardInfo[6]
	
	# Card Level
	if CardInfo[4] == 1:
		$Text/Level.text = "I"
	elif CardInfo[4] == 2:
		$Text/Level.text = "II"
	elif CardInfo[4] == 3:
		$Text/Level.text = "III"
	elif CardInfo[4] == 4:
		$Text/Level.text = "IV"
	elif CardInfo[4] == 5:
		$Text/Level.text = "V"
	else:
		$Text/Level.text = "0"
	#Sprite
	if FileAccess.file_exists(PATH+CardInfo[0].replace(" ","")+".png"):
		$Border/CardArt.texture = load(PATH+CardInfo[0].replace(" ","")+".png")
	else:
		$Border/CardArt.texture = load("res://Art/Sprites/icon.svg")
	
	if CardInfo[1] == 0:
		$Border.color = beige
		$Border/Background.color = white
		$Border/BorderBar1.color = beige
		$Border/BorderBar2.color = beige
		$Border/LevelBox.color = beige
		$Border/RequirementBox.color = beige
		$Text/Title.add_theme_color_override("font_color", brown)
		$Text/Description.add_theme_color_override("default_color", brown)
		$Text/Level.add_theme_color_override("font_color", brown)
		$Text/Requirement.add_theme_color_override("font_color", brown)
		return
	if CardInfo[1] == 1:
		$Border.color = white
		$Border/Background.color = brown
		$Border/BorderBar1.color = white
		$Border/BorderBar2.color = white
		$Border/LevelBox.color = white
		$Border/RequirementBox.color = white
		$Text/Title.add_theme_color_override("font_color", beige)
		$Text/Description.add_theme_color_override("default_color", beige)
		$Text/Level.add_theme_color_override("font_color", brown)
		$Text/Requirement.add_theme_color_override("font_color", brown)
		return
	else:
		#Set spell theme
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
