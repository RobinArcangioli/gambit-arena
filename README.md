# Gambit Arena — STEP-023

Prototype Godot Android portrait avec mannequins 3D temporaires.
STEP-022 clôturée au commit 307e8c6 ; STEP-023 validée, commit en attente.
F6, tests manuels et fluidité confirmés OK ; anomalie de swipe reportée à STEP-024.

F5 : les trois cartes Attaque, Soin et Spéciale commandent maintenant une compétence.
Une seule commande attend, prioritaire sur les gambits, pendant trois secondes de temps
de jeu. Un nouvel appui valide la remplace et renouvelle ce délai. L'action déjà engagée
se termine normalement ; le nouvel appui ne la coupe pas. Les trois réserves restent inactives.

Les attaques ciblent l'ennemi vivant le plus proche au moment de l'appui, avec approche
si nécessaire. Cette cible reste verrouillée pour la commande ; sa disparition annule
l'attente. Le soin vise soi-même. L'exécuteur partagé revalide avant tout coût/effet.
En pause : compteur figé, nouveaux appuis refusés. Rejouer efface l'attente et conserve
les gambits et la pause. Les gambits reprennent après exécution, expiration ou annulation.
Le détail sous les cartes précise l'attente, le motif et les refus ; il reste défilable.

Sans appui manuel, le combat automatique suit le même chemin qu'en STEP-022.
Animations et correctif d'immobilité à portée inchangés.
La scène historique skill_slots_lab conserve la consultation seule pour sa régression.

F6 : manual_commands_tests, puis les dix bancs de régression listés dans la recette.
F8 entre les bancs. Attendu : OK, zéro échec et aucun nouvel avertissement.
Godot non installé chez l'assistant : aucune compilation ni exécution F6 réalisée ici.

- [Recette STEP-023](docs/steps/STEP-023.md)
- [Commande manuelle](docs/manual-commands.md), [emplacements](docs/skill-slots.md)
- [Architecture](ARCHITECTURE.md), [état](PROJECT_STATUS.md), [roadmap](ROADMAP.md)
- [Android](docs/android.md), [sauvegarde](docs/backup.md)

Version Android 0.1.0-step023, code 22. Export Debug hors dépôt.
Validation reçue : commit puis sauvegarde complète à effectuer.
