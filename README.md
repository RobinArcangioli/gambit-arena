# Gambit Arena — STEP-010

Prototype Godot Android portrait : fond 2D et mannequins 3D temporaires.
STEP-009 clôturée au commit ec576ce ; STEP-010 validée, commit en attente.
Tests manuels et F6 OK, aucun doublon confirmé par l’utilisateur.

F5 ouvre le laboratoire des statistiques et PV : un héros et deux ennemis.
Dégâts, soins et attaque sont propres à l'acteur sélectionné. Les ennemis
partagent leur profil de départ, jamais leurs PV courants. À zéro PV, l'acteur
est masqué et ne peut pas être soigné ; Rejouer recrée les états.

Cible/P, Dégâts/D, Soin/H, ATQ/T, Fatal/K, Rejouer/R, Pause/Espace, Repères/G.
Six emplacements de compétences toujours inactifs. Aucun combat automatique.

Ouvrir scenes/tests/actor_state_tests.tscn puis F6 : attendu OK, zéro échec.
F8 arrête. Godot n'a pas été exécuté chez l'assistant.
Les anciens laboratoires et assets sont conservés et accessibles avec F6.

- [Recette STEP-010](docs/steps/STEP-010.md)
- [Statistiques et PV](docs/stats.md)
- [Architecture](ARCHITECTURE.md)
- [État](PROJECT_STATUS.md), [roadmap](ROADMAP.md)
- [Android](docs/android.md), [sauvegarde](docs/backup.md)

Version Android 0.1.0-step010, code 9 ; export Debug hors dépôt.
Validation utilisateur reçue : commit puis sauvegarde complète à effectuer.
