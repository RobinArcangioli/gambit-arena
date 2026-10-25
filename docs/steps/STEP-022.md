# STEP-022 — Six emplacements et disponibilité des compétences

Statut : Validée, commit en attente.
Base : 9491d40df3d396cf4f8532d603b4edaaf5d03176, STEP-021 clôturée.
GO et validation utilisateur reçus le 25 octobre 2026. Commit et sauvegarde à recevoir.

## Périmètre

Trois compétences consultables et trois réserves désactivées. États de disponibilité,
coûts, délais et motifs. Onglets Compétences/Gambits pour conserver l'espace de l'arène.
Lecture seulement : le lancement et l'attente manuels appartiennent à STEP-023.
Nouveaux : skill_availability.gd, skill_slots_lab.gd, test_skill_slots.gd et leurs UID,
scènes skill_slots_lab et skill_slots_tests, docs/skill-slots.md et cette recette.
Main et export pointent sur STEP-022. Version 0.1.0-step022, code 21.
Tous les anciens fichiers de logique, HUD et tests restent inchangés.

## Installation et tests F6

Fermer Godot. Vérifier main propre à 9491d40. Extraire dans ~ le projet complet
gambit-arena-complet-step-022-v1.tar.gz, sans remplacer .git.
Vérifier git diff --check, puis importer dans Godot.

Dans scenes/tests/, lancer avec F6, F8 entre chaque banc :
1. skill_slots_tests.tscn : six emplacements, états et priorités, coûts exacts, portée,
   cibles, pureté, consultation, onglets, formulaire, pause, défilement, dix resets et
   chronologie identique à un combat STEP-021 malgré des appuis répétés.
2. portrait_hud_tests.tscn : HUD et correctif de hauteur réelle des lignes.
3. gambit_fields_tests.tscn : champs et validation.
4. attack_stationary_tests.tscn : immobilité à portée.
5. gambit_editor_tests.tscn : activation et priorité.
6. gambit_diagnostics_tests.tscn : journal et reproductibilité.
7. gambit_controller_tests.tscn : pilotage et engagements.
8. gambit_tests.tscn : évaluateur.
9. lifecycle_tests.tscn : pause et mort.
10. combat_simulation_tests.tscn : combats historiques.

Attendu : OK, zéro échec par banc, aucun nouvel avertissement GDScript.
Godot non exécuté chez l'assistant : ni compilation, ni réussite F6 présumée.

## Recette F5 et Android

1. Démarrage sur Compétences : six emplacements, 1 Attaque/2 Soin/3 Spéciale et
   4/5/6 À venir désactivés. Les trois premiers montrent un motif, coût et délai.
   À PV pleins, Soin doit indiquer PV pleins lorsque le héros est libre et hors pause.
2. Appuyer plusieurs fois sur chaque compétence : seul le détail sélectionné change.
   Aucun lancement manuel, déplacement, coût ou cooldown déclenché par l'appui.
   Le combat automatique continue selon les gambits. Les réserves ne réagissent pas.
3. Pause : cartes indiquent Pause et délais figés ; consultation et onglets possibles.
   Reprendre explicitement : états mis à jour. En action, Occupé a priorité sur Délai ;
   le nombre de secondes reste visible. Les raisons multiples ne sont pas toutes listées.
4. Scénario Soin : au départ le héros blessé peut se soigner ; pendant son soin,
   Occupé et délai positif. Après la fin, Délai jusqu'à disponibilité. Énergie faible :
   raison Énergie si aucun blocage prioritaire. Attaque gratuite reste indépendante.
5. Avant contact, attaques Hors portée ; à portée et hors autre blocage, Prêt.
   Victoire : Terminé. Défaite : Mort. La consultation reste possible après la fin.
6. Onglet Gambits : activer/déplacer/éditer, Appliquer/Annuler, pause et Rejouer toujours
   fonctionnels. Formulaire ouvert : aucun changement d'onglet. Après fermeture,
   retrouver Compétences sans perdre les règles. Rejouer conserve onglet et sélection.
7. Sur petite zone utile (recette 360 × 640), faire défiler : sixième case et détail
   complètement accessibles ; pas de texte rogné, ni appui involontaire lors d'un glissement.
   La liste Gambits peut aussi nécessiter un défilement pour atteindre sa dernière ligne.
8. Encoche, barre de navigation, accueil/verrouillage/retour : zones sûres respectées,
   pause conservée et reprise explicite. Dix Rejouer : pas de doublons de cases/acteurs.
9. Vérifier absence de petits pas répétés sur cible à portée, approche d'une nouvelle
   cible, lisibilité et fluidité. Aucun changement d'animation ou de combat attendu.

## Export et clôture

Exporter Android Debug avec débogage vers ~/gambit-arena-builds/step-022-debug.apk,
hors dépôt. Installer avec adb -d install -r puis calculer sha256sum.
Transmettre F6, tests manuels, lisibilité/défilement, fluidité et SHA-256.
Validation utilisateur reçue. Message de commit proposé :
feat: [STEP-022] afficher six emplacements et la disponibilite des competences
Puis sauvegarde complète et vérification du point de reprise.
STEP-023 attend clôture et nouveau GO : commande manuelle prioritaire et attente bornée.

## Validation utilisateur reçue — 25 octobre 2026

STEP-022 explicitement validée : F6 OK, tests manuels OK, fluidité OK.
Retour F6 global, sans résultat séparé pour chacun des dix bancs demandés.
APK : step-022-debug.apk ; version de la livraison 0.1.0-step022, code 21.
SHA-256 communiqué : 2c3c52c1d17d10049a037dac8a7618ee197f54b6d2099bbf1473e7dc0a77366d.
Aucune mesure chiffrée de performance fournie.

Archive : gambit-arena-complet-step-022-validation.tar.gz.
Code, scènes, profils, tests et configuration identiques à la livraison v1.
Seule la documentation évolue ; aucun lancement Godot chez l’assistant.
Statut : Validée, commit en attente. Hash et sauvegarde à recevoir.
