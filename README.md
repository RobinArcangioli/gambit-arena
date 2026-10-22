# Gambit Arena

Godot 4.7.2 standard, Compatibility, Android portrait 540 × 960.
Personnages 3D sur fond 2D dimétrique, taille de référence 48 px.

## État

STEP-008 clôturée dans 46dfaa7 ; sauvegarde restaurée, historique complet et
90 fichiers versionnés identiques. Tests manuels validés, aucune saccade observée,
verrouillage et réduction/retour OK. STEP-009 validée, commit en attente.
Tests manuels et F6 OK, fluidité confirmée par l’utilisateur.
F5 ouvre STEP-009 / CONTACTS : séparation au sol et blocage par les acteurs.
Les anciens laboratoires restent disponibles avec F6, sans modification de leur code.

## Lancer et tester

Ouvrir project.godot, attendre l’import, puis ouvrir
scenes/tests/ground_crowd_tests.tscn et lancer F6. Attendu : OK, zéro échec.
Le banc peut prendre quelques secondes. F8 arrête ; F5 lance le laboratoire.
Godot absent chez l’assistant : aucun lancement, rendu ni export effectué ici.

| Scénario | Comportement attendu |
|---|---|
| 1/4 Encerclement | Héros fixe, jusqu’à 20 ennemis arrivant des côtés ; ils occupent des positions distinctes autour de lui. |
| 2/4 Poursuite | Héros sur route automatique ; contacts pouvant le ralentir ou le bloquer. |
| 3/4 Blocage | Six ennemis fixes encerclent le héros ; il ne franchit pas la couronne. Ouvrir passage lui permet de reprendre. |
| 4/4 Bordure | Héros près d’un coin, deux ennemis volontairement superposés dans le coin opposé ; séparation progressive puis afflux. |

| Commande | Touche | Effet |
|---|---|---|
| Scénario | P | Réinitialise dans le mode suivant |
| Apparitions / Ouvrir passage | S | Suspend les nouvelles apparitions ou retire le gardien du passage |
| Rejouer | R | Recrée le scénario, remet compteurs et maximum de déplacement à zéro |
| Pause/Reprendre | Espace | Fige temps, poses, corrections et apparitions |
| Repères | G | Limites, pieds et disques de contact projetés au sol |

Les disques sont des empreintes au sol : les silhouettes peuvent encore se
masquer dans la projection. Les contacts n’organisent pas des places de combat.
Un acteur bloqué attend ; pas de pathfinding, poussée illimitée ou téléportation.
Rejouer reste disponible en pause sans reprendre la simulation. Les six cases
À venir restent inactives. Le retour d’arrière-plan demande une reprise explicite.

## Android et sauvegarde

Recette : docs/steps/STEP-009.md. Exporter Android Debug avec débogage vers
~/gambit-arena-builds/step-009-debug.apk. Version 0.1.0-step009, code 8.
Archive complète : gambit-arena-complet-step-009-validation.tar.gz. Le bundle séparé
contient l’historique jusqu’à 46dfaa7, pas STEP-009 encore non commitée.
Conserver les nouveaux .gd.uid générés par Godot. Après validation explicite,
archive documentaire de validation, commit propre puis bash tools/create_backup.sh.

## Documents

PROJECT_STATUS.md, ROADMAP.md, ARCHITECTURE.md, docs/crowd.md,
docs/steps/STEP-009.md, docs/enemies.md et docs/android.md.
