# STEP-012 — Premier combat autonome contre plusieurs ennemis

Statut : Validée, commit en attente.
Base : 3633927fdb21273ca67c1d9343d012c6e9d20d3e, STEP-011 clôturée.
GO reçu. STEP-012 validée ; empreinte APK reçue, commit et sauvegarde à recevoir.

## Périmètre

Ciblage temporaire déterministe, approche, séparation, attaques autonomes des deux
camps, morts, changement de cible et arrêt terminal. Trois scénarios reproductibles.
Pas encore de compétences, gambits, vagues, éditeur ou boucle de partie finale.
Les classes et assets antérieurs sont conservés sans modification.

Nouveaux fichiers : scripts/combat/combat_unit.gd, combat_simulation.gd,
battle_lab.gd ; scenes/combat/battle_lab.tscn ; tests/test_combat_simulation.gd ;
scenes/tests/combat_simulation_tests.tscn ; docs/combat.md et cette recette.
Main conserve son UID ; version Android 0.1.0-step012, code 11.

## Installation et F6

Fermer Godot. Vérifier main propre et HEAD 3633927 avant extraction de
l'archive complète gambit-arena-complet-step-012-v1.tar.gz dans ~.
Dans ~/gambit-arena, lancer git diff --check et git status --short --branch.
Après import, ouvrir scenes/tests/combat_simulation_tests.tscn puis F6.
Attendu après plusieurs secondes : OK, zéro échec. F8 arrête.
Le banc simule les combats complets, dont vingt ennemis ; attendre son rapport.
En cas d'erreur, transmettre avant de poursuivre. Les anciens bancs F6 restent
accessibles, notamment attack_action_tests et ground_crowd_tests.

Le banc couvre victoire/défaite à 30/60/120 Hz, combat de vingt ennemis,
positions bornées, disques séparés, immobilité pendant action, compteurs exacts,
absence d'effets après fin, pause, grand delta, retarget, mort/retrait, reset
pendant action, dix resets, points d'apparition refusés et vraie scène/arrière-plan.
Godot absent chez l'assistant : compilation et exécution moteur non effectuées.

## Recette F5 puis Android

| Commande | Touche | Effet |
|---|---|---|
| Scénario | P | Victoire / Défaite / Groupe 20 |
| Rejouer | R | Recrée le scénario et conserve la pause |
| Pause/Reprendre | Espace | Fige mouvement, actions, poses et cadence |
| Repères | G | Disques de contact et ancrages, aussi en pause |

1. Victoire : héros 250 PV, ATQ 30 ; trois ennemis de 60 PV. Approche et attaques
   sans intervention, morts retirés, cible remplacée, résultat VICTOIRE avec
   3 vaincus et zéro ennemi. Aucun impact ni mouvement après la fin.
2. Défaite : héros normal 100 PV, ATQ 12 ; trois ennemis. Résultat DEFAITE,
   héros masqué, ennemis restants immobiles, compteurs figés.
3. Groupe 20 : héros de test 2500 PV. Apparitions progressives aux côtés,
   20 au total ; jamais plus de 20 vivants. Laisser finir, environ deux minutes
   simulées dans le calcul indépendant, sans garantie de durée matérielle.
   Attendu VICTOIRE, 20 vaincus ; observer fluidité et absence de blocage permanent.
4. Les acteurs s'arrêtent pendant préparation/récupération ; pas de traversée,
   téléportation ni dégâts à distance. Pas max <= environ 0,050 u.
5. Pause pendant une préparation : positions, poses, PV, temps et compteurs figés.
   Reprendre : suite normale, sans rafale. Répéter pendant les apparitions.
6. Rejouer pendant une préparation puis en pause : pas d'impact provenant de
   l'ancien combat, valeurs remises à zéro, pause conservée. Dix resets sans doublon.
7. Repères utilisable, six cases À venir inactives, HUD/arène lisibles,
   aucune erreur dans le débogueur et F8 fonctionnel.
8. Sur Android, refaire au toucher. Accueil/réduction/verrouillage pendant une
   attaque : retour en pause jusqu'à Reprendre, aucun effet tardif.

Les silhouettes peuvent se masquer visuellement ; les disques sont les contacts.
Les profils renforcés sont uniquement des réglages de recette, pas l'équilibrage.
Aucune animation finale d'attaque ou de mort n'est ajoutée.

## Android et clôture

Exporter Android Debug avec débogage vers
~/gambit-arena-builds/step-012-debug.apk, hors dépôt. Installer par adb -d install -r,
calculer sha256sum et transmettre F6, résultats manuels, fluidité et SHA-256.
Validation utilisateur reçue. Commit proposé :
feat: [STEP-012] integrer le premier combat autonome
Puis sauvegarde complète et vérification du point de reprise.
STEP-013 attend clôture et GO : exécuteur partagé, coûts et cooldowns uniques.

## Validation utilisateur reçue — 23 octobre 2026

STEP-012 explicitement validée : F6 OK, tests manuels OK, fluidité OK.
APK identifié : step-012-debug.apk ; version de la livraison 0.1.0-step012, code 11.
SHA-256 communiqué : cb301ad46d5332a33f22162c20cba0257126f403f914c5ea14c7daba8e100892.
Aucune mesure chiffrée de performance fournie.

Archive : gambit-arena-complet-step-012-validation.tar.gz.
Code, scènes, profils, tests et configuration identiques à la livraison v1.
Seule la documentation évolue ; aucun lancement Godot chez l’assistant.
Statut : Validée, commit en attente. Hash et sauvegarde à recevoir.
