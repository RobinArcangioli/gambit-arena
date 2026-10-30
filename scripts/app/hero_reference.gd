extends RefCounted
## Read-only adapter: profiles and executor metadata, never runtime actor state.
const Roster = preload("res://scripts/app/team_roster.gd")
const Executor = preload("res://scripts/party/party_executor.gd")
const TITLES = {&"basic": "Attaque", &"heal": "Soin", &"lightning": "Foudre", &"booster": "Booster",&"meteor":"Météore"}
const DESCRIPTIONS = {
	&"meteor":"Retire 40 PV à chaque ennemi dans un rayon de 1,4 autour du point fixé au début de l’incantation, sans réduction par la défense. Aucun dégât aux alliés. Recharge à partir du lancement effectif.",
	&"basic": "Attaque la cible au corps à corps.",
	&"heal": "Rend des PV à la cible choisie.",
	&"lightning": "Frappe la cible choisie avec la foudre.",
	&"booster": "Accélère les actions, déplacements, animations et recharges de 30 % pendant 60 s. La régénération de mana reste normale. Sans cumul ni renouvellement tant qu’actif."}
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
