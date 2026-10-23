# STEP-015 — Pause commune et interruption par la mort

Statut : Validée, commit en attente.
Base : 4f4244c24887cbf938e46bc9dd56507784d8c2bd, STEP-014 clôturée.
STEP-015 validée par l’utilisateur ; empreinte APK reçue. Commit et sauvegarde à recevoir.

## Périmètre

Horloge commune du combat et du nouveau laboratoire ; pause vérifiée aussi dans
les demandes et callbacks d'impact. Invalidation immédiate à la mort/sortie d'arbre,
sans effet tardif ni remboursement. Reset conserve la pause. Terminal retire tout.
Nouveaux fichiers : game_clock.gd, lifecycle_lab.gd, test_lifecycle.gd et leurs UID,
scènes lifecycle_lab.tscn et lifecycle_tests.tscn, docs/lifecycle.md et cette recette.
Composants partagés modifiés : AttackAction, SkillExecutor, CombatSimulation,
BattleLab. Main et export Android actualisés : version 0.1.0-step015, code 14.
Valeurs des compétences et profils inchangées ; scènes historiques conservées.

## Installation

Fermer Godot. Vérifier main propre à 4f4244c avant extraction dans ~ de
gambit-arena-complet-step-015-v1.tar.gz. Le paquet ne contient pas de .git.
Vérifier git diff --check et git status --short --branch, puis importer dans Godot.
project.godot conserve explicitement l'émulation de souris depuis le tactile.
L'export est configuré vers ../gambit-arena-builds/step-015-debug.apk.

## Bancs F6

Ouvrir successivement dans scenes/tests/ :
1. lifecycle_tests.tscn : pause des trois compétences, reprise, coût unique,
   mort en pause, annulation cible, coup létal et récupération, sortie d'arbre,
   callback différé, combat partagé, terminal, arrière-plan et dix resets.
2. skills_tests.tscn : soin/spéciale/récupération et laboratoire historique.
3. attack_action_tests.tscn : impact unique, identités, portée et réentrance.
4. skill_executor_tests.tscn : engagement unique et cooldowns historiques.
5. combat_simulation_tests.tscn : victoire/défaite, groupe 20, mouvement et contacts.

F8 entre les bancs. Attendu pour chacun : OK, zéro échec. Godot non exécuté ici.

## Recette F5 et Android

| Commande | Touche | Effet |
|---|---|---|
| Scénario | P | Pause libre / Mort cible / Mort héros |
| Attaque | A | Gratuite, 11 dégâts |
| Soin | H | 30 PV maximum, coût 20, CD 4 s |
| Spéciale | S | 23 dégâts, coût 30, CD 6 s |
| Mort héros | D | Intervention de test létale sur la source |
| Mort cible | E | Intervention de test létale sur l'ennemi |
| Rejouer | R | Nouveaux états, même pause |
| Pause/Reprendre | Espace | Gèle le temps de jeu |
| Repères | G | Affichage utilisable en pause |

1. Pause libre : héros 60/100, cible 600 PV, énergie 60.
   Lancer chacune des trois compétences après Rejouer. Mettre en pause avant effet :
   aucun changement de PV, énergie ou CD pendant l'attente. Reprendre : un seul effet.
   Attaque → cible 589 ; spéciale → 577 ; soin → héros 90. Dépenses 0/30/20.
2. Pause pendant récupération puis au repos : compteurs figés ; commandes bloquées.
   Reprendre laisse finir l'action ; la récupération d'énergie reprend à 5/s.
3. Mort cible : lancer attaque ou spéciale. À 0,3 s la cible disparaît ; action
   annulée, zéro dégât de compétence, coût conservé. Pas d'effet tardif.
   Un soin personnel reste indépendant de la mort de l'ennemi.
4. Mort héros : tester soin, spéciale et attaque, avec Rejouer entre les essais.
   Mort à 0,3 s : zéro effet, pas de résurrection ni de récupération d'énergie après mort.
5. Pause libre : tuer la source pendant la récupération d'une compétence.
   L'effet déjà appliqué reste unique ; l'action s'annule. Rejouer remet les états.
6. Rejouer pendant préparation et pendant pause, dix fois : deux acteurs seulement,
   états initiaux, pause conservée, aucune ancienne action ni erreur.
7. F6 sur scenes/combat/battle_lab.tscn : en Groupe 20, pause pendant une apparition
   ou approche. Positions, poses, temps et compteurs restent figés. Reprise normale.
   Les scénarios Victoire/Défaite s'arrêtent correctement ; Rejouer fonctionne.
8. Android : mêmes essais tactiles. Accueil ou verrouillage pendant une préparation,
   puis retour : toujours en pause jusqu'à Reprendre, aucun effet de rattrapage.
   Contrôler lisibilité, fluidité et six cases À venir toujours inactives.

## Export et clôture

Exporter Android Debug avec débogage vers ~/gambit-arena-builds/step-015-debug.apk,
hors dépôt. Installer via adb -d install -r puis calculer sha256sum.
Transmettre résultats F6, tests manuels, fluidité et empreinte APK.
Validation utilisateur reçue. Message de commit proposé :
feat: [STEP-015] unifier la pause et annuler les actions a la mort
Puis sauvegarde complète et contrôle du point de reprise.
STEP-016 attend clôture et nouveau GO : évaluateur déterministe de gambits.

## Validation utilisateur reçue — 23 octobre 2026

STEP-015 explicitement validée : F6 OK, tests manuels OK, fluidité OK.
Retour F6 global, sans résultat séparé pour chacun des cinq bancs demandés.
APK : step-015-debug.apk ; version de la livraison 0.1.0-step015, code 14.
SHA-256 communiqué : 90f39d41ad59a995179614e55bda1b9f41c96e0ca51081918b088cd12c137d5b.
Aucune mesure chiffrée de performance fournie.

Archive : gambit-arena-complet-step-015-validation.tar.gz.
Code, scènes, profils, tests et configuration identiques à la livraison v1.
Seule la documentation évolue ; aucun lancement Godot chez l’assistant.
Statut : Validée, commit en attente. Hash et sauvegarde à recevoir.

## Passage à STEP-016

Clôture confirmée : dd9fec88067da7e677e731b4e5338840ba8dccdf.
Sauvegarde gambit-arena-20261023-151439-dd9fec88067d.tar.gz vérifiée :
170 fichiers versionnés identiques, historique complet et restauration propre.
