# STEP-017 — Intentions pilotant seules le héros

Statut : Validée, commit en attente.
Base : 1da833e408b04a8e2627940842dd0ca7bd3adbd6, STEP-016 clôturée.
STEP-017 validée par l’utilisateur ; empreinte APK reçue. Commit et sauvegarde à recevoir.

## Périmètre

GambitController capture l'état, planifie, fournit le déplacement et revalide avant
SkillExecutor.request. Le contrôleur temporaire du héros est retiré du coordinateur.
CombatUnit ajoute une identité stable ; les règles et la pause survivent au reset.
Le héros ne fait rien sans règle applicable. Les ennemis restent autonomes.

Nouveaux : scripts/gambits/gambit_controller.gd, gambit_battle_lab.gd,
tests/test_gambit_controller.gd et leurs UID, scènes gambit_battle_lab et
gambit_controller_tests, docs/gambit-controller.md et cette recette.
Modifiés : CombatSimulation, CombatUnit, Main et export Android.
Évaluateur pur, exécuteur, actions, profils, mouvement et contacts inchangés.
Version 0.1.0-step017, code 16.

## Installation et tests F6

Fermer Godot. Vérifier main propre à 1da833e. Extraire dans ~ le projet complet
gambit-arena-complet-step-017-v1.tar.gz, sans remplacer .git.
Vérifier git diff --check, puis importer dans Godot.

Dans scenes/tests/, lancer avec F6, F8 entre chaque banc :
1. gambit_controller_tests.tscn : soin/spéciale/basic réels, approche sans coût,
   snapshot copié, revalidation, identités, action engagée, pause, règles désactivées,
   combat complet à 30/60/120 Hz, groupe 20, contacts, reset et scène réelle.
2. gambit_tests.tscn : déterminisme et pureté de l'évaluateur.
3. lifecycle_tests.tscn : pause, mort et annulation sans effet tardif.
4. skills_tests.tscn : effets, coûts et récupération des compétences.
5. combat_simulation_tests.tscn : diagnostics historiques via une règle basic.

Attendu pour chacun : OK, zéro échec. Les combats complets peuvent prendre un peu
de temps ; attendre le bilan. Godot non exécuté chez l'assistant.

## Recette F5 et Android

| Commande | Touche | Effet |
|---|---|---|
| Scénario | P | Combat / Soin / Groupe 20 / Sans règle |
| Rejouer | R | Nouveau combat, mêmes règles et même pause |
| Pause/Reprendre | Espace | Gèle tous les systèmes de jeu |
| Repères | G | Repères utilisables aussi en pause |

Le compteur Lances A/H/S compte les engagements acceptés, pas les impacts.
La dépense doit valoir 20 × H + 30 × S. L'énergie récupère à 5/s jusqu'à 60.
L'intention affichée peut rester celle de l'action engagée ; l'ID cible change au
reset. Les six cases À venir ne lancent toujours aucune commande manuelle.

1. Combat : le héros approche sa cible, engage une spéciale puis utilise l'attaque
   normale quand la spéciale est indisponible. Les ennemis répondent. Aucun double
   coût/impact, aucun déplacement du héros pendant son action. Fin en victoire.
2. Soin : départ 40/100. Première action R1 heal, coût 20 ; environ 0,6 s après,
   PV 70/100 avant contact ennemi. Puis approche/attaque selon règles et ressources.
   Le résultat final dépend du combat ; ne pas exiger une victoire de cette fixture.
3. Groupe 20 : apparitions progressives, soin/spéciale/basic choisis automatiquement
   selon disponibilité. Compteurs cohérents, aucun empilement permanent ni blocage
   du héros sur une cible morte. Le test automatisé contrôle la victoire complète.
4. Sans règle : héros immobile, engagements A/H/S tous à zéro, aucune dépense ; les
   ennemis continuent à agir jusqu'à la défaite. Rejouer conserve cet état de règles.
   Passer au scénario suivant réactive le préréglage normal.
5. Pause pendant approche, préparation puis récupération : temps, positions, PV,
   énergie et CD figés. Reprendre poursuit sans action supplémentaire ni rattrapage.
6. Rejouer dix fois, dont en pause et pendant une action : nouveaux acteurs et
   compteurs, pause conservée, aucune ancienne action ou intention sur le nouveau héros.
7. Après victoire/défaite : aucune nouvelle action ni apparition ; Rejouer fonctionne.
8. Android : mêmes essais tactiles. Accueil/verrouillage pendant une préparation,
   retour toujours en pause jusqu'à Reprendre. Vérifier lisibilité et fluidité.

## Export et clôture

Exporter Android Debug avec débogage vers ~/gambit-arena-builds/step-017-debug.apk,
hors dépôt. Installer avec adb -d install -r puis calculer sha256sum.
Transmettre F6, tests manuels, fluidité et SHA-256. Validation utilisateur reçue.
Message de commit proposé :
feat: [STEP-017] piloter le heros uniquement par les gambits
Puis sauvegarde complète et vérification du point de reprise.
STEP-018 attend clôture et nouveau GO : diagnostics bornés et scénarios reproductibles.

## Validation utilisateur reçue — 23 octobre 2026

STEP-017 explicitement validée : F6 OK, tests manuels OK, fluidité OK.
Retour F6 global, sans résultat séparé pour chacun des cinq bancs demandés.
APK : step-017-debug.apk ; version de la livraison 0.1.0-step017, code 16.
SHA-256 communiqué : ab0c538b8e84c680d4992dc19dbec32bfa0de7f33f94974079981e55e7ace6a8.
Aucune mesure chiffrée de performance fournie.

Archive : gambit-arena-complet-step-017-validation.tar.gz.
Code, scènes, profils, tests et configuration identiques à la livraison v1.
Seule la documentation évolue ; aucun lancement Godot chez l’assistant.
Statut : Validée, commit en attente. Hash et sauvegarde à recevoir.

## Passage à STEP-018

Clôture confirmée : 5b2bc4d692bd99f29774c19caf4eec3d3d93598f.
Sauvegarde gambit-arena-20261023-160700-5b2bc4d692bd.tar.gz vérifiée :
194 fichiers versionnés identiques, historique complet et restauration propre.
