# Architecture réelle — STEP-014 validée, commit en attente

Main garde son UID et ouvre scenes/skills/skills_lab.tscn, dérivée de l'arène.
SkillExecutor reste l'unique point d'engagement des actions. AttackAction conserve
la garde ID/temps/résolution, revalide vie/portée et délègue l'effet à _apply_effect.
_valid_pair permet au soin d'accepter uniquement la source elle-même ; l'attaque
par défaut continue à refuser une cible identique à la source.

SkillExecutor ajoute heal et special au catalogue fermé. last_skill est enregistré
après engagement réussi ; il ne change pas sur refus. L'effet lit cet identifiant,
pas la sélection courante de l'interface. Le soin utilise ActorState.heal et
le compteur applied_healing ; les dégâts utilisent toujours ActorState.damage.
L'attaque de la spéciale est copiée au lancement puis doublée avant défense.

Récupération5 points/s, fractions accumulées, plafond60 sans réserve cachée.
Elle est activée explicitement dans SkillsLab et CombatUnit. Les diagnostics
STEP-013 gardent leur constructeur par défaut sans récupération pour conserver
les valeurs attendues. CombatSimulation ne demande encore que basic.
Horloge commune : pause et delta invalide bloquent action, CD et récupération ;
les coordinateurs bornent le pas à1/30 s. Une source morte ou reconfigurée retire
l'exécuteur avant toute récupération ou effet. Rejouer retire les anciens exécuteurs.

Le nouveau laboratoire montre PV, énergie, dépenses, récupération, CD, phase,
dégâts et soin effectif. Son ennemi a600 PV sur une copie locale du profil.
Anciennes scènes et profils conservés ; trois scripts partagés modifiés et couverts
par les bancs historiques à relancer. Voir docs/skills.md pour le contrat précis.

Pas de nouvelle animation finale, d'aire d'effet, d'allié, de gambit ou de priorité
manuelle. Six cases inactives. Rendu et projection conservés. Version 0.1.0-step014,
code 13. F6 et tests manuels confirmés OK par l’utilisateur.
