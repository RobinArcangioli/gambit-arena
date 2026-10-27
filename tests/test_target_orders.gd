extends Node
const Criteria=preload("res://scripts/gambits/target_criteria.gd")
const Orders=preload("res://scripts/gambits/orders.gd")
var checks: int=0
var failures: int=0
func check(ok: bool, message: String) -> void:
	checks+=1
	if not ok:failures+=1;push_error("TargetOrders: "+message)
func row(id: int, hp: int, maximum: int, x: float, slot: int=-1) -> Dictionary:
	return {"id":id,"team_slot":slot,"health":hp,"max_health":maximum,"position":Vector2(x,0)}
func fixture() -> Dictionary:
	return {"key":&"mako","source":row(1,100,180,0,0),"allies":[row(2,40,140,2,1)],"enemies":[row(3,80,100,1),row(4,120,300,5)],"mana":60.0,"abilities":[&"basic",&"lightning"],"cooldowns":{}}
func order(criterion: String, skill: String="basic") -> Dictionary:
	return {"enabled":true,"criterion":criterion,"skill":skill}
func _ready() -> void:
	check(Criteria.IDS.size()==11 and Criteria.label(&"self")=="Soi-même","eleven named catalogue entries")
	for hero in [&"anne",&"mako"]:
		for id in Criteria.IDS:
			for skill in Orders.PROFILES[hero].abilities:
				check(Orders.valid_order(order(String(id),String(skill)),hero),"all criterion/capability pairs allowed")
	var expected: Dictionary={&"self":1,&"ally_roster":1,&"ally_hp_lt_90":2,&"ally_hp_lt_70":2,&"ally_hp_lt_50":2,&"ally_hp_lt_30":2,&"ally_hp_lt_10":-1,&"enemy_hp_max":4,&"enemy_hp_min":3,&"enemy_near":3,&"enemy_far":4}
	var view: Dictionary=fixture()
	for id in Criteria.IDS:
		var selected: Dictionary=Criteria.choose(id,view)
		check(selected.get("id",-1)==expected[id],"criterion resolves exact fixture target by stable ID")
		view.enemies.reverse();view.allies.reverse()
		check(Criteria.choose(id,view).get("id",-1)==expected[id],"result independent of array iteration")
	for limit in [90,70,50,30,10]:
		view=fixture();view.source.health=180;view.allies=[row(2,limit,100,2)]
		check(Criteria.choose(StringName("ally_hp_lt_%d"%limit),view).is_empty(),"threshold equality excluded")
		view.allies[0].health=limit-1
		check(Criteria.choose(StringName("ally_hp_lt_%d"%limit),view).id==2,"strictly below threshold included")
	view=fixture();view.source.health=10
	check(Criteria.choose(&"ally_hp_lt_50",view).id==1,"ally includes wounded source")
	view.source=row(1,20,100,0);view.allies=[row(2,40,200,2)]
	check(Criteria.choose(&"ally_hp_lt_50",view).id==1,"percentage tie uses shorter distance")
	view.source.health=100;view.allies=[row(8,20,100,-2),row(7,40,200,2)]
	check(Criteria.choose(&"ally_hp_lt_50",view).id==7,"ratio and distance tie uses stable id")
	view.enemies=[row(8,80,100,-2),row(7,80,200,2)]
	for id in [&"enemy_hp_max",&"enemy_hp_min",&"enemy_near",&"enemy_far"]:check(Criteria.choose(id,view).id==7,"enemy ties deterministic")
	view=fixture();var selected: Dictionary=Criteria.choose(&"enemy_near",view);selected.health=0
	check(view.enemies[0].health==80,"selected snapshot detached")
	view.source.health=0;check(Criteria.choose(&"enemy_near",view).is_empty(),"dead source cannot choose")
	view=fixture();view.enemies[0].health=0;check(Criteria.choose(&"enemy_near",view).id==4,"dead targets ignored")
	view=fixture();view.enemies=[];check(Criteria.choose(&"enemy_far",view).is_empty(),"empty pool has no replacement target")
	check(Criteria.choose(&"unknown",fixture()).is_empty(),"unknown criterion rejected")
	view=fixture();view.key=&"anne";view.abilities=[&"basic",&"heal"];view.enemies[0].health=100
	var decision: Dictionary=Orders.evaluate([order("enemy_near","heal"),order("enemy_near")],view)
	check(decision.skill=="basic" and decision.target_id==3 and decision.rule_index==1,"heal on full chosen target skips order without choosing another enemy")
	check(Orders.evaluate([order("enemy_far","heal")],view).target_id==4,"heal on injured enemy permitted")
	view=fixture();check(Orders.evaluate([order("ally_hp_lt_50","lightning")],view).target_id==2,"lightning on ally permitted")
	check(Orders.evaluate([order("self","lightning")],view).target_id==1,"self lightning permitted by resolver")
	check(Orders.evaluate([order("self")],view).target_id==1,"self attack permitted by resolver")
	view.mana=0;check(Orders.evaluate([order("enemy_far","lightning"),order("enemy_near")],view).rule_index==1,"mana skips unavailable capability")
	view=fixture();view.cooldowns={"lightning":2.0};check(Orders.evaluate([order("enemy_far","lightning"),order("enemy_near")],view).target_id==3,"cooldown permits next order")
	check(Orders.evaluate([],view).is_empty(),"empty list has no hidden attack")
	var disabled: Dictionary=order("enemy_near");disabled.enabled=false
	check(Orders.evaluate([disabled],view).is_empty(),"inactive list has no hidden attack")
	var extra: Dictionary=order("enemy_near");extra.threshold=80
	check(not Orders.valid_order(extra,&"mako"),"editable threshold is forbidden")
	check(not Orders.valid_order(order("enemy_near","heal"),&"mako"),"capability belongs to source hero")
	for count in [0,1,100,101]:
		var rows: Array=[]
		for i in range(count):rows.append(Orders.create())
		check(Orders.valid_rows(rows,&"mako")==bool(count<=100),"list length bounded at one hundred")
	var many: Array=[]
	for i in range(100):many.append(disabled.duplicate(true))
	many[99]=order("enemy_far")
	check(Orders.evaluate(many,fixture()).rule_index==99,"last of hundred orders is evaluated")
	var summary: String="%s : %d controles, %d echecs"%["OK" if failures==0 else "ECHEC",checks,failures]
	print(summary);var label:=Label.new();label.text=summary;add_child(label)
