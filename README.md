# Gambit Arena

Godot 4.7.2 standard, Compatibility, Android portrait. Personnages 3D sur fond
2D dimétrique, déplacement automatique et futurs gambits.

## État

STEP-006 validée et sauvegardée dans 1cc7f05. STEP-007 validée par l’utilisateur
le 22 octobre 2026, commit en attente. Banc F6 : OK, zéro échec ; scénarios
de déplacement confirmés et APK installé avec succès.
Un héros cyan approche une cible orange automatiquement. La logique d’approche
est séparée de la source de cibles de diagnostic. Pas de combat ni d’IA ennemie.

## Lancer et tester

Ouvrir project.godot et attendre l’import. Ouvrir d’abord
scenes/tests/ground_mover_tests.tscn puis F6 : résultat attendu OK, zéro échec.
F8 arrête ce test ; F5 lance le laboratoire STEP-007 / APPROCHE.
Le scénario initial fait approcher A, attendre 0,5 s, approcher B, attendre
0,5 s puis supprimer l’intention de cible. Rejouer recommence.

| Commande | Touche | Fonction de diagnostic |
|---|---|---|
| Scénario 1/4 à 4/4 | P | A puis B, Axes, Bordure, Disparition |
| Cible A / Cible B | A / B | Remplace l’intention, y compris en mouvement |
| Aucune | N | Annule l’intention et arrête le héros |
| Rejouer | R | Réinitialise le scénario et réactive sa séquence automatique |
| Pause / Reprendre | Espace | Suspend mouvement, séquence et pose |
| Repères | G | Limites, axes et ancrages |

Le choix explicite A/B/Aucune désactive la séquence automatique jusqu’à Rejouer.
Ce sont des commandes de recette, pas un contrôle manuel du déplacement futur.
Toucher le sol ne déplace rien. Les six cases À venir restent inactives.
Rejouer reste possible en pause et conserve cet état ; les choix de cible et le
changement de scénario sont bloqués en pause. Retour d’arrière-plan : reprise explicite.

Vitesse nominale : 1,2 unité de sol/s ; distance d’arrêt : 0,8 unité.
La vitesse affichée est la distance réellement parcourue par seconde de simulation ;
elle peut diminuer sur le dernier pas ou contre une limite. Le déplacement affiché
en pixels dépend de la direction dimétrique, pas la vitesse au sol.

## Android

Recette complète : docs/steps/STEP-007.md. Exporter Android Debug avec débogage
vers ~/gambit-arena-builds/step-007-debug.apk, jamais dans le dépôt.
Version 0.1.0-step007, code 6 ; paquet et signature conservés. Voir docs/android.md.
Godot absent chez l’assistant : tests fournis mais non exécutés ici.

## Sources et sauvegardes

Les anciens diagnostics restent disponibles via F6, dont scenes/arena/arena.tscn
pour l’arène statique STEP-006. F5 utilise la scène dérivée de déplacement.
Conserver les nouveaux .gd.uid générés par Godot pour le commit validé.
L’archive complète contient le bundle de base 1cc7f05, sans les modifications
STEP-007 non commitées. Après validation et commit propre :
bash tools/create_backup.sh, puis transmettre la sauvegarde.

## Documents

PROJECT_STATUS.md, ROADMAP.md, ARCHITECTURE.md, docs/movement.md,
docs/arena.md, docs/hybrid-rendering.md, docs/android.md et docs/steps/STEP-007.md.
