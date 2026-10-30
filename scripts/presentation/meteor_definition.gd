extends Resource
## Replaceable artistic settings; impact timing and damage remain in the simulation.
@export var strength:float=1.0
@export var trail_color:Color=Color("e62a0a")
@export var shadow_color:Color=Color("651407")
@export var core_color:Color=Color("ffc15c")
@export var explosion_color:Color=Color("e72c08")
@export var fade:Resource=preload("res://resources/presentation/effects/common_fade.tres")

@export_enum("Flash compact","Onde fracturée","Dôme déchiré") var explosion_variant:int=0

@export_range(0.0,1.0) var explosion_accent_opacity:float=0.72

@export_range(0.0,1.0) var compact_dome_opacity:float=0.83
@export_range(0.5,2.0) var explosion_accent_width:float=1.35

@export_enum("Onde rouge","Onde enflammée","Onde et braises") var impact_fire_style:int=1
