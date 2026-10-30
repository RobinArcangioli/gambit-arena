extends RefCounted
## Read-only combat facts. No actor references, gameplay callbacks or rendering resources.
const CAPACITY:int=1000
const SKILLS: Dictionary = {"basic":"Attaque","heal":"Soin","lightning":"Foudre","booster":"Booster","meteor":"Météore","ice_bolts":"Traits de glace"}
var enabled: bool = false
var log_revision:int=0
var wave:int=-1
var run_id: int = -1
var actors: Dictionary = {}
var peaks: Array[int] = [1,1,1]
var recent: Array[Dictionary] = []
var entries: int = 0
var revision: int = 0

func begin(id: int) -> void:
	run_id=id;actors.clear();recent.clear();peaks=[1,1,1];entries=0;revision+=1;log_revision+=1;wave=-1
	if enabled:system(0.0,"Début du combat.")

func begin_wave(number:int,time:float) -> void:
	if not enabled or wave==number:return
	wave=number
	for id in actors.keys():
		if int(actors[id].team)!=0:actors.erase(id)
	peaks=[1,1,1]
	for row in actors.values():
		peaks[0]=maxi(peaks[0],row.dealt);peaks[1]=maxi(peaks[1],row.received);peaks[2]=maxi(peaks[2],row.healed)
	revision+=1
	system(time,"Vague %d : six ennemis arrivent."%number)

func register_actor(id: int, caption: String, team: int, slot: int, health: int, mana: int, time: float) -> void:
	if not enabled or actors.has(id):return
	actors[id]={"id":id,"name":caption,"team":team,"slot":slot,"dealt":0,"received":0,"healed":0,"alive":true,"sequence":0,"buffs":{}}
	revision+=1
	system(time,"%s entre en combat (%d PV%s)."%[caption,health,", %d PM"%mana if mana>0 else ""])

func system(time: float, text: String) -> void:_line(time,"system",text,"c7d6eb")
func name_of(id: int) -> String:return str(actors[id].name) if actors.has(id) else "Cible"
func expire(id: int, buff_id: String, time: float) -> void:
	if not enabled or not actors.has(id):return
	actors[id].buffs.erase(buff_id)
	_line(time,"buff_end","%s : %s prend fin."%[name_of(id),SKILLS.get(buff_id,buff_id)],"b8c8e4")

func consume(event: Dictionary) -> void:
	if not enabled or int(event.get("run_id",-1))!=run_id:return
	var kind:String=event.get("kind","")
	var source:int=int(event.get("source_id",0));var target:int=int(event.get("target_id",0))
	var time:float=float(event.get("game_time",0))
	if kind=="death":
		var id:int=int(event.get("actor_id",source))
		if not actors.has(id) or not actors[id].alive:return
		for buff_id in actors[id].buffs:
			_line(time,"buff_end","%s : %s dissipé à sa mort."%[name_of(id),SKILLS.get(buff_id,buff_id)],"b8c8e4")
		actors[id].buffs.clear();actors[id].alive=false;revision+=1
		_line(time,"death","%s est vaincu."%name_of(id),"e44949");return
	if not actors.has(source):return
	var sequence:int=int(event.get("sequence",0))
	if sequence<=int(actors[source].sequence):return
	actors[source].sequence=sequence
	var skill:String=event.get("skill","");var spell:String=SKILLS.get(skill,skill)
	var pair:String="%s → %s"%[name_of(source),name_of(target)]
	if bool(event.get("ground_target",false)) and kind!="area_hit":
		var point:Vector3=event.get("target_position",Vector3.ZERO)
		pair="%s → Zone (%.1f ; %.1f)"%[name_of(source),point.x,point.z]
	if kind=="start":
		var duration:float=_cast_seconds(source,float(event.get("windup",0)),time)
		_line(time,"cast" if skill!="basic" else "attack","%s : %s %s (%s s)."%[pair,"incante" if skill!="basic" else "prépare",spell,_decimal(duration)],"82bcff" if skill!="basic" else "fff2d4")
	elif kind in ["area_launch","multi_launch"]:
		_line(time,"spell","%s : lance %s · %d PM."%[pair,spell,int(event.get("mana_paid",0))],"ff749e")
	elif kind in ["resolve","area_hit","area_impact","multi_hit","multi_miss"]:
		var damage:int=int(event.get("damage",0));var healing:int=int(event.get("healing",0))
		actors[source].dealt+=damage;actors[source].healed+=healing
		if actors.has(target):actors[target].received+=damage
		peaks[0]=maxi(peaks[0],actors[source].dealt);peaks[2]=maxi(peaks[2],actors[source].healed)
		if actors.has(target):peaks[1]=maxi(peaks[1],actors[target].received)
		revision+=1
		var paid:int=int(event.get("mana_paid",0));var suffix:String=" · %d PM"%paid if paid>0 else ""
		var outcome:String=event.get("outcome","")
		if kind=="area_impact":
			_line(time,"spell","%s : %s, %d ennemi(s) touché(s), %d dégâts%s."%[pair,spell,int(event.area_count),int(event.area_total),suffix],"ffd16a");return
		var result:String="%d dégâts"%damage if damage>0 else "+%d PV"%healing if healing>0 else "effet appliqué" if outcome=="booster" else "cible hors de portée" if outcome=="hors portee" else "PV déjà pleins" if outcome=="PV pleins" else "PM insuffisants" if outcome=="mana insuffisante" else "buff déjà actif" if outcome=="buff deja actif" else "projectile sans effet : cible vaincue ou perdue" if kind=="multi_miss" else "sans effet"
		_line(time,"heal" if healing>0 else "damage" if damage>0 else "spell","%s : %s, %s%s."%[pair,spell,result,suffix],"b8ffcc" if healing>0 else "ffd16a" if damage>0 else "82bcff")
	elif kind=="buff_applied":
		var buff_id:String=event.get("buff_id",skill)
		if actors.has(target):actors[target].buffs[buff_id]={"expires":time+float(event.get("buff_duration",0)),"rate":float(event.get("time_multiplier",1))}
		_line(time,"buff","%s : %s actif %s s (+%d %% aux actions)."%[pair,SKILLS.get(buff_id,buff_id),_decimal(float(event.get("buff_duration",0))),roundi((float(event.get("time_multiplier",1))-1)*100)],"ffd16a")
	elif kind=="cancel":
		var preparing:bool=bool(event.get("was_preparing",true))
		if skill=="basic" and not preparing:return
		var reason:String="cible hors de portée" if event.get("outcome","")=="hors portee" else "zone vide" if event.get("outcome","")=="zone vide" else "lanceur vaincu" if not event.get("source_alive",true) else "cible vaincue ou perdue" if not event.get("target_alive",true) else "action interrompue"
		_line(time,"cancel","%s : %s — %s (%s)."%[pair,spell,"annulation" if preparing else "récupération interrompue",reason],"e6ab82")
	elif kind=="end" and skill!="basic":_line(time,"end","%s : récupération de %s terminée."%[name_of(source),spell],"a6b5cb")

func _cast_seconds(id: int, personal: float, time: float) -> float:
	var cursor:float=time;var remaining:float=maxf(0,personal)
	var active:Dictionary=actors[id].buffs
	for step in range(active.size()+1):
		var rate:float=1;var expiry:float=INF
		for values in active.values():
			if float(values.expires)>cursor:
				rate*=float(values.rate);expiry=minf(expiry,float(values.expires))
		var segment:float=(expiry-cursor)*rate
		if remaining<=segment:return cursor-time+remaining/rate
		remaining-=segment;cursor=expiry
	return remaining

static func _decimal(value: float) -> String:return ("%.1f"%value).replace(".",",")
func _line(time: float, kind: String, text: String, color: String) -> void:
	if not enabled:return
	var entry:Dictionary={"id":entries,"time":time,"kind":kind,"text":text,"color":color}
	recent.append(entry);entries+=1;log_revision+=1
	while recent.size()>CAPACITY:recent.pop_front()

func ordered() -> Array[Dictionary]:
	var rows:Array[Dictionary]=[]
	for actor in actors.values():rows.append(actor)
	rows.sort_custom(func(a:Dictionary,b:Dictionary)->bool:
		if a.team!=b.team:return a.team<b.team
		if a.dealt!=b.dealt:return a.dealt>b.dealt
		return a.slot<b.slot if a.slot!=b.slot else a.id<b.id)
	return rows

func mvp_id() -> int:
	var best:int=0;var score:int=0
	for row in actors.values():
		if int(row.team)!=0:continue
		var value:int=int(row.dealt)+int(row.healed)
		if value>score or (value==score and value>0 and (best==0 or int(row.dealt)>int(actors[best].dealt) or (int(row.dealt)==int(actors[best].dealt) and int(row.slot)<int(actors[best].slot)))):
			best=int(row.id);score=value
	return best
