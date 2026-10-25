# STEP-021 — HUD portrait et zones de sécurité

Statut : Validée, commit en attente.
Base : ac581907fc1a5a9b3bc4573a75d35805e2ebf151, STEP-020 clôturée.
STEP-021 validée par l’utilisateur ; empreinte APK reçue. Commit et sauvegarde à recevoir.

## Périmètre

HUD lisible : état, PV/énergie, action, délais et ennemis. Arène séparée, marges sûres,
liste de règles et champs défilables si nécessaire ; commandes modales fixes.
Comportements STEP-020 conservés. Cadrage adaptatif de l'arène, sans modification
de position physique ou animation. Ni commande manuelle ni vague ajoutée.
Nouveaux : hud_layout.gd, portrait_hud_lab.gd, test_portrait_hud.gd et leurs UID,
scènes portrait_hud_lab et portrait_hud_tests, docs/portrait-hud.md et cette recette.
Main et export pointent sur STEP-021. Version Android 0.1.0-step021, code 20.
Tous les fichiers de logique et tests précédents restent inchangés.

## Installation et tests F6

Fermer Godot. Appliquer sur STEP-021 non commitée, base ac58190. Extraire dans ~ le projet complet
gambit-arena-complet-step-021-v2.tar.gz, sans remplacer .git.
Vérifier git diff --check, puis importer dans Godot.

Dans scenes/tests/, lancer avec F6, F8 entre chaque banc :
1. portrait_hud_tests.tscn : zones sûres invalides/asymétriques, conversion d'échelle,
   rectangles disjoints, boutons, défilement, valeurs affichées, modalité, pause,
   dix resets et chronologie identique à un combat du laboratoire STEP-020.
2. gambit_fields_tests.tscn : édition/validation des quatre champs.
3. attack_stationary_tests.tscn : immobilité du héros à portée.
4. gambit_editor_tests.tscn : activation et ordre.
5. gambit_diagnostics_tests.tscn : journal et reproductibilité.
6. gambit_controller_tests.tscn : pilotage et engagements.
7. gambit_tests.tscn : évaluation déterministe.
8. lifecycle_tests.tscn : pause et mort.
9. combat_simulation_tests.tscn : combats historiques et resets.

Attendu : OK, zéro échec par banc, aucun nouvel avertissement GDScript.
Godot non exécuté chez l'assistant : ni compilation, ni réussite F6 présumée.

## Recette F5 et Android

1. Au format portrait 540 × 960, vérifier l'absence de chevauchement : en-tête,
   valeurs, arène, commandes et règles. Textes non tronqués, action lisible, barres
   cohérentes avec les chiffres. Le cadrage doit montrer le sol et les mannequins.
2. Scénario Soin : 40/100 PV au reset, puis énergie débitée et soin reflétés dans
   chiffres/barres. Pause : PV, énergie, délais et action restent figés. Rejouer
   rafraîchit les valeurs et conserve les règles. Victoire/défaite affichées clairement.
3. Réduire la hauteur disponible ou essayer plusieurs fenêtres portrait ; référence
   minimale de zone utile 360 × 640 logiques. Défilement vertical des gambits : pouvoir
   atteindre et manipuler complètement la troisième ligne. Aucun clic involontaire en
   faisant glisser la liste. Haut/Bas et Oui/Non : une modification par appui.
4. Ouvrir une règle. Vérifier les quatre champs et l'erreur Soin/Ennemi. Appliquer et
   Annuler restent visibles ; si les champs défilent, pouvoir atteindre l'explication
   puis remonter. Modifier/annuler et ordre/activation conservent le comportement STEP-020.
5. Éditer pendant une action engagée : pause automatique, action conservée, application
   sans coût/effet supplémentaire ; fermeture garde la pause, reprise explicite.
6. Android : vérifier encoche, bords et barre de navigation. Afficher/masquer les barres
   système si possible : commandes dans la zone utile, aucune dérive du panneau modal.
   Les boutons ne doivent pas être cachés sous l'encoche ou la zone de geste.
7. Accueil/verrouillage/retour avec brouillon ouvert : brouillon et pause conservés,
   relayout correct, Appliquer/Annuler accessibles. Aucun rattrapage du temps de combat.
8. Dix Rejouer, dont certains en pause, et ouvertures/fermetures du formulaire : pas
   de doublons de lignes, d'acteurs ou de signaux. L'ordre et les champs restent conservés.
9. Plusieurs attaques sur la même cible à portée : pas de petits pas répétés. Approche
   d'une nouvelle cible toujours possible. Pas de changement d'animation attendu.
10. Confirmer lisibilité, défilement tactile et fluidité sur Galaxy A16. Le zoom peut
    diminuer sur espace réduit ; le combat ne doit pas changer. Les six cases futures
    restent masquées, conformément au périmètre précédant STEP-022.

Les cas géométriques F6 simulent des marges ; ils ne certifient pas les barres Android
réelles ou le rendu des polices. Toute troncature/zone inaccessible doit être signalée.

## Export et clôture

Exporter Android Debug avec débogage vers ~/gambit-arena-builds/step-021-debug.apk,
hors dépôt. Installer avec adb -d install -r puis calculer sha256sum.
Transmettre F6, tests manuels, lisibilité, défilement, fluidité et SHA-256.
Validation utilisateur reçue. Message de commit proposé :
feat: [STEP-021] adapter le HUD portrait aux zones de securite
Puis sauvegarde complète et vérification du point de reprise.
STEP-022 attend clôture et nouveau GO : six emplacements et disponibilité des compétences.

## FIX-STEP-021-001 — 25 octobre 2026

Retour utilisateur v1 : échec F6 « last rule can be fully reached by scrolling »
dans portrait_hud_tests. Ce retour v1 ne constituait pas une validation.
Le correctif v2 est désormais validé dans le retour utilisateur global.

La v1 déclarait 232 px de contenu et demandait des résumés de 72 px de haut.
Ces valeurs ne tenaient pas compte du minimum réel des boutons multilignes imposé
par le texte et le thème. Un Control parent ne calcule pas automatiquement son
minimum à partir des boutons positionnés manuellement. Cette hypothèse fragile
est supprimée ; les dimensions exactes du cas utilisateur n'ont pas été mesurées ici.

La v2 calcule chaque ligne depuis get_combined_minimum_size, place les commandes
sur cette hauteur et déclare la hauteur totale réelle, avec 8 px de marge finale.
Le contenu est recalculé après changement de résumé. Le banc attend le tri différé
du conteneur avant d'aller à max_value - page, garde le contrôle d'inclusion stricte,
vérifie les quatre boutons de la dernière ligne et répète avec une police de 24 px.
En cas d'échec, les rectangles, la hauteur de contenu et les valeurs de défilement
sont désormais inclus dans le message pour permettre un diagnostic précis.

Source des contrats de taille/défilement : documentation officielle Godot Control
et ScrollContainer (get_combined_minimum_size et custom_minimum_size).
https://docs.godotengine.org/en/stable/classes/class_control.html
https://docs.godotengine.org/en/stable/classes/class_scrollcontainer.html

Livraison : gambit-arena-complet-step-021-v2.tar.gz. Version inchangée :
0.1.0-step021, code 20. Appliquer sur STEP-021 non commitée, base ac58190.
Relancer portrait_hud_tests.tscn, puis les huit bancs précédents et la recette PC/Android.
Vérifier en particulier que toute la dernière règle est visible en bas de la liste.
Contrôles statiques effectués ; Godot absent, aucune compilation ni exécution moteur ici.
Le combat, les animations, l'éditeur de règles et les autres tests restent inchangés.
APK v2 et correctif validés ; commit STEP-021 et sauvegarde à effectuer.

## Validation utilisateur reçue — 25 octobre 2026

STEP-021 explicitement validée : F6 OK, tests manuels OK, fluidité OK.
Retour F6 global, sans résultat séparé pour chacun des neuf bancs demandés.
APK : step-021-debug.apk ; version de la livraison 0.1.0-step021, code 20.
SHA-256 communiqué : 224dfb87269dd7cd4a955eb3813711fdfb6c72b68af8e060ffa39a5d94a68b35.
Aucune mesure chiffrée de performance fournie.

Archive : gambit-arena-complet-step-021-validation.tar.gz.
Code, scènes, profils, tests et configuration identiques à la livraison v2.
Seule la documentation évolue ; aucun lancement Godot chez l’assistant.
Statut : Validée, commit en attente. Hash et sauvegarde à recevoir.

Empreinte STEP-021 v2 corrigée par l’utilisateur : 224dfb87269dd7cd4a955eb3813711fdfb6c72b68af8e060ffa39a5d94a68b35.
La première empreinte transmise répétait celle de STEP-020 par erreur.

## Clôture vérifiée — 25 octobre 2026

Commit 9491d40df3d396cf4f8532d603b4edaaf5d03176, parent ac58190.
Main propre ; sauvegarde gambit-arena-20261025-023405-9491d40df3d3.tar.gz vérifiée.
Historique complet et intègre ; 240 fichiers identiques au commit et à la livraison validée.
Le statut « commit en attente » ci-dessus décrit la livraison de validation antérieure.
