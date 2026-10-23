# Gambit Arena — STEP-016

Prototype Godot Android portrait avec mannequins 3D temporaires.
STEP-015 clôturée au commit dd9fec8 ; STEP-016 validée, commit en attente.
F6, tests manuels et fluidité confirmés OK par l’utilisateur.

F5 : laboratoire de décisions de gambits à 10 Hz, sans exécution de compétences.
Trois règles : soi PV < 50 % → soin ; ennemi → spéciale ; ennemi → attaque.
Première règle applicable, ennemi admissible le plus proche, égalité par ID stable.
Une cible distante produit une intention d'approche ; les acteurs restent immobiles.

Boutons provisoires : Blesser/A, Rétablir/H, Énergie/S, CD spéciale/D, Évaluer/E,
Rejouer/R. Scénario/P, Pause/Espace, Repères/G. Six cases À venir inactives.
Scénarios : Priorités, Hors portée, Égalité, Sans cible.

F6 : scenes/tests/gambit_tests.tscn. Attendu : OK, zéro échec.
Relancer lifecycle_tests.tscn et combat_simulation_tests.tscn en non-régression.
F8 entre les bancs. Godot non exécuté chez l'assistant.

- [Recette STEP-016](docs/steps/STEP-016.md)
- [Contrat des gambits](docs/gambits.md)
- [Architecture](ARCHITECTURE.md), [état](PROJECT_STATUS.md), [roadmap](ROADMAP.md)
- [Android](docs/android.md), [sauvegarde](docs/backup.md)

Version Android 0.1.0-step016, code 15. Export Debug hors dépôt.
Validation reçue : commit puis sauvegarde complète à effectuer.
