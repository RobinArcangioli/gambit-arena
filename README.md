# GAMEPLAY-001 et fix1 validés

Le propriétaire confirme « Steps validée. ». La livraison fix1, APK 0.1.0-gameplay001-fix1
(code 33), est validée. Les sources non documentaires sont identiques à la livraison.
Clôture par un commit unique, fix1 inclus, puis sauvegarde vérifiée. GRAPHICS-004 est la
prochaine étape ; attendre GO. Les statuts de recette antérieurs ci-dessous sont historiques.

# GAMEPLAY-001-fix1 — correctif en recette

Le soin inclut Anne et privilégie le plus bas pourcentage de PV. La mana est débitée
uniquement à l'effet réussi ; une annulation pendant l'incantation ne coûte rien.
32 bancs / 1 959 contrôles passent. APK 0.1.0-gameplay001-fix1 (33) installé sur A16.
Voir docs/steps/GAMEPLAY-001-fix1.md et docs/party-gameplay.md. Les états de livraison
précédents ci-dessous sont historiques. Validation de GAMEPLAY-001 toujours attendue.

# GAMEPLAY-001 — équipe et incantations en recette

Anne et Mako combattent ensemble : Anne soigne un allié, Mako lance Foudre. Chaque héros a
ses compétences et trois gambits. Vie rouge, mana bleu, incantation jaune or au-dessus de
tous les acteurs ; Soin 1,5 s, Foudre 2 s. Sélection du héros dans le HUD, reprise explicite.
F6 : [équipe](scenes/party/party_application.tscn), puis F8/F5 : partie complète.
[Recette et APK](docs/steps/GAMEPLAY-001.md), [paramètres et architecture](docs/party-gameplay.md).
31 bancs / 1 921 contrôles passent ; APK installé sur Galaxy A16. Équilibrage provisoire.
Les anciennes compositions ci-dessous restent accessibles comme bancs de référence.

# GRAPHICS-003 — recette disponible

Anne, Mako et les deux squelettes pirates sont intégrés avec repos et marche.
Main utilise Anne et le squelette avec crâne. F6 : [galerie des personnages](scenes/debug/character_lab.tscn),
F8 puis F5 : combat. [Recette et APK](docs/steps/GRAPHICS-003.md),
[modifier une apparence](docs/character-presentation.md).
28 bancs / 1 803 contrôles passent. APK GRAPHICS-003 installé sur Galaxy A16.
L'équipe Anne/Mako, les nouvelles compétences, les barres et incantations sont prévues
ensuite dans [GAMEPLAY-001](docs/party-skills-plan.md). Étape en attente de validation.

# Gambit Arena

Prototype Godot Android portrait : héros autonome piloté par trois gambits, commandes
manuelles de compétences, trois vagues, pause et redémarrage. Personnages 3D procéduraux
sur arène dimétrique ; assets et équilibrage encore provisoires.

**STEP-028 est clôturée — 580ce64, poussée et sauvegarde vérifiée.**
La [roadmap graphique validée](docs/graphics-roadmap.md) prévoit des arènes interchangeables,
des personnages 3D et les animations d'attaque, de soin et de Foudre, avant STEP-029/030.
GRAPHICS-001 est validée, commit local f5a790d et sauvegarde vérifiée.
GRAPHICS-002 est validée : huit arènes sélectionnables via **GAMBIT / Mesures → Choisir
l'arène**, également disponibles dans la [galerie indépendante](scenes/debug/graphics_lab.tscn).
Le choix conserve la partie en pause ; Reprendre est explicite.
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
installée. F5 lance Main/ArenaApplicationLab, qui étend PerformanceLab puis ApplicationLab.
Le bouton GAMBIT / Mesures ouvre les diagnostics ; hors capture, le combat reste ordinaire.
Les scènes sous scenes/tests se lancent avec F6,
puis F8 entre bancs. Voir [les tests](docs/handoff/TESTING.md) et [Android](docs/android.md).

Version GRAPHICS-002 : 0.1.0-graphics002, code 30 ; sortie Android Debug :
../gambit-arena-builds/graphics-002-debug.apk. APK de référence mesuré pour STEP-028 :
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

STEP-028 clôturée ; GRAPHICS-002 validée, commit autorisé ; GRAPHICS-003 attend les modèles 3D.
STEP-029 : reproductibilité clone/export ; STEP-030 : recette finale.
La licence publique globale reste à choisir par le propriétaire.
