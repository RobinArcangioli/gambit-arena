extends Node
const Lab = preload("res://scenes/debug/skill_icons_lab.tscn")
const Definition = preload("res://scripts/buffs/buff_definition.gd")
const Icons = preload("res://scripts/presentation/skill_icons.gd")
var checks: int = 0
var failures: int = 0
func check(ok: bool, message: String) -> void:
	checks+=1
	if not ok:failures+=1;push_error("Skill icons: "+message)
func settle() -> void:
	await get_tree().process_frame;await get_tree().process_frame
func _ready() -> void:
	get_tree().root.size=Vector2i(540,960)
	var lab=Lab.instantiate();add_child(lab);lab.set_process(false);await settle()
	var mako=lab.simulation.hero(&"mako");var anne=lab.simulation.hero(&"anne")
	var panel=lab.hero_panels[0];var other=lab.hero_panels[1]
	check(Icons.texture(&"heal")!=null and Icons.texture(&"lightning")!=null and Icons.texture(&"booster")!=null,"three provided skills have shared textures")
	check(Icons.texture(&"basic")==null and Icons.texture(&"unknown")==null,"no invented basic or unknown skill icon")
	for i in range(3):
		lab.choose_trial(i);await settle()
		check(panel.cast_icon.visible and panel.cast_icon.texture==Icons.texture(&"lightning"),"lightning cast uses its supplied icon")
		check(other.cast_icon.visible and other.cast_icon.texture==Icons.texture(&"heal"),"Anne heal cast uses supplied icon")
		var edge:float=panel.bars.position.x+panel.bars.bar_width*.5
		check(is_equal_approx(panel.cast_icon.get_rect().end.x,edge),"cast icon stays flush with theoretical right bar edge")
		check(is_equal_approx(lab.hero_panels[3].get_rect().end.y,lab.safe_rect.size.y-12) and lab.hero_panels.all(func(p):return p.size.is_equal_approx(panel.size)),"all four bottom panels have identical sizes")
		check(panel.portrait.hero_id==&"mako" and other.portrait.hero_id==&"anne","hero panels use their corresponding 2D illustration")
		check(panel.buff_row is HBoxContainer,"active buffs stack horizontally")
		var padding:StyleBox=panel.get_theme_stylebox("panel")
		var expected:Vector2=panel.global_position+Vector2(padding.get_content_margin(SIDE_LEFT),padding.get_content_margin(SIDE_TOP)+80)
		check(panel.buff_icons[&"booster"].global_position.is_equal_approx(expected),"buff row starts at bottom-left content padding")
		var anchor:Vector2=panel.cast_icon.position
		mako.action.elapsed=.2;panel.show_actor(mako);mako.action.elapsed=1.8;panel.show_actor(mako)
		check(panel.cast_icon.position==anchor,"cast icon never follows filled fraction")
		check(panel.buff_icons.size()==1 and panel.buff_icons[&"booster"].texture==Icons.texture(&"booster"),"active Booster uses corresponding skill texture")
		check(panel.buff_tray.position.y>panel.bars.position.y+2*(panel.bars.bar_height+panel.bars.bar_gap)+panel.bars.bar_height and panel.get_global_rect().encloses(panel.buff_icons[&"booster"].get_global_rect()),"buff row sits below cast bar and stays inside panel")
		check(panel.get_global_rect().encloses(panel.cast_icon.get_global_rect()),"cast icon is contained in panel")
		check(is_equal_approx(panel.bars.bar_width,171) and lab.overhead.values().all(func(bar):return is_equal_approx(bar.bar_width,29.4)),"panel and overhead bar lengths unchanged")
		check(lab.overhead.values().all(func(bar):return bar.find_children("*","TextureRect",true,false).all(func(icon):return icon.texture==bar.ATTACK_ICON)),"only the normal-attack marker can appear above models")
	lab.choose_trial(1)
	mako.buffs.apply(Definition.create(&"heal",30.0,1.0));mako.buffs.apply(Definition.create(&"lightning",30.0,1.0))
	panel.show_actor(mako);await settle()
	var first:TextureRect=panel.buff_icons[&"booster"];var second:TextureRect=panel.buff_icons[&"heal"];var third:TextureRect=panel.buff_icons[&"lightning"]
	check(panel.buff_icons.size()==3 and is_equal_approx(first.global_position.y,second.global_position.y) and is_equal_approx(second.global_position.y,third.global_position.y),"multiple presentation statuses align on one bottom row")
	check(second.global_position.x>first.get_global_rect().end.x and third.global_position.x>second.get_global_rect().end.x,"multiple statuses stack horizontally without overlap")
	var before:Array=[mako.state.health,mako.action.mana,mako.action.spent,mako.action.elapsed,mako.buffs.snapshot()]
	var icon_id:int=panel.buff_icons[&"booster"].get_instance_id()
	for i in range(20):panel.show_actor(mako)
	check(before==[mako.state.health,mako.action.mana,mako.action.spent,mako.action.elapsed,mako.buffs.snapshot()],"view refresh never advances buffs or gameplay")
	check(panel.buff_icons[&"booster"].get_instance_id()==icon_id,"stable buffs reuse existing UI nodes")
	mako.action.cancel();panel.show_actor(mako)
	check(not panel.cast_icon.visible and panel.buff_row.visible,"cancel removes cast icon without removing active buff")
	mako.buffs.advance(100);panel.show_actor(mako);await settle()
	check(panel.buff_icons.is_empty() and not panel.buff_row.visible,"expired buffs disappear")
	lab.cycle_spell();panel.show_actor(lab.simulation.hero(&"mako"))
	check(panel.cast_icon.texture==Icons.texture(&"booster") and panel.cast_icon.visible,"Booster cast and active buff share same image")
	lab.simulation.hero(&"mako").state.damage(100000);panel.show_actor(lab.simulation.hero(&"mako"))
	check(not panel.cast_icon.visible and panel.buff_icons.is_empty(),"death clears cast and buff icons")
	lab.show_tab("Fiche");await settle()
	var sheet=lab.page
	for i in range(sheet.reference.skills.size()):
		var skill:Dictionary=sheet.reference.skills[i]
		var heading=sheet.skill_panels[i].get_child(0).get_child(0)
		var images:Array=heading.find_children("*","TextureRect",true,false)
		check(images.size()==(0 if skill.id==&"basic" else 1),"reference skill heading has expected icon")
		if not images.is_empty():check(images[0].texture==Icons.texture(skill.id),"reference heading shares catalogue texture")
	lab.show_tab("Gambits");await settle()
	var editor=lab.page.editor;var picker=editor.controls[0].skill
	for i in range(picker.item_count):
		var id:StringName=editor.Orders.PROFILES[&"mako"].abilities[i]
		check(picker.get_item_icon(i)==Icons.texture(id),"gambit options use skill catalogue")
	var saved:String=FileAccess.get_file_as_string(lab.save_path)
	lab.choose_trial(2);lab.choose_trial(0);await settle()
	check(saved==FileAccess.get_file_as_string(lab.save_path),"visual style changes never rewrite gambit configuration")
	lab.show_tab("Combat");lab.choose_trial(0);lab._snapshot()
	for resolution in [Vector2i(540,960),Vector2i(540,1170),Vector2i(360,640)]:
		get_tree().root.size=resolution
		lab.safe_area_override=Rect2(8,24,resolution.x-16,resolution.y-44)
		lab._update_layout();await settle();lab._present()
		check(is_equal_approx(lab.hero_panels[3].get_global_rect().end.y,lab.safe_area_override.end.y-12) and lab.hero_panels.all(func(p):return p.size.is_equal_approx(panel.size)),"equal-size hero grid stays at safe-area bottom")
		check(lab.hero_panels.all(func(p):return lab.safe_area_override.encloses(p.get_global_rect())),"all panels fit safe area")
		check(panel.get_global_rect().encloses(panel.cast_icon.get_global_rect()) and panel.get_global_rect().encloses(panel.buff_icons[&"booster"].get_global_rect()),"cast and buff icons stay inside hero panel at all portrait sizes")
	lab.queue_free();await settle()
	var summary:="%s : %d controles, %d echecs"%["OK" if failures==0 else "ECHEC",checks,failures]
	var label:=Label.new();label.text=summary;add_child(label);print(summary)
