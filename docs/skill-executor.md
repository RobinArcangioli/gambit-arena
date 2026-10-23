# Exécuteur partagé — STEP-013

SkillExecutor étend AttackAction sans modifier sa garde d'impact. Une instance
par acteur contient sa ressource et ses cooldowns. Les appels manuels et les
intentions automatiques utilisent request ; begin(source, target) est l'adaptateur
pour l'attaque de base du combat autonome. CombatUnit possède désormais ce même
exécuteur pour les deux camps. Aucun deuxième chemin ne retire de ressource.

## Entrées de diagnostic

| Identifiant | Coût | Cooldown | Effet |
|---|---|---|---|
| basic | 0 | 0 | Attaque STEP-011, préparation 0,6 s et récupération 0,4 s |
| paid_test | 20 | 3 s | Même attaque, uniquement pour tester coût et cooldown |

Ressource initiale : 60 par acteur, sans régénération à cette étape. Les identifiants
sont fermés : un appelant ne fournit pas librement un coût pour contourner le contrat.
paid_test n'est pas encore la compétence spéciale. Soin, spéciale et récupération
de ressource relèvent de STEP-014. Les six cases de compétences restent inactives.

## Engagement atomique

request refuse pause, acteur indisponible/retiré, état remplacé, identifiant inconnu,
action déjà active, cooldown non terminé ou ressource insuffisante. AttackAction
vérifie ensuite la cible et la portée. Une acceptation reçoit un ID positif,
retire le coût une seule fois et démarre le cooldown une seule fois à cet instant.
Un refus retourne 0 et ne modifie ni ressource, ni ID courant, ni temps, ni cooldown.
Seul le diagnostic last_rejection est actualisé. Aucun signal n'est émis entre
la validation, le débit et le démarrage du cooldown.

L'impact ne débite rien et ne relance aucun cooldown. Appels dupliqués, prématurés,
anciens IDs et appels réentrants restent rejetés par la garde STEP-011.
Un coup hors portée après engagement ou une action annulée garde son coût et
son cooldown : aucun remboursement. cancel arrête l'action, pas le cooldown.
retire annule définitivement l'exécuteur et empêche tout nouveau lancement.
Mort ou remplacement de l'état source retire l'exécuteur au prochain pas actif.
Le reset du laboratoire retire explicitement l'ancien avant de recréer les acteurs.

Le cooldown avance pendant préparation, récupération et repos. Il est propre à
l'identifiant et à l'acteur. Une attaque gratuite reste possible pendant le cooldown
de paid_test, si aucune action n'est engagée. Aucun lancement n'interrompt l'action
en cours. Pas de file d'attente ni de priorité manuelle à cette étape : la première
demande valide traitée gagne ; les autres sont refusées.

## Temps et intégration

advance(delta, paused) avance cooldowns et action ensemble ; pause/delta invalide
ne modifient rien. Le laboratoire et CombatSimulation bornent le pas à 1/30 s.
Une valeur résiduelle inférieure à 0,000001 s est ramenée à zéro pour éviter
un résidu numérique. Le cooldown ne dépend pas de l'horloge réelle ni d'un Timer.
Le contrôle de pause des commandes appartient à l'appelant ; request offre aussi
un paramètre paused. Le combat autonome bloque ses demandes quand il est en pause.

CombatUnit utilise SkillExecutor.new(self) à la place d'AttackAction.new().
Le coordinateur STEP-012 conserve son ordre et appelle begin : cela passe par
request(basic), sans coût ni nouveau cooldown, avec la même durée d'action.
Les autres scripts antérieurs ne changent pas. Le banc combat_simulation_tests
est à relancer car cette substitution touche les deux camps du combat autonome.

## Laboratoire

Trois mannequins immobiles : H et A sont deux lanceurs, le troisième est une cible
commune à 1000 PV. Les profils sont copiés ; les ressources .tres restent inchangées.
Manuel : boutons Essai20/Base0 sur l'acteur sélectionné. Auto : H demande paid_test
environ dix fois par seconde. Deux acteurs : H et A le demandent indépendamment.
Le bouton Auto reste disponible dans chaque mode ; en mode Manuel il pilote H.

Trois essais payants épuisent chaque acteur : 60→40→20→0, trois cooldowns engagés.
En mode Auto seul, la cible passe de 1000 à 967 ; en mode Deux acteurs, à 946.
A peut produire des dégâts différents car son profil ATQ8 diffère de H ATQ12.
Rejouer restaure les états et conserve la pause. Les IDs ne sont pas réutilisés.

Banc : scenes/tests/skill_executor_tests.tscn. Godot non exécuté chez l'assistant.

## Validation

F6, tests manuels et fluidité confirmés OK par l’utilisateur.
STEP-013 validée, commit en attente. Voir docs/steps/STEP-013.md.

## Passage à STEP-014

Le catalogue comprend maintenant heal et special. La récupération est optionnelle
au constructeur, activée dans SkillsLab et CombatUnit. Le diagnostic historique
STEP-013 conserve sa récupération désactivée et paid_test. Voir docs/skills.md ;
les mentions de compétences futures ci-dessus décrivent la livraison STEP-013.

## Passage à STEP-015

bind_clock relie les acteurs à la porte commune ; request, advance et try_impact
la consultent. Les anciens laboratoires sans liaison conservent paused explicite.
La mort de la source retire l’exécuteur ; voir docs/lifecycle.md.
