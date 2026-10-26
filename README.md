# Gambit Arena — STEP-027

STEP-026 clôturée au commit 344a584 ; sauvegarde vérifiée, 297 fichiers conformes.
STEP-027 : Validée, commit en attente. F5 ouvre ApplicationLab, qui conserve le combat
à trois vagues, le ciblage fix1 et le bilan/replay STEP-026.

Perdre le focus ou mettre l’application en arrière-plan impose la pause. Le retour ne
reprend jamais le combat automatiquement : toucher Reprendre une fois l’application
revenue. Le premier pas de simulation après cette reprise est ignoré ; les suivants
utilisent l’horloge existante, sans rattraper le temps passé hors application.
Les actions, coûts déjà payés, cooldowns, commandes en attente et vagues sont conservés.

Les entrées sont bloquées pendant l’absence de focus/suspension. Un ancien relâchement
ne doit ni commander une compétence, ni activer Reprendre/Rejouer. Un geste neuf reste
utilisable au retour. Le formulaire garde son brouillon et la pause ; la zone sûre est
recalculée. Une défaite reste terminale. Aucune reprise de partie après arrêt du processus
n’est ajoutée : les configurations restent en mémoire de session, sans sauvegarde persistante.

F6 : application_lifecycle_tests.tscn, puis les régressions de la
[recette STEP-027](docs/steps/STEP-027.md). F8 entre chaque banc.
Godot absent chez l’assistant : contrôles statiques uniquement, tests moteur à exécuter.
Les notifications synthétiques du banc ne prouvent pas le comportement du téléphone :
la recette Android (Accueil, applications récentes, verrouillage) est obligatoire.

- [Cycle de l’application](docs/application-lifecycle.md)
- [Architecture](ARCHITECTURE.md), [état](PROJECT_STATUS.md), [roadmap](ROADMAP.md)
- [Android](docs/android.md), [sauvegarde](docs/backup.md)

Android 0.1.0-step027, code 27. Export : ../gambit-arena-builds/step-027-debug.apk.
Validation reçue : commit et sauvegarde à effectuer. Animations, profils et logique de combat inchangés.

## Validation utilisateur — 26 octobre 2026

STEP-027 explicitement validée : F6 OK, tests manuels OK, fluidité OK.
Retour global, sans résultats séparés par banc ou mesure chiffrée ; aucune réserve signalée.
APK : step-027-debug.apk ; version 0.1.0-step027, code 27.
SHA-256 : 07467efcfb7e663e363e6f6fc61644fd2bf2889e7ee3a3001d42589e0c6cf611.
Statut : Validée, commit en attente.

Archive : gambit-arena-complet-step-027-validation.tar.gz.
Seule la documentation change depuis v1 ; code, scènes, tests et configuration identiques.
Aucun lancement Godot chez l’assistant. Les instructions de recette précédentes décrivent
la validation maintenant reçue ; aucun nouveau test requis pour cette mise à jour documentaire.
Prochaine action : commit, statut propre et sauvegarde complète à transmettre.
STEP-028 attend clôture et nouveau GO.
