# FIX-STEP-021-001 — Hauteur réelle de la liste de gambits

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

Empreinte STEP-021 v2 corrigée par l’utilisateur : 224dfb87269dd7cd4a955eb3813711fdfb6c72b68af8e060ffa39a5d94a68b35.
La première empreinte transmise répétait celle de STEP-020 par erreur.

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
