# Gambit Arena

Godot 4.7.2 standard, Compatibility, Android portrait 540 × 960.
Personnages 3D sur fond 2D dimétrique, taille de référence 48 px.

## État

STEP-007 clôturée dans 9b3240c ; sauvegarde reçue et restaurée, 78 fichiers
versionnés identiques. STEP-008 validée le 22 octobre 2026, commit en attente.
Tests manuels OK, aucune saccade observée, verrouillage et réduction/retour OK.
F5 ouvre le laboratoire de poursuite. Le héros cyan est fixe ou suit une route
automatique ; les ennemis orange apparaissent sur les quatre côtés intérieurs.
Ils poursuivent sa position actuelle à 0,9 u/s et s’arrêtent à 0,8 unité.
Les chevauchements sont attendus : séparation prévue en STEP-009, combat ensuite.

## Lancer et tester

Ouvrir project.godot, attendre l’import et ouvrir
scenes/tests/enemy_director_tests.tscn. F6 : attendu OK, zéro échec.
F8 arrête les tests ; F5 lance STEP-008 / POURSUITE.
Le laboratoire STEP-007 et son banc F6 sont conservés sans modification.

| Commande | Touche | Effet |
|---|---|---|
| Scénario 1/3 à 3/3 | P | Héros fixe, héros mobile, plafond 20 |
| Apparitions oui/non | S | Suspend seulement les nouvelles apparitions |
| Retirer/Rendre héros | H | Retire/rétablit la cible logique des poursuivants |
| Rejouer | R | Vide les ennemis, remet le scénario à zéro |
| Pause/Reprendre | Espace | Fige déplacements, poses et cadence |
| Repères | G | Affiche les limites et les pieds |

Rejouer reste disponible en pause, sans reprise automatique. Repères reste actif.
Les autres commandes sont bloquées en pause. Retour d’arrière-plan : reprise
explicite. Le retrait du héros est un diagnostic, pas une mort de combat.
Les six cases À venir restent inactives. Toucher le sol ne commande rien.

## Android

Exporter Android Debug avec débogage vers ~/gambit-arena-builds/step-008-debug.apk.
Version 0.1.0-step008, code 7. Paquet, signature locale et rendu conservés.
Recette détaillée : docs/steps/STEP-008.md. Aucun lancement ni export Godot
exécuté chez l’assistant ; tests manuels validés par l’utilisateur.

## Sources et sauvegardes

Archive complète : gambit-arena-complet-step-008-validation.tar.gz, avec tous les fichiers
antérieurs et le bundle Git de base 9b3240c séparé. Ce bundle ne contient pas
STEP-008, encore non commitée. Ne pas supprimer le dépôt existant pour appliquer
la livraison. Après validation, livraison documentaire de clôture, commit et
bash tools/create_backup.sh. Conserver les nouveaux .gd.uid générés par Godot.

## Documents

PROJECT_STATUS.md, ROADMAP.md, ARCHITECTURE.md, docs/enemies.md,
docs/steps/STEP-008.md, docs/movement.md, docs/arena.md et docs/android.md.
