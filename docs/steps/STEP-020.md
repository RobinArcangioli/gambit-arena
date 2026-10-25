# STEP-020 — Édition validée des champs des gambits

Statut : Validée, commit en attente.
Base : 4125d44e048c34f6ff8ae197e2d912e2db57fad5, STEP-019 clôturée.
STEP-020 validée par l’utilisateur ; empreinte APK reçue. Commit et sauvegarde à recevoir.

## Périmètre et décisions

Cible Soi/Ennemi ; condition Toujours/PV < seuil ; seuil entier 0..100 ; action
Attaque/Soin/Spéciale. Validation atomique, message explicite en cas d'incompatibilité.
Brouillon indépendant, Appliquer/Annuler, pause à l'ouverture et reprise explicite.
L'activation et la priorité de STEP-019 sont conservées. Aucun ajout de compétence,
de persistance ou de commande manuelle. Le correctif d'immobilité à portée reste inchangé.

Nouveaux : gambit_fields_lab.gd, test_gambit_fields.gd et leurs UID, scènes
gambit_fields_lab et gambit_fields_tests, docs/gambit-fields.md et cette recette.
Modifiés : GambitEditor (validation/application des champs), résumé GambitEditorLab,
Main, version et chemin d'export. Version Android 0.1.0-step020, code 19.

## Installation et tests F6

Fermer Godot. Vérifier main propre à 4125d44. Extraire dans ~ le projet complet
gambit-arena-complet-step-020-v1.tar.gz, sans remplacer .git.
Vérifier git diff --check, puis importer dans Godot.

Dans scenes/tests/, lancer avec F6, F8 entre chaque banc :
1. gambit_fields_tests.tscn : validation, types, compatibilités, seuils, atomicité,
   copies, modal réel, annulation, application, pause, action engagée et dix resets.
2. attack_stationary_tests.tscn : immobilité du héros à portée, approche et poursuite.
3. gambit_editor_tests.tscn : activation/priorité, coûts et conservation.
4. gambit_diagnostics_tests.tscn : journal borné et reproductibilité.
5. gambit_controller_tests.tscn : pilotage et engagements uniques.
6. gambit_tests.tscn : évaluation déterministe.
7. lifecycle_tests.tscn : pause et mort.
8. combat_simulation_tests.tscn : combat historique et resets.

Attendu : OK, zéro échec par banc, aucun nouvel avertissement GDScript.
Godot non exécuté chez l'assistant : ni compilation, ni réussite F6 présumée.

## Recette F5 et Android

1. Toucher une règle : formulaire visible et combat figé. Cible, condition, seuil,
   action et boutons lisibles sans recouvrement. Les champs reflètent la bonne ligne,
   même après Haut/Bas ou désactivation. Un appui = un changement.
2. Soin/Soi : choisir Ennemi sans changer Soin. Message explicite, Appliquer désactivé.
   Passer Action à Spéciale : la règle devient valide sans changement automatique de cible.
3. Avant Appliquer, Annuler : résumé et comportement inchangés. Pause conservée.
   Sur PC, Échap annule aussi ; Espace/R/P ne modifient rien tant que le formulaire est ouvert.
4. Réouvrir, choisir Ennemi + PV < seuil + 25 % + Spéciale, puis Appliquer : résumé
   exact, état Oui/Non et priorité conservés. Reprendre explicitement. Le héros choisit
   cette règle seulement pour un ennemi répondant à la condition et si l'action est disponible.
5. Vérifier -5/-1/+1/+5, bornes 0 et 100, et l'absence de dépassement. Toujours désactive
   les boutons de seuil et conserve la valeur. Revenir à PV < seuil la retrouve.
6. Dans scénario Soin (40/100 PV), mettre en pause puis Rejouer. Configurer la première
   règle Soin/Soi/PV < 40 : reprendre, elle ne doit pas être sélectionnée à 40 PV exacts.
   Refaire à 41 % : le soin doit être le premier engagement. Garder les autres règles
   identiques et effectuer Rejouer avant chaque comparaison pour retrouver 40/100 PV.
7. Pendant un soin engagé, ouvrir, modifier le seuil et appliquer : action figée pendant
   le formulaire, puis reprise sans annulation, double soin, surcoût ni reset du cooldown.
8. Modifier une règle désactivée : elle reste Non. La déplacer : tous les champs suivent.
   Rejouer et changer de scénario : tous les champs sont conservés. Une nouvelle session
   F5 retrouve les trois règles standard (absence de persistance voulue).
9. Accueil/verrouillage/retour avec brouillon ouvert : brouillon conservé, combat toujours
   en pause, reprise explicite. Dix ouvertures/annulations et Rejouer : aucun doublon.
10. Vérifier plusieurs attaques sur la même cible à portée : pas de petits pas répétés.
    Approche d'une nouvelle cible hors portée toujours possible. Vérifier fluidité et
    commandes tactiles sur Samsung Galaxy A16. Six emplacements futurs toujours masqués.

## Export et clôture

Exporter Android Debug avec débogage vers ~/gambit-arena-builds/step-020-debug.apk,
hors dépôt. Installer avec adb -d install -r puis calculer sha256sum.
Transmettre F6, tests manuels, fluidité et SHA-256. Validation utilisateur reçue.
Message de commit proposé :
feat: [STEP-020] editer et valider les champs des gambits
Puis sauvegarde complète et vérification du point de reprise.
STEP-021 attend clôture et nouveau GO : HUD portrait et zones de sécurité.

## Validation utilisateur reçue — 24 octobre 2026

STEP-020 explicitement validée : F6 OK, tests manuels OK, fluidité OK.
Retour F6 global, sans résultat séparé pour chacun des huit bancs demandés.
APK : step-020-debug.apk ; version de la livraison 0.1.0-step020, code 19.
SHA-256 communiqué : 084cc3ea0e03a553f00a111683f048db0b5f4331a3c5b6782c4aa872b5cfe97e.
Aucune mesure chiffrée de performance fournie.

Archive : gambit-arena-complet-step-020-validation.tar.gz.
Code, scènes, profils, tests et configuration identiques à la livraison v1.
Seule la documentation évolue ; aucun lancement Godot chez l’assistant.
Statut : Validée, commit en attente. Hash et sauvegarde à recevoir.

## Clôture vérifiée — 25 octobre 2026

Commit ac581907fc1a5a9b3bc4573a75d35805e2ebf151, parent 4125d44.
Main propre ; sauvegarde gambit-arena-20261025-014820-ac581907fc1a.tar.gz vérifiée.
Historique complet et intègre ; 229 fichiers identiques au commit et à la livraison validée.
Le statut « commit en attente » ci-dessus décrit la livraison de validation antérieure.
