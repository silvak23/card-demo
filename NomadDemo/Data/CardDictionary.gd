extends Resource
class_name CardDictionary

#Unitinfo = [Name,Type,Class,Requirement,Level,Damage,Description]
#Typeinfo = [Attack, Effect, Spell]
enum {Default, Shot, DoubleTap, Heal, Bash, Maul, Devastate, Blitz, Cleave}
enum {Action, Effect, Spell}

const DATA = {
	Default : 
		["Default",Action,0,0,0,0,"Description of the card goes here"],
	Shot :
		["Shot",Action,0,0,0,1,"Shoot a target for 1 damage"],
	DoubleTap :
		["Double Tap",Effect,0,0,1,0,"Your next attack card is used twice"],
	Heal :
		["Heal",Spell,0,0,1,-1, "Heal yourself for 1 hit point(s)"],
	Bash :
		["Bash",Action,0,0,1,1, "Deal 1 damage"],
	Maul :
		["Maul",Action,0,0,1,2, "Deal 2 damage"],
	Devastate :
		["Devastate",Action,0,0,1,5, "Deal 5 damage"],
	Blitz :
		["Blitz",Action,0,0,1,2, "Deal 2 damage\nGain 1 [url=\"tempo\"][i][color=blue]tempo[/color][/i][/url]"],
	Cleave :
		["Cleave",Action,0,0,1,2, "Deal 2 damage to all enemies"],
}
