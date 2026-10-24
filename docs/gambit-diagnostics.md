# Diagnostics bornés — STEP-018

## Explication fidèle à la décision

evaluate et explain empruntent le même parcours. explain retourne {decision, rules},
où decision garde les sept champs du contrat STEP-016. rules contient au plus trois
couples {rule_index, reason}, indices 0..2 (affichés R1..R3).

| Code | Sens |
|---|---|
| invalid_rule | Règle nulle ou configuration invalide |
| disabled | Règle désactivée |
| energy | Coût non couvert |
| cooldown | Cooldown strictement positif |
| full_health | Soin inutile à PV pleins |
| condition | Aucune cible vivante ne satisfait la condition |
| no_target | Aucun ennemi vivant disponible |
| selected | Première règle applicable, cible à portée |
| approach | Première règle applicable, cible hors portée |
| lower_priority | Règle non évaluée car une précédente a été retenue |

Ordre des vérifications : existence, activation, validité, énergie, cooldown,
utilité du soin/condition et sélection. Un seul motif par règle, correspondant au
premier refus ; la liste ne prétend pas montrer tous les refus simultanés.
Si le snapshot est invalide ou la source indisponible, la décision globale reste
invalid_input/unavailable et la liste est vide : aucune règle n'a été évaluée.

## Journal et limites mémoire

GambitTrace conserve au maximum 64 entrées en mémoire, sans écriture disque.
Chaque entrée : sequence, time, event, rule_index, skill, target_id, action_id,
reason et au plus trois motifs rules. time est le temps de jeu, pas l'heure murale.
Chaînes bornées : event 24 caractères, skill 16, reason 32 (également dans rules).
Champs supplémentaires ignorés ; types non conformes remplacés par valeurs neutres.
Aucun objet vivant ou snapshot n'entre dans le journal. latest retourne des copies
profondes et limite sa réponse à 64 entrées, même si l'appelant demande davantage.

Au 65e événement, le plus ancien est retiré. total compte toutes les entrées écrites,
dropped celles retirées ; aucune archive parallèle ne les conserve.
La dernière explication du contrôleur est aussi limitée à une décision et trois motifs.
L'interface ne lit que les quatre dernières entrées du journal.

| Événement | Déclenchement |
|---|---|
| decision | Une planification réellement effectuée, y compris no_match |
| commit | SkillExecutor accepte un engagement ; action_id identifie l'action |
| invalidated | Cible/état/règle devenue invalide ou revalidation refusée |
| rejected | Refus de l'exécuteur, au plus une fois par intention en attente |
| stopped | Plan abandonné au clear/terminal/arrêt explicite |

commit n'est pas un impact. Le journal n'enregistre pas chaque dégât, animation,
appel de lecture, frame d'approche ou tick occupé. Il explique le pilotage du héros.
Les IDs d'acteurs/actions sont des IDs de session ; leur valeur brute change au replay.
Le banc normalise ces IDs pour comparer les séquences de deux combats identiques.

diagnostics_enabled=false désactive explications/journal du contrôleur, mais laisse
évaluation et gameplay actifs. Les anciennes entrées restent consultables jusqu'au
reset ou à leur éviction après réactivation. Dans les cas fixes, l'explication reste
affichée même si l'enregistrement est coupé, car elle constitue l'objet du diagnostic.
Reset efface journal, compteurs et dernière explication ; pause et activation persistent.

## Fixtures reproductibles

Chaque fixture crée un snapshot et trois règles ne partageant pas d'état mutable
avec une autre fixture. Source #1 ; ennemi #2 à 0,8 u, sauf indication contraire.
Valeurs ordinaires : source 60/100, énergie 60, cooldowns nuls.

| Cas | Variation | Résultat attendu | Motifs R1 / R2 / R3 |
|---|---|---|---|
| Soin prioritaire | Source 40/100 | heal → #1 | selected / lower_priority / lower_priority |
| Seuil 50 % | Source 50/100 | special → #2 | condition / selected / lower_priority |
| Énergie vide | Énergie 0 | basic → #2 | energy / energy / selected |
| Cooldowns | Source 40/100, CD soin 4/spéciale 6 | basic → #2 | cooldown / cooldown / selected |
| Sans cible | Source 100/100, aucun ennemi | no_match | full_health / no_target / no_target |
| Égalité | Ennemi #3 ajouté avant #2, même distance | special → #2 | condition / selected / lower_priority |
| Hors portée | Ennemi #2 à 2 u | special → #2, approche | condition / approach / lower_priority |
| Désactivées | Trois règles désactivées | no_match | disabled / disabled / disabled |

Ces huit cas sont des lectures seules : aucune compétence ni déplacement exécuté,
aucune énergie consommée, aucun cooldown avancé. Leur monde 3D est masqué ; les
données affichées proviennent du snapshot. Les lectures suivent 10 Hz de temps de jeu.
Rejouer recrée exactement les mêmes données. La prévisualisation initiale n'incrémente
pas le compteur ni le journal. La pause bloque les lectures et conserve la vue.

Le neuvième choix est le combat réel, conservant le pilotage STEP-017. Le banc compare
ses états tick par tick avec/sans trace (empreintes d'état et état final), puis deux
journaux normalisés. Les tests ne sont pas des mesures de performance matérielle.
Les anciens laboratoires restent accessibles, notamment Groupe 20 dans STEP-017.

## Validation

F6, tests manuels et fluidité confirmés OK par l’utilisateur.
STEP-018 validée, commit en attente. Voir docs/steps/STEP-018.md.
