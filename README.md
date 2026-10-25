# Gambit Arena — STEP-026

STEP-025 avec fix1 clôturée au commit f62162d ; sauvegarde vérifiée, 289 fichiers conformes.
STEP-026 : Validée, commit en attente. F5 ouvre RunLifecycleLab : trois vagues progressives,
ciblage conservé tant que la cible vit et reste à portée, et bilan de fin de partie figé.

La défaite arrête les actions, commandes, mouvements et arrivées. Le HUD indique le résultat,
les vagues terminées, vaincus, arrivés et survivants. Les détails des compétences donnent
le bilan complet. Rejouer crée une partie neuve avec les mêmes gambits et le même état de
pause. Aucun acteur ou effet d’une ancienne partie ne doit agir sur la suivante.

Le nouveau banc vérifie dix resets consécutifs du coordinateur et dix clics réels sur
Rejouer, des morts en pause, des actions et commandes en attente, les références et signaux,
les comptes, un bilan de victoire, le nettoyage de 20 ennemis et la sortie du coordinateur.
Les modes Combat/Soin/Charge, profils, animations, routeur tactile et règle de cible fix1
sont conservés. Normal : trois fois 12 ennemis, plafond 6 ; Charge : trois fois 24, plafond 20.

F6 : run_lifecycle_tests.tscn, puis les régressions de la [recette STEP-026](docs/steps/STEP-026.md).
F8 entre chaque banc. Godot absent chez l’assistant : contrôles statiques uniquement.
Validation utilisateur globale reçue : F6, tests manuels et fluidité OK.

- [Défaite et Rejouer](docs/run-lifecycle.md)
- [Architecture](ARCHITECTURE.md), [état](PROJECT_STATUS.md), [roadmap](ROADMAP.md)
- [Android](docs/android.md), [sauvegarde](docs/backup.md)

Android 0.1.0-step026, code 26. Export : ../gambit-arena-builds/step-026-debug.apk.
Validation reçue : commit et sauvegarde à effectuer. Équilibrage et performance restent à qualifier.

## Validation utilisateur — 25 octobre 2026

STEP-026 explicitement validée : F6 OK, tests manuels OK, fluidité OK.
Retour global, sans résultats séparés par banc ou mesure chiffrée ; aucune réserve signalée.
APK : step-026-debug.apk ; version 0.1.0-step026, code 26.
SHA-256 : 1c6e699d3acf44a6f3e5ce6e85d333ac9bb60c14e946a548992bd5eb099a47a2.
Statut : Validée, commit en attente.

Archive : gambit-arena-complet-step-026-validation.tar.gz.
Seule la documentation change depuis v1 ; code, scènes, tests et configuration identiques.
Aucun lancement Godot chez l’assistant. Les instructions de recette précédentes décrivent
la validation maintenant reçue ; aucun nouveau test requis pour cette mise à jour documentaire.
Prochaine action : commit, statut propre et sauvegarde complète à transmettre.
STEP-027 attend clôture et nouveau GO.
