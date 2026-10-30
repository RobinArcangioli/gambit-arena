extends "res://scripts/ui/area_lab.gd"

const COMPACT_NAMES=["A · Onde rouge","B · Enflammée","C · Avec braises"]
var variant:int=2
func _ready() -> void:
	chooser=func():return &"colisee_solaire"
	super._ready()
	get_window().title="Gambit Arena · Météore · Flash compact · ondes de feu"
	var row:=HBoxContainer.new();row.position=Vector2(16,652);row.z_index=40;add_child(row)
	for i in range(3):
		var button:=Button.new();button.text=COMPACT_NAMES[i]
		button.add_theme_font_size_override("font_size",12);button.custom_minimum_size=Vector2(132,40)
		row.add_child(button);button.pressed.connect(select_variant.bind(i))
func select_variant(value:int) -> void:
	variant=value
	var definition:Resource=preload("res://resources/presentation/effects/meteor.tres").duplicate()
	definition.explosion_variant=0
	definition.compact_dome_opacity=.78
	definition.explosion_accent_opacity=.90
	definition.explosion_accent_width=1.50
	definition.impact_fire_style=value
	action_presenter.meteor.definition=definition
	action_presenter.meteor.explosion_variant=0
	select_scenario(scenario)
func _show_target() -> void:
	if info==null:return
	var anne=simulation.hero(&"anne")
	info.text="Météore · 3 s incantation → 0,77 s chute → 1 s explosion\n%s · PM %d · recharge %.1f s"%["Centre verrouillé" if anne.action.casting() else "Météore en vol" if not simulation.projectiles.pending.is_empty() else "Évaluation des gambits",floori(anne.action.mana),anne.action.remaining(&"meteor")]
	info.text+="\n"+COMPACT_NAMES[variant]+" · base Rouge accentué"
