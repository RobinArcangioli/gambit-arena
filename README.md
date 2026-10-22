# Gambit Arena — STEP-011

Prototype Godot Android portrait : fond 2D et mannequins 3D temporaires.
STEP-010 clôturée au commit ba56209 ; STEP-011 validée, commit en attente.
F6, tests manuels et fluidité confirmés OK par l’utilisateur.

F5 ouvre le laboratoire d'attaque : un héros, deux ennemis passifs, une action
identifiée. Préparation 0,6 s, impact unique à portée 1,0 u, récupération 0,4 s.
La cible est verrouillée ; vie et portée sont contrôlées à l'impact.
Dégâts proposés : max(1, attaque - défense), soit 11 PV sur le profil ennemi.

Scénario/P, Attaquer/A, Cible/T, Éloigner A/E, Tuer cible/K, Tuer héros/H,
Rejouer/R, Pause/Espace, Repères/G. Scénarios automatiques d'invalidation
pendant la préparation : sortie de portée, mort cible/héros, retrait cible.

Ouvrir scenes/tests/attack_action_tests.tscn puis F6 : attendu OK, zéro échec.
F8 arrête. Godot n'a pas été exécuté chez l'assistant.
Anciens laboratoires, scripts, profils et assets conservés.
Six emplacements inactifs ; pas encore de combat autonome ni animation finale.

- [Recette STEP-011](docs/steps/STEP-011.md)
- [Actions](docs/actions.md), [statistiques](docs/stats.md)
- [Architecture](ARCHITECTURE.md), [état](PROJECT_STATUS.md), [roadmap](ROADMAP.md)
- [Android](docs/android.md), [sauvegarde](docs/backup.md)

Version Android 0.1.0-step011, code 10. Export Debug hors dépôt.
Validation reçue : commit puis sauvegarde complète à effectuer.
