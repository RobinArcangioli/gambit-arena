# FIX-STEP-019-001 — Immobilité du héros à portée

## FIX-STEP-019-001 — 24 octobre 2026

Retour utilisateur v1 : F6 OK, tests manuels OK, fluidité OK, mais mouvement des
jambes accompagné d'un léger déplacement du héros pendant les attaques sur PC et Android.
SHA-256 APK v1 corrigé par l’utilisateur :
7fd4027080d9f560a77168d0256ced18ab322ec139084690271b805b89f4672a.
L’empreinte STEP-018 répétée initialement était une erreur de transcription.
Cette réserve empêchait la clôture de la v1. La v2 est désormais validée par l’utilisateur.

Analyse du code : la portée d'attaque est 1.0, la distance d'arrêt du déplacement 0.8.
Quand le héros redevient libre, l'approche précède l'engagement et peut encore avancer
vers 0.8 alors que l'attaque est déjà possible. Ce mouvement alimente la pose de marche.
Ce chemin existait avant STEP-019 ; l'animation n'avait pas été modifiée dans la v1.

Correctif : CombatSimulation ne demande plus de pas d'approche au héros dont la cible
vivante sélectionnée est déjà à portée, avec la même limite stricte Action.REACH que
l'exécuteur. La poursuite hors portée et le verrouillage des actions engagées restent
actifs. Aucun changement de pose, de portée, coût, cooldown, priorité ou mouvement ennemi.
Le dernier pas nécessaire pour entrer à portée reste normal ; une autre cible hors
portée autorise également un nouveau déplacement. L'immobilité n'est pas un gel global.

Nouveau banc scenes/tests/attack_stationary_tests.tscn : cible fixe aux distances
0.8/0.9/1.0, attaques répétées à 30/60/120 Hz, position/vitesse/jambes, dégâts uniques,
approche à 1.000005/1.02/2.0, reprise de poursuite, spéciale, pause et édition de règle.
Les tests précédents restent inchangés. Contrôles statiques seulement chez l’assistant ;
Godot absent, aucune compilation ni exécution moteur effectuée.

Livraison : gambit-arena-complet-step-019-v2.tar.gz, version 0.1.0-step019, code 18.
Appliquer sur STEP-019 non commitée. Relancer le nouveau banc et les six bancs précédents.
En F5 puis Android, observer plusieurs attaques sur la même cible à portée : aucun
petit pas répété ni relance de marche. Vérifier aussi l'approche d'une nouvelle cible,
les boutons d'édition, la pause et Rejouer. Réexporter l'APK et transmettre son nouveau SHA.
Correctif validé dans le retour global de STEP-019 v2. Pas de commit séparé :
le correctif est intégré au commit STEP-019 à effectuer.

## Validation utilisateur reçue — 24 octobre 2026

Retour : « Tout est OK. Step validée. » STEP-019 v2 et FIX-STEP-019-001 validés.
Retour global après demande de F6, recette PC/Android et réexport ; aucun détail
séparé pour chacun des sept bancs ni mesure chiffrée de performance fourni.
APK : step-019-debug.apk ; version 0.1.0-step019, code 18.
SHA-256 communiqué : 804fb0fd6521cbcafe374c582560d0284cc93f13cab9002acbd47d89593806c8.

Archive : gambit-arena-complet-step-019-validation.tar.gz.
Code, scènes, profils, tests et configuration identiques à la livraison v2.
Seule la documentation évolue ; aucun lancement Godot chez l’assistant.
Statut : Validée, commit en attente. Hash et sauvegarde à recevoir.
