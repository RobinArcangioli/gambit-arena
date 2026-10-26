# Gambit Arena

Prototype Godot Android portrait : héros autonome piloté par trois gambits, commandes
manuelles de compétences, trois vagues, pause et redémarrage. Personnages 3D procéduraux
sur arène dimétrique ; assets et équilibrage encore provisoires.

**État : STEP-027 validée, commitée et sauvegardée — 665c0c8.**
La passation HANDOFF-001 ajoute uniquement la documentation. Aucun push GitHub n’est
confirmé à sa rédaction et aucune étape de performance n’est encore réalisée.

## Reprendre le projet

Commencer par [HANDOFF.md](HANDOFF.md), puis [PROJECT_STATUS.md](PROJECT_STATUS.md).
La passation contient les décisions, l’architecture, l’historique, la méthode de travail,
les tests, les commandes GitHub et un prompt prêt à transmettre à une autre IA.

## Lancer

Environnement documenté : Godot 4.7.2 standard, rendu Compatibility, référence 540 × 960,
Android portrait. Importer project.godot avec les templates correspondant à la version
installée. F5 lance Main/ApplicationLab. Les scènes sous scenes/tests se lancent avec F6,
puis F8 entre bancs. Voir [les tests](docs/handoff/TESTING.md) et [Android](docs/android.md).

Version actuelle : 0.1.0-step027, code 27 ; sortie Android Debug :
../gambit-arena-builds/step-027-debug.apk. SHA-256 du dernier APK validé :
`07467efcfb7e663e363e6f6fc61644fd2bf2889e7ee3a3001d42589e0c6cf611`.
F6, tests manuels et fluidité ont été confirmés par l’utilisateur. Aucune mesure chiffrée
ni exécution moteur chez l’assistant n’est revendiquée.

## Documentation

- [Architecture](ARCHITECTURE.md) et [décisions à préserver](docs/handoff/STATE_AND_DECISIONS.md).
- [Roadmap complète](ROADMAP.md) et [étapes restantes](docs/handoff/NEXT_STEPS.md).
- [Méthode de livraison](docs/handoff/DEVELOPMENT_GUIDE.md).
- [Historique](docs/handoff/HISTORY.md), [sauvegardes](docs/backup.md).
- [Commit/push/restauration](docs/handoff/GITHUB.md).
- [Assets et provenance](docs/assets.md).

STEP-028 : mesures ; STEP-029 : reproductibilité clone/export ; STEP-030 : recette finale.
La licence publique globale reste à choisir par le propriétaire.
