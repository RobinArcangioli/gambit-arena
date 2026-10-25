# État du projet

## Base confirmée

STEP-020 clôturée : ac581907fc1a5a9b3bc4573a75d35805e2ebf151, main propre.
Parent : 4125d44e048c34f6ff8ae197e2d912e2db57fad5.
Sauvegarde gambit-arena-20261025-014820-ac581907fc1a.tar.gz restaurée et vérifiée :
historique complet et intègre ; 229 fichiers identiques au commit et à la livraison validée.
F6, tests manuels et fluidité confirmés OK ; retour global sans détail par banc.
SHA-256 APK : 084cc3ea0e03a553f00a111683f048db0b5f4331a3c5b6782c4aa872b5cfe97e.

## STEP-021 — Validée, commit en attente

GO reçu le 25 octobre 2026. HUD portrait distinct de l'arène, valeurs et barres,
états lisibles, liste et formulaire défilables, marges sûres et cadrage ajusté.
Livraison : gambit-arena-complet-step-021-v2.tar.gz.
Version Android 0.1.0-step021, code 20. Validation et empreinte APK reçues.

## Contrôles et limites

Contrôles statiques des références, UID, changements autorisés et contenu de l'archive.
Godot absent : aucune compilation GDScript ni exécution moteur chez l'assistant.
Retour utilisateur : F6 OK, tests manuels OK, fluidité OK.
Retour global, sans résultat séparé par banc ni mesure chiffrée de performance.
Zone utile de recette minimale : 360 × 640 logiques. Référence : 540 × 960.
Les barres système réelles et le défilement tactile exigent la vérification sur Galaxy A16.
Aucun changement de combat/animation ni nouvelle commande manuelle.

## Prochaine action

Appliquer l’archive de validation, vérifier le diff puis commiter.
Transmettre le hash, le statut Git et la sauvegarde complète créée.
STEP-022 attend clôture et GO : six emplacements, trois compétences et disponibilité visible.

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
