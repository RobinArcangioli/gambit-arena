extends RefCounted
## Combat-owned chain. Primary hits on release, then a fresh search every .1 combat s.
const Chain = preload("res://scripts/skills/chain_skills.gd")
var pending: Array[Dictionary] = []
var events: Array[Dictionary] = []
var generation: int = 0
var busy: bool = false
func clear() -> void:
	generation += 1; pending.clear(); events.clear()
func release(values: Dictionary, primary, source_team: int) -> Array[Dictionary]:
	var epoch: int = generation
	var launch: Dictionary = values.duplicate(true)
	launch.kind = "chain_launch"
	var chain: Dictionary = {"values":values.duplicate(true),"source_team":source_team,"visited":[],"index":0,"remaining":Chain.INTERVAL,"previous":weakref(primary),"previous_state":primary.state,"position":primary.position}
	# Insert before a lethal callback; clear/reset then invalidates the whole chain.
	pending.append(chain)
	var was_busy: bool = busy; busy = true
	var first: Dictionary = _hit(chain,primary,values.source_position,float(values.game_time))
	busy = was_busy
	if epoch != generation: return []
	return [launch,first]
func _hit(chain: Dictionary, target, at: Vector3, time: float) -> Dictionary:
	var hit: Dictionary = chain.values.duplicate(true)
	hit.kind="chain_hit";hit.mana_paid=0;hit.game_time=time
	hit.target_id=target.combat_id;hit.target_team=target.team;hit.target_position=target.position
	hit.chain_from_position=at;hit.bounce_index=chain.index
	hit.nominal_damage=Chain.damage(chain.index)
	chain.visited.append(target.combat_id)
	chain.position=target.position;chain.previous=weakref(target);chain.previous_state=target.state
	# State and payment are latched before health callbacks can reenter.
	hit.damage=target.state.damage(hit.nominal_damage)
	chain.index+=1
	return hit
func advance(dt: float, units: Array, time: float) -> void:
	if busy or not is_finite(dt) or dt<=0:return
	busy=true
	var epoch: int = generation
	for chain in pending.duplicate():
		chain.remaining-=dt
		while chain.remaining<=.000001:
			var moment: float = time+minf(0,chain.remaining)
			var previous=chain.previous.get_ref()
			if is_instance_valid(previous) and previous.state==chain.previous_state:chain.position=previous.position
			var target=Chain.next_target(chain.position,units,chain.source_team,chain.visited)
			if chain.index>=Chain.COUNT or target==null:
				_finish(chain,moment,"rebonds epuises" if chain.index>=Chain.COUNT else "aucune cible");break
			var hit: Dictionary=_hit(chain,target,chain.position,moment)
			if generation!=epoch:busy=false;return
			events.append(hit)
			if chain.index>=Chain.COUNT:
				_finish(chain,moment,"rebonds epuises");break
			chain.remaining+=Chain.INTERVAL
	busy=false
func _finish(chain: Dictionary, time: float, reason: String) -> void:
	pending.erase(chain)
	var end: Dictionary=chain.values.duplicate(true)
	end.kind="chain_end";end.game_time=time;end.chain_count=chain.index;end.outcome=reason
	events.append(end)
func take_events() -> Array[Dictionary]:
	var result: Array[Dictionary]=events;events=[];return result
