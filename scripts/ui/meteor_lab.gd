extends "res://scripts/ui/area_lab.gd"
var variant:int=2
func _ready() -> void:
	chooser=func():return &"colisee_solaire"
	super._ready()
	get_window().title="Gambit Arena · Météore · Traînée et explosion"
	var row:=HBoxContainer.new();row.position=Vector2(16,652);row.z_index=40;add_child(row)
	for i in range(3):
		var button:=Button.new();button.text=["A · Discret","B · Équilibré","C · Intense"][i]
		button.add_theme_font_size_override("font_size",13);button.custom_minimum_size=Vector2(132,40)
		row.add_child(button);button.pressed.connect(select_variant.bind(i))
func select_variant(value:int) -> void:
	variant=value;action_presenter.meteor.strength=[.65,1.0,1.35][value]/1.35;select_scenario(scenario)
func _show_target() -> void:
	if info==null:return
	var anne=simulation.hero(&"anne")
	info.text="Météore · 3 s incantation → 1 s chute → 1 s explosion\n%s · PM %d · recharge %.1f s"%["Centre verrouillé" if anne.action.casting() else "Météore en vol" if not simulation.projectiles.pending.is_empty() else "Évaluation des gambits",floori(anne.action.mana),anne.action.remaining(&"meteor")]
