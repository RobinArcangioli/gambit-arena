extends Node
const Arena = preload("res://scenes/app/arena_page.tscn")
var checks: int = 0
var failures: int = 0
func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:failures += 1;push_error(message)
func _ready() -> void:
	var app = Arena.instantiate();app.save_path = "";add_child(app)
	app.set_process(false);app.set_physics_process(false)
	var sim = app.simulation
	var hero = sim.hero(&"mako");var anne = sim.hero(&"anne")
	hero.place(Vector2.ZERO);anne.place(Vector2(1,0));anne.state.damage(30)
	var presenter = app.action_presenter
	var units: Array = sim.all_units()
	var events: Array[Dictionary] = []
	presenter.present(units,events,0,sim.run_id)
	check(presenter.casting_effects.is_empty(),"no idle mana art")
	for skill in [&"lightning",&"booster"]:
		hero.action.cancel();hero.action.cooldowns.clear()
		check(hero.action.request(skill,anne)>0,"real cast accepted")
		var mana: float = hero.action.mana
		presenter.present(units,events,0.1,sim.run_id)
		check(presenter.casting_effects.size()==1,"one effect per casting hero")
		check(hero.visual.energy_active,"thin silhouette enabled")
		var effect = presenter.casting_effects[hero.combat_id]
		check(effect.motes.size()==8,"fixed eight motes")
		var age: float = effect.age
		var position: Vector3 = effect.motes[3].position
		presenter.present(units,events,0,sim.run_id)
		check(effect.age==age and effect.motes[3].position==position,"pause freezes motes")
		check(hero.action.mana==mana and hero.action.spent==0,"presentation cannot charge mana")
		hero.visual.react_hit()
		check(hero.visual.energy_active and hero.visual.flash_remaining>0,"hit flash coexists with cast rim")
		presenter.present(units,events,0.1,sim.run_id)
		check(presenter.casting_effects[hero.combat_id]==effect and effect.age>age,"reuse nodes and advance accepted time")
		hero.action.cancel();presenter.present(units,events,0,sim.run_id)
		check(presenter.casting_effects.is_empty() and not hero.visual.energy_active,"cancel removes rim and particles immediately")
	hero.action.request(&"lightning",anne)
	presenter.present(units,events,0,sim.run_id)
	hero.action.resolved=true
	presenter.present(units,events,0,sim.run_id)
	check(presenter.casting_effects.is_empty(),"recovery has no casting effect")
	hero.action.cancel();hero.action.cooldowns.clear();hero.action.request(&"lightning",anne)
	presenter.present(units,events,0,sim.run_id)
	presenter.enabled=false;presenter.present(units,events,0,sim.run_id)
	check(presenter.casting_effects.is_empty() and not hero.visual.energy_active,"disabled adapter clears art")
	presenter.enabled=true;presenter.present(units,events,0,sim.run_id,true)
	check(presenter.casting_effects.is_empty(),"terminal combat has no casting art")
	presenter.present(units,events,0,sim.run_id)
	presenter.reset_run(sim.run_id+1)
	check(presenter.casting_effects.is_empty() and not hero.visual.energy_active,"replay clears overlays and nodes")
	app.queue_free();await get_tree().process_frame;await get_tree().process_frame
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))==0,"no orphan nodes")
	var label:=Label.new();label.text="%d controles, %d echecs"%[checks,failures];add_child(label);print(label.text)
