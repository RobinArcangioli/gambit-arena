extends "res://scripts/ui/nassau_team_lab.gd"
## The real product gesture and formation, with memory-only saves.
func _ready() -> void:
	super._ready()
	get_window().title="Gambit Arena · TEAM-002 · Ordre de l’équipe / cyan"
	for button in toolbar.get_children():
		button.custom_minimum_size=Vector2(78,44);button.add_theme_font_size_override("font_size",11)
	var compare:=Button.new();compare.text="Sorts / Attaque";compare.add_theme_font_size_override("font_size",11)
	compare.custom_minimum_size=Vector2(102,44);toolbar.add_child(compare)
	compare.pressed.connect(show_action_bars)

func show_action_bars() -> void:
	await show_preview("Formation")
	if combat==null:return
	var sim=combat.simulation
	for actor in sim.heroes:actor.action.cancel()
	var mako=sim.hero(&"mako");var anne=sim.hero(&"anne");var nassau=sim.hero(&"nassau")
	mako.place(Vector2(-1.5,0));anne.place(Vector2(0,-1.5));nassau.place(Vector2(.5,-1.0))
	anne.state.damage(30)
	mako.action.request(&"lightning",anne);mako.action.elapsed=1.1
	anne.action.request(&"heal",anne);anne.action.elapsed=.9
	nassau.action.request(&"basic",anne);nassau.action.advance(.8,false,.8)
	combat._present()
