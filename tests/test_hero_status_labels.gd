extends Node
var failures: int = 0
var checks: int = 0
func verify(ok: bool, message: String) -> void:
	checks+=1
	if not ok:failures+=1;push_error(message)
func _ready() -> void:call_deferred("run")
func run() -> void:
	get_tree().root.size=Vector2i(540,960)
	var lab=load("res://scenes/debug/neon_bars_lab.tscn").instantiate();add_child(lab)
	lab.set_process(false);lab.set_physics_process(false)
	await get_tree().process_frame;await get_tree().process_frame
	var panel=lab.hero_panels[0];var mako=lab.simulation.hero(&"mako")
	verify(panel.health_text.text=="130 / 180","PV actuels et maximums")
	verify(panel.mana_text.text=="36 / 60","mana actuelle et maximum")
	verify(panel.cast_text.text=="Foudre : 0,8s" and panel.cast_text.visible,"nom et temps restant")
	verify(panel.health_text.get_theme_color("font_color")==Color.WHITE and panel.mana_text.get_theme_color("font_color")==Color.WHITE and panel.cast_text.get_theme_color("font_color")==Color.WHITE,"trois textes blancs")
	verify(panel.bars.segments==10,"dix segments dans les panneaux")
	for bar in lab.overhead.values():verify(bar.segments==0 and is_equal_approx(bar.bar_width,29.4),"barres monde inchangées")
	verify(is_equal_approx(panel.bars.bar_width,171),"longueur panneau conservée")
	verify(panel.health_text.get_rect().end.y<panel.bars.position.y,"texte PV au-dessus de la barre")
	verify(panel.mana_text.position.y>panel.bars.position.y+panel.bars.bar_height,"texte mana sous la barre PV")
	verify(panel.cast_text.position.y>panel.bars.position.y+panel.bars.bar_height+panel.bars.bar_gap+panel.bars.bar_height,"texte de sort sous la barre mana")
	var script=load("res://scripts/presentation/hero_status_panel.gd")
	verify(is_equal_approx(script.remaining_cast_seconds(1.5,{}),1.5),"compte à rebours normal")
	verify(is_equal_approx(script.remaining_cast_seconds(1.5,{&"booster":{"remaining":60.0,"time_multiplier":1.3}}),1.5/1.3),"compte à rebours accéléré")
	verify(is_equal_approx(script.remaining_cast_seconds(1.5,{&"booster":{"remaining":0.5,"time_multiplier":1.3}}),1.35),"expiration du buff pendant le cast")
	mako.action.cancel();panel.show_actor(mako)
	verify(not panel.cast_text.visible and not panel.bars.casting,"texte et barre disparaissent à l'annulation")
	mako.action.mana=19.9;panel.show_actor(mako);verify(panel.mana_text.text=="19 / 60","mana affichée en entier")
	verify(is_equal_approx(panel.bars.bar_height,2.2) and is_equal_approx(panel.bars.glow_strength,.30),"panneaux Lumineux")
	for bar in lab.overhead.values():verify(is_equal_approx(bar.bar_height,1.25) and is_equal_approx(bar.glow_strength,.22),"barres flottantes B préservées")
	mako.action.mana=60
	verify(mako.action.request(&"lightning",lab.simulation.hero(&"anne"))>0,"fixture Foudre acceptée")
	mako.action.elapsed=.5;panel.show_actor(mako)
	verify(panel.cast_text.text=="Foudre : 1,5s","nom Foudre et temps normal")
	var definition=load("res://scripts/buffs/buff_definition.gd")
	mako.buffs.apply(definition.create(&"booster",60,1.3));panel.show_actor(mako)
	verify(panel.cast_text.text=="Foudre : 1,2s","compte à rebours réel avec Booster")
	mako.buffs.clear();mako.buffs.apply(definition.create(&"short_boost",.5,1.3));panel.show_actor(mako)
	verify(panel.cast_text.text=="Foudre : 1,4s","temps affiché après expiration pendant le cast")
	for i in range(30):panel.show_actor(mako)
	verify(mako.action.spent==0 and is_equal_approx(mako.action.elapsed,.5),"rafraîchir le panneau ne dépense rien et n'avance pas le sort")
	lab.queue_free();await get_tree().process_frame;await get_tree().process_frame
	verify(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))==0,"aucun nœud orphelin")
	var summary:String="%s : %d controles, %d echecs"%["OK" if failures==0 else "ECHEC",checks,failures];print(summary)
	var label:=Label.new();label.text=summary;add_child(label)
