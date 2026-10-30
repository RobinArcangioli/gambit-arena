extends Resource
## Shared artistic settings; menu behavior, combat and hero values are independent.
@export var backdrop:Color=Color("10182fb8")
@export var menu_icon:Texture2D=preload("res://assets/ui/combat_menu_lines.svg")
@export_enum("Filets fondus","Losange central","Bleu et or") var separator:int=1
@export var gold:Color=Color("eac174")

@export var frame:Color=Color("a68349")
@export var title:Color=Color("ffd16a")
@export var text:Color=Color("fff2d4")
@export var muted:Color=Color("8b9bb5")
@export var stat_text:Color=Color("e3e9f5")
@export var outline:Color=Color("173a70")
@export var icon_fill:Color=Color("10182f")
@export var modal:Color=Color("10182ff5")
@export var shade:Color=Color(.02,.03,.07,.48)
