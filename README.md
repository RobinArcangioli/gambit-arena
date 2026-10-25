# Gambit Arena — STEP-021

Prototype Godot Android portrait avec mannequins 3D temporaires.
STEP-020 clôturée au commit ac58190 ; STEP-021 validée, commit en attente.
F6, tests manuels et fluidité confirmés OK par l’utilisateur.

F5 : HUD portrait avec PV/énergie chiffrés et barres, action en cours, délais des
compétences, ennemis et état du combat. L'arène dispose d'une zone distincte.
Trois résumés de gambits ouvrent l'éditeur STEP-020 ; Oui/Non et Haut/Bas conservés.
Si la hauteur manque, faire défiler la liste. Le formulaire garde Appliquer/Annuler
fixes et permet le défilement des champs. Les boutons font au moins 48 px logiques
sur les dimensions de recette (zone utile minimale 360 × 640).

Les zones sûres Android sont converties en coordonnées du viewport ; elles sont
réévaluées au redimensionnement, au retour et lors des changements de barres système.
Le cadrage ajuste le zoom pour garder l'arène visible ; aucun changement de combat
ou d'animation. Le correctif d'immobilité à portée reste inchangé.

F6 : portrait_hud_tests, gambit_fields_tests, attack_stationary_tests,
gambit_editor_tests, gambit_diagnostics_tests, gambit_controller_tests,
gambit_tests, lifecycle_tests et combat_simulation_tests dans scenes/tests/.
F8 entre les bancs. Attendu : OK, zéro échec et aucun nouvel avertissement.
Godot non exécuté chez l'assistant ; validation visuelle et tactile à faire sur appareil.

- [Recette STEP-021](docs/steps/STEP-021.md)
- [HUD portrait](docs/portrait-hud.md), [champs](docs/gambit-fields.md)
- [Architecture](ARCHITECTURE.md), [état](PROJECT_STATUS.md), [roadmap](ROADMAP.md)
- [Android](docs/android.md), [sauvegarde](docs/backup.md)

Version Android 0.1.0-step021, code 20. Export Debug hors dépôt.
Validation reçue : commit puis sauvegarde complète à effectuer.

V2 — FIX-STEP-021-001 : hauteur réelle des lignes prise en compte pour rendre
la dernière règle entièrement accessible. Nouveau contrôle avec police agrandie.
Correctif v2 inclus dans la validation utilisateur de STEP-021.
