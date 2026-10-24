# Gambit Arena — STEP-019

Prototype Godot Android portrait avec mannequins 3D temporaires.
STEP-018 clôturée au commit 4719e8d ; STEP-019 validée, commit en attente. Correctif v2 inclus.

F5 : trois gambits visibles, activables avec Oui/Non et réordonnables avec Haut/Bas.
La première règle disponible gagne. Configuration modifiable en jeu ou en pause,
conservée par Rejouer et les changements de scénario ; non sauvegardée sur disque.
Une action engagée finit normalement ; une intention en attente est oubliée.

Rejouer/R, scénario/P (Combat, Soin, Groupe 20), Pause/Espace, repères/G.
Le panneau des règles remplace les six emplacements réservés dans ce laboratoire.
Les anciennes scènes et leurs emplacements restent disponibles. Aucun champ éditable
(cible, condition, seuil ou action) ni commande manuelle ajouté à cette étape.

F6 dans scenes/tests/ : attack_stationary_tests, gambit_editor_tests, gambit_diagnostics_tests,
gambit_controller_tests, gambit_tests, lifecycle_tests et combat_simulation_tests.
Attendu : OK, zéro échec par banc ; F8 entre les bancs.
Godot non exécuté chez l'assistant ; rendu et tactile à vérifier sur appareil.

- [Recette STEP-019](docs/steps/STEP-019.md)
- [Éditeur](docs/gambit-editor.md), [diagnostics](docs/gambit-diagnostics.md)
- [Architecture](ARCHITECTURE.md), [état](PROJECT_STATUS.md), [roadmap](ROADMAP.md)
- [Android](docs/android.md), [sauvegarde](docs/backup.md)

Version Android 0.1.0-step019, code 18. Export Debug hors dépôt.
Validation reçue : commit puis sauvegarde complète à effectuer.

V2 — FIX-STEP-019-001 : le héros cesse son approche lorsque sa cible est déjà à portée.
Animation inchangée ; nouveau banc attack_stationary_tests. Correctif validé par le retour utilisateur global.
