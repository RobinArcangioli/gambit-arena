# Gambits — contrat STEP-016

## Entrées et validation

evaluate(rules, snapshot) est une fonction sans état interne et sans effet de bord.
Elle ne consomme pas les entrées, ne les trie pas et ne conserve aucune référence.
Le résultat est un dictionnaire neuf de scalaires. Aucun lancement de compétence.

Au maximum trois GambitRule Resources : enabled, target (self/enemy), condition
(always/hp_below), threshold entier 0..100, skill (basic/heal/special).
Seul heal peut viser self ; basic/special visent enemy. Une règle nulle, désactivée
ou invalide est ignorée. Plus de trois règles rend toute la demande invalide.
Pas d'expressions libres, pas de condition implicite ni de sélection aléatoire.

GambitSnapshot : source, au maximum 20 ennemis, énergie entière 0..60, cooldowns
heal/special finis et positifs ou nuls, busy, paused, stopped.
Chaque acteur contient exactement id entier positif unique, health entier,
max_health entier dans 1..1000000, position Vector2 finie (composantes <= 1000000
en valeur absolue). PV dans 0..max_health. IDs distincts, y compris source/ennemis.
Un champ supplémentaire ou mal typé invalide le snapshot complet. Les champs
source/enemies ne contiennent donc aucun objet vivant. Les limites de position
évitent les dépassements numériques et dépassent largement l'arène actuelle.
Le futur adaptateur sera responsable de fournir des valeurs copiées cohérentes.

## Ordre de décision

1. Snapshot invalide ou liste trop longue → none / invalid_input.
2. Source morte, occupée, en pause ou arrêtée → none / unavailable.
3. Parcourir les règles dans l'ordre. Ignorer les règles non disponibles.
4. Filtrer les cibles vivantes par condition, puis choisir la plus proche.
5. Égalité exacte de distance carrée : ID numérique le plus petit.
6. Retourner immédiatement la première intention ; sinon none / no_match.

hp_below porte sur les PV de la cible de la règle, avec comparaison stricte :
health × 100 < max_health × threshold. À 50/100 et seuil 50, condition fausse.
À 1/3, seuil 33 faux et seuil 34 vrai : aucun arrondi d'affichage ne décide.
Un soin à PV pleins est toujours ignoré, même sous condition always.

L'énergie doit couvrir le coût, cooldown exactement nul. Coûts repris des constantes
SkillExecutor : basic 0, heal 20, special 30. Aucun débit, aucune régénération,
aucun compte à rebours. Une règle bloquée laisse sa place à la suivante.

## Résultat

| Champ | Intention | Aucune intention |
|---|---|---|
| kind | intent | none |
| reason | matched | invalid_input / unavailable / no_match |
| rule_index | Indice 0..2 | -1 |
| source_id / target_id | Identifiants du snapshot | 0 / 0 |
| skill | basic / heal / special | Chaîne vide |
| approach | Distance > portée 1 u | false |

Une cible distante reste un choix valide : approach signale le déplacement requis.
La distance 1 u exacte est à portée. Aucun déplacement n'est exécuté ici.
Ce résultat n'est ni une réservation ni un ID d'action. Une ancienne intention
ne doit jamais suffire à provoquer un effet : STEP-017 devra revalider les acteurs
et passer exclusivement par SkillExecutor pour l'engagement.

Les IDs seront stables pendant un combat et indépendants de l'ordre des tableaux.
Le laboratoire utilise source #1 et ennemis #2/#3 ; il recrée ses fixtures au reset.

## Diagnostic et limites

Lecture à 10 Hz de temps de jeu, pas borné par GameClock à 1/30 s. Pas de rattrapage
du temps en arrière-plan ; reprise explicite. Évaluer force une lecture hors pause.
Énergie et cooldown affichés sont des entrées simulées, pas ceux d'une compétence.
Ils ne décroissent pas spontanément ; PV ennemis constants sauf scénario Sans cible.
Blesser/Rétablir modifient explicitement les PV de test, pas via une compétence.
Un héros mort demande Rejouer : Rétablir ne ressuscite pas.

Le compteur de lectures et l'intention courante sont affichés sans historique stocké.
Les diagnostics du combat et leurs scénarios étendus restent STEP-018.
L'éditeur et la conservation des trois règles de partie arrivent ultérieurement.

## Validation

F6, tests manuels et fluidité confirmés OK par l’utilisateur.
STEP-016 validée, commit en attente. Voir docs/steps/STEP-016.md.
