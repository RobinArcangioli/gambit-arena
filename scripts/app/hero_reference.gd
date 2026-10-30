extends RefCounted
## Read-only adapter: profiles and executor metadata, never runtime actor state.
const Roster = preload("res://scripts/app/team_roster.gd")
const Executor = preload("res://scripts/party/party_executor.gd")
const TITLES = {&"basic": "Attaque", &"heal": "Soin", &"lightning": "Foudre", &"booster": "Booster",&"meteor":"Météore", &"ice_bolts":"Traits de glace"}
const DESCRIPTIONS = {
	&"ice_bolts":"Trois traits de glace infligent chacun 30 dégâts fixes à une victime distincte. Cible principale à 4 unités ; jusqu’à deux cibles supplémentaires à 2,5 unités de celle-ci. Dégâts à l’impact, sans réduction par la défense. Aucun remplacement d’une victime morte en vol.",
	&"meteor":"Retire 40 PV à chaque ennemi dont le disque au sol touche le rayon de 1,4 autour du point fixé au début de l’incantation, sans réduction par la défense. Aucun dégât aux alliés. Impact environ 0,77 s après le lancement. Incantation annulée si la zone est vide lors d’un contrôle toutes les 0,5 s. Recharge à partir du lancement effectif.",
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
