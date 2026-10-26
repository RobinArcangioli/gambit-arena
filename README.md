# Gambit Arena

Prototype Godot Android portrait : héros autonome piloté par trois gambits, commandes
manuelles de compétences, trois vagues, pause et redémarrage. Personnages 3D procéduraux
sur arène dimétrique ; assets et équilibrage encore provisoires.

**STEP-028 est clôturée — 580ce64, poussée et sauvegarde vérifiée.**
La [roadmap graphique validée](docs/graphics-roadmap.md) prévoit des arènes interchangeables,
des personnages 3D et les animations d'attaque, de soin et de Foudre, avant STEP-029/030.
GRAPHICS-001 est en recette : Colisée solaire dans Main, terrain de référence conservé et
[galerie indépendante](scenes/debug/graphics_lab.tscn) pour vérifier les deux présentations.
Base de travail : HANDOFF-001, cc91c79, main publiée sur GitHub et vérifiée le 26 octobre.
STEP-028 ajoute une collecte de performance bornée et un protocole Android. Les mesures Debug
n'atteignent pas l'ancien seuil de 30 FPS, mais les performances ont été explicitement acceptées
pour le périmètre prévu ; la fixture de 20 ennemis est un stress test. Voir
[les mesures](docs/performance.md).

## Reprendre le projet

Commencer par [HANDOFF.md](HANDOFF.md), puis [PROJECT_STATUS.md](PROJECT_STATUS.md).
La passation contient les décisions, l’architecture, l’historique, la méthode de travail,
les tests, les commandes GitHub et un prompt prêt à transmettre à une autre IA.

## Lancer

Environnement documenté : Godot 4.7.2 standard, rendu Compatibility, référence 540 × 960,
Android portrait. Importer project.godot avec les templates correspondant à la version
installée. F5 lance Main/PerformanceLab, couche optionnelle au-dessus d'ApplicationLab.
Le bouton GAMBIT / Mesures ouvre les diagnostics ; hors capture, le combat reste ordinaire.
Les scènes sous scenes/tests se lancent avec F6,
puis F8 entre bancs. Voir [les tests](docs/handoff/TESTING.md) et [Android](docs/android.md).

Version GRAPHICS-001 : 0.1.0-graphics001, code 29 ; sortie Android Debug :
../gambit-arena-builds/graphics-001-debug.apk. APK de référence mesuré pour STEP-028 :
`d2c710ef6fb1c935eb6afecbfe54e98b1a03d0a03266753c5c8b537cce1a23b9`.
Pour STEP-027, F6, tests manuels et fluidité ont été confirmés par l’utilisateur.
Pour STEP-028, voir les [résultats et limites](docs/steps/STEP-028.md) : l'utilisateur a
validé F6, F5, tactile Android et pause/reprise ; le commit reste en attente.

## Documentation

- [Architecture](ARCHITECTURE.md) et [décisions à préserver](docs/handoff/STATE_AND_DECISIONS.md).
- [Roadmap complète](ROADMAP.md) et [étapes restantes](docs/handoff/NEXT_STEPS.md).
- [Méthode de livraison](docs/handoff/DEVELOPMENT_GUIDE.md).
- [Historique](docs/handoff/HISTORY.md), [sauvegardes](docs/backup.md).
- [Commit/push/restauration](docs/handoff/GITHUB.md).
- [Assets et provenance](docs/assets.md).
- [Présentation des arènes et remplacement du fond](docs/arena-presentation.md).

STEP-028 : validée, commit/sauvegarde à faire ; STEP-029 : reproductibilité clone/export ; STEP-030 : recette finale.
La licence publique globale reste à choisir par le propriétaire.
