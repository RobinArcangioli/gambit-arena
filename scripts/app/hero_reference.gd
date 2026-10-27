extends RefCounted
## Read-only adapter: profiles and executor metadata, never runtime actor state.
const Roster = preload("res://scripts/app/team_roster.gd")
const Executor = preload("res://scripts/party/party_executor.gd")
const TITLES = {&"basic": "Attaque", &"heal": "Soin", &"lightning": "Foudre"}
const DESCRIPTIONS = {
	&"basic": "Attaque un ennemi au corps à corps.",
	&"heal": "Rend des PV à un allié, soi-même compris.",
	&"lightning": "Frappe un ennemi avec la foudre."}
static func read(id: StringName) -> Dictionary:
	if not Roster.PROFILES.has(id):return {}
	var profile = Roster.PROFILES[id]
	var skills: Array[Dictionary] = []
	for skill in profile.abilities:
		skills.append({"id":skill,"name":TITLES.get(skill,String(skill)),
			"description":DESCRIPTIONS.get(skill,""),"cost":Executor.cost(skill),
			"duration":Executor.cast_duration(skill),"cooldown":Executor.cooldown(skill),
			"reach":Executor.skill_reach(skill),"recovery":Executor.RECOVERY})
	return {"id":profile.actor_key,"name":profile.display_name,"health":profile.max_health,
		"mana":profile.mana_capacity,"attack":profile.attack,"defense":profile.defense,
		"speed":profile.move_speed,"regeneration":profile.mana_regeneration,"skills":skills}
static func number(value: float) -> String:
	return ("%.1f" % value).replace(".0","").replace(".",",")
