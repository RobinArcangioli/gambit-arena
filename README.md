# Gambit Arena — STEP-020

Prototype Godot Android portrait avec mannequins 3D temporaires.
STEP-019 clôturée au commit 4125d44 ; STEP-020 validée, commit en attente.
F6, tests manuels et fluidité confirmés OK par l’utilisateur.

F5 : toucher le résumé d'une des trois règles pour modifier cible, condition, seuil
et action. Le formulaire met le combat en pause. Appliquer valide les quatre champs
ensemble ; Annuler abandonne le brouillon. Les deux gardent la pause : reprise explicite.
Les boutons de champ parcourent les options ; le seuil dispose de -5/-1/+1/+5.
Les associations incompatibles affichent une raison et bloquent Appliquer.

Oui/Non et Haut/Bas restent disponibles hors formulaire. Rejouer et scénario conservent
tous les champs, l'ordre et l'activation ; pas de sauvegarde sur disque.
Les actions engagées ne sont pas annulées par l'édition. Le correctif d'immobilité du
héros à portée reste inchangé. Les six emplacements futurs restent masqués dans ce labo.

F6 dans scenes/tests/ : gambit_fields_tests, attack_stationary_tests,
gambit_editor_tests, gambit_diagnostics_tests, gambit_controller_tests,
gambit_tests, lifecycle_tests et combat_simulation_tests. F8 entre les bancs.
Attendu : OK, zéro échec et aucun nouvel avertissement. Godot non exécuté chez l'assistant.

- [Recette STEP-020](docs/steps/STEP-020.md)
- [Champs de règle](docs/gambit-fields.md), [éditeur](docs/gambit-editor.md)
- [Architecture](ARCHITECTURE.md), [état](PROJECT_STATUS.md), [roadmap](ROADMAP.md)
- [Android](docs/android.md), [sauvegarde](docs/backup.md)

Version Android 0.1.0-step020, code 19. Export Debug hors dépôt.
Validation reçue : commit puis sauvegarde complète à effectuer.
