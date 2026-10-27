# GRAPHICS-009 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour le soin vert fluo à deux anneaux tournants.
APK normal 0.1.0-graphics009 (43), SHA-256
`fc84f63d53b40a9246b3d7466a32833026545ef8c4968b668fbe16881be16fc9`.
Validation globale, sans détail supplémentaire ni nouvelle mesure de performance.
Code, scènes, assets, configuration et APK identiques à la livraison validée ; seuls les
documents sont actualisés. Les 41 bancs / 2 574 contrôles déjà réussis ne sont pas relancés.
Clôture par un commit unique puis sauvegarde restaurée/vérifiée. GAMEPLAY-003 reste annulée :
tailles et contournements conservés. STEP-029 attend un nouveau GO, puis viendra STEP-030.
Les mentions de recette suivantes retracent les états historiques.

# GRAPHICS-009 — soin à deux anneaux en recette

Glow vert fluo et deux anneaux blanc/vert clair translucides, concentriques et tournant
sur deux axes distincts. Effet de réussite de 1,0 s avec fondu complet ; incantation 1,5 s,
règles et cibles inchangées. Voir docs/heal-presentation.md et docs/steps/GRAPHICS-009.md.
APK normal 0.1.0-graphics009 (43), installé sur Galaxy A16 et laissé en pause.
41 bancs / 2 574 contrôles passent. F6 : scenes/debug/heal_lab.tscn, « Soin (demo) ».
GAMEPLAY-003 reste annulée ; tailles, navigation et disques d'ombre conservés.
Étape non commitée ; attendre validation puis clôture avant STEP-029 et STEP-030.
Les états et durées visuelles suivants retracent les étapes historiques.

# GRAPHICS-008 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour les disques d'ombre indiquant le gabarit.
APK 0.1.0-graphics008 (42), SHA-256
`3cb968ff960280aece6b1636edd06f34fd33120eb7c429a89f5806011f11d8cc`.
Validation globale, sans détail supplémentaire ni nouvelle mesure de performance.
Code, scènes, assets, configuration et APK identiques à la livraison validée ; seuls les
documents sont actualisés. Les 40 bancs / 2 541 contrôles déjà réussis ne sont pas relancés.
Clôture par un commit unique puis sauvegarde restaurée/vérifiée. GAMEPLAY-003 reste annulée :
tailles et contournements conservés. STEP-029 attend un nouveau GO, puis viendra STEP-030.
Les mentions de recette et de réduction des gabarits suivantes sont historiques.

# GRAPHICS-008 — disques d'ombre en recette

GAMEPLAY-003 est complètement annulée à la demande du propriétaire : tailles et
contournements sont conservés (rayon 0,35, diamètre 0,70, échelle artistique 0,65).
Chaque personnage possède désormais un disque sombre translucide dimensionné selon
son corps de collision. Le style est réglable dans la présentation. Voir docs/ground-shadows.md
et docs/steps/GRAPHICS-008.md. 40 bancs / 2 541 contrôles passent ; 18 captures PC inspectées.
F6 : scenes/debug/footprint_shadow_lab.tscn ; F8/F5 : Main. APK 0.1.0-graphics008 (42), installé sur Galaxy A16 et laissé en pause.
Étape non commitée ; attendre validation avant clôture, puis STEP-029 et STEP-030.
Les mentions de réduction des tailles et de recette ci-dessous sont historiques.

# GAMEPLAY-002 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour la livraison du contournement local partagé.
APK normal 0.1.0-gameplay002 (41), installé sur Galaxy A16 et laissé en pause.
SHA-256 APK : `105021ffe77922674c6a9c90be8cd60a79f5a8cbd748776ff76bcf1e1e6d0505`.
Validation globale, sans détail supplémentaire ni nouvelle mesure de performance.
Code, scènes, assets et configuration identiques à la livraison validée ; seuls les documents
sont actualisés. Les 39 bancs / 2 481 contrôles et 28 cas Android déjà réussis ne sont pas
relancés pour cette clôture documentaire. Clôture par un commit unique puis sauvegarde
restaurée/vérifiée. GAMEPLAY-003 (gabarits plus fins) attend un nouveau GO.
Les mentions de recette et de préparation suivantes décrivent les états historiques.

# GAMEPLAY-002 — contournement local en recette

Anne, Mako et les squelettes partagent un navigateur local : détour, cache de chemin,
recalculs bornés et attente stable sans passage. GroundCrowd garde le contrôle de contact.
Rayon 0,35 et échelle 0,65 conservés. 39 bancs / 2 481 contrôles passent ; 28 scénarios
Android réussis et relevé de coût en combat réel. Voir docs/steps/GAMEPLAY-002.md et
docs/local-navigation.md. F6 : scenes/debug/local_navigation_lab.tscn ; F8/F5 : Main.
APK normal 0.1.0-gameplay002 (41), installé/lancé sur Galaxy A16.
Étape non commitée ; attendre validation avant clôture et GAMEPLAY-003.
Les sections suivantes décrivent les préparations et états historiques.

# Deux étapes ajoutées avant la livraison finale

À la demande du propriétaire : GAMEPLAY-002 ajoute un contournement local commun à tous
les héros/ennemis avec leurs dimensions actuelles ; GAMEPLAY-003 réduit ensuite leur emprise
et leur échelle visuelle pour faciliter les passages. Voir docs/local-navigation-plan.md et
les fiches docs/steps/GAMEPLAY-002.md / GAMEPLAY-003.md. Le plan est préparé ; aucun code de
mouvement ni gabarit n'est encore changé. GAMEPLAY-002 attend GO.
GRAPHICS-007 est clôturée au commit local 440829b, sauvegarde restaurée/vérifiée.
Ordre : GAMEPLAY-002 → GAMEPLAY-003 → STEP-029 → STEP-030.
APK normal actuel inchangé : 0.1.0-graphics007 (39). Les sections suivantes sont historiques.

# GRAPHICS-007 validée — 26 octobre 2026

Le propriétaire confirme « Step validée. » pour la livraison GRAPHICS-007,
APK normal 0.1.0-graphics007 (39), installé sur Galaxy A16.
SHA-256 APK : `adbbffbf33239c05622e83059827f45f32f263742631509d878617eca71b7231`.
Validation globale, sans détail supplémentaire ni nouvelle mesure FPS.
Les fichiers non documentaires sont identiques à la livraison validée ; les 37 bancs /
2 374 contrôles déjà réussis ne sont pas relancés pour cette clôture documentaire.
Clôture par un commit unique, puis sauvegarde et restauration vérifiées.
Le chantier GRAPHICS-001 à GRAPHICS-007 est validé. Prochaine étape : STEP-029,
clone/import/export/installation reproductibles ; attendre GO avant de la démarrer.
Les mentions de recette ci-dessous décrivent les états antérieurs.

# GRAPHICS-007 — qualification graphique en recette

GRAPHICS-006 clôturée au commit local 834f532, sauvegarde restaurée/vérifiée.
48 cas visuels inspectés sur Galaxy, 10 captures de coût graphique complètes et trois
remplacements artistiques démontrés. 37 bancs / 2 374 contrôles passent ; inventaire et
budgets documentés. Réserve : pointes lors des reconstructions du laboratoire.
Voir docs/steps/GRAPHICS-007.md et docs/graphics-qualification.md.
F6 : scenes/debug/graphics_qualification_lab.tscn ; F8/F5 retrouve Main.
APK normal 0.1.0-graphics007 (39), installé sur Galaxy A16 après la qualification code 38.
Étape non commitée ; attendre validation avant clôture et STEP-029.
Les sections suivantes décrivent les états historiques.

# GRAPHICS-006 validée — 26 octobre 2026

Le propriétaire confirme « Step validée. » pour la livraison GRAPHICS-006,
APK 0.1.0-graphics006 (37), installé sur Galaxy A16.
SHA-256 APK : `fa3303a96264d5d5e4d847854f1fe6ad7c1cfa9adad54d6227677d285a6c9910`.
Validation globale, sans détail supplémentaire ni nouvelle mesure FPS.
Les fichiers non documentaires sont identiques à la livraison validée ; les 36 bancs /
2 320 contrôles déjà réussis ne sont pas relancés pour cette clôture documentaire.
Clôture par un commit unique, puis sauvegarde et restauration vérifiées.
Prochaine étape : GRAPHICS-007, qualification graphique et remplacement des assets ;
attendre GO avant de la démarrer. Les mentions de recette ci-dessous sont historiques.

# GRAPHICS-006 — Foudre avec glow en recette

GRAPHICS-005 clôturée au commit local bf4904d, sauvegarde restaurée/vérifiée.
Éclair descendant rapide, cœur blanc bleuté, branches cyan et glow diffus, impact local.
Préparation liée à Duck et à la cible réelle ; succès uniquement après dégâts effectifs.
Scènes/profil/origine remplaçables ; pause et nettoyage, sans modification du gameplay.
36 bancs / 2 320 contrôles passent. Voir docs/steps/GRAPHICS-006.md et docs/lightning-presentation.md.
F6 : scenes/debug/lightning_lab.tscn, Foudre (demo), puis F8/F5 pour le vrai combat.
APK 0.1.0-graphics006 (37), installé et lancé sur Galaxy A16, version vérifiée par ADB.
Étape non commitée ; attendre validation avant clôture et GRAPHICS-007.
Les sections suivantes décrivent les états historiques.

# GRAPHICS-005 validée — 26 octobre 2026

Le propriétaire confirme « Step validée. » pour la livraison GRAPHICS-005,
APK 0.1.0-graphics005 (36), installé sur Galaxy A16.
SHA-256 APK : `060c79e8cedc6236d7d4ea33a7df8ec7245b9c938b94976fc9362f01251cc8da`.
Validation globale, sans détail supplémentaire ni nouvelle mesure FPS.
Les fichiers non documentaires sont identiques à la livraison validée ; les 35 bancs /
2 243 contrôles déjà réussis ne sont pas relancés pour cette clôture documentaire.
Clôture par un commit unique, puis sauvegarde et restauration vérifiées.
Prochaine étape : GRAPHICS-006, effet Foudre de Mako ; attendre GO avant de la démarrer.
Les mentions de recette ci-dessous décrivent les états antérieurs.

# GRAPHICS-005 — effet de soin en recette

GRAPHICS-004/fix1 clôturée au commit local 074f971, sauvegarde restaurée/vérifiée.
Halo de soin, signes + et valeur réellement rendue, uniquement après résolution positive.
Apparence remplaçable, origine par modèle et suivi de cible ; pause/reprise et nettoyage.
35 bancs / 2 243 contrôles passent. Voir docs/steps/GRAPHICS-005.md et docs/heal-presentation.md.
F6 : scenes/debug/heal_lab.tscn, bouton Soin (demo), puis F8/F5 pour le vrai combat.
APK 0.1.0-graphics005 (36), installé et lancé sur Galaxy A16, version vérifiée par ADB.
Étape non commitée ; attendre validation avant clôture et GRAPHICS-006.
Les sections suivantes décrivent les états historiques.

# GRAPHICS-004 et fix1 validés — 26 octobre 2026

Le propriétaire confirme « Tout est OK. Step validée. » pour la livraison fix1,
APK 0.1.0-graphics004-fix1 (35), installé sur Galaxy A16.
SHA-256 APK : `242961171f11a2f9e0ae1dbd9efad59af43df5b02e8e745261ca24c9bd805959`.
Les fichiers non documentaires restent identiques à la livraison validée ; les 34 bancs /
2 154 contrôles déjà réussis ne sont pas relancés pour cette clôture documentaire.
Clôture par un commit unique, fix1 inclus, puis sauvegarde et restauration vérifiées.
Prochaine étape : GRAPHICS-005, effet de soin ; attendre GO avant de la démarrer.
Les mentions de recette ci-dessous décrivent les états antérieurs.

# GRAPHICS-004 — animations d'action et priorités en recette

Mort > attaque/sort > déplacement > HitReact > Idle. Sword frappe au moment logique,
Duck accompagne Soin/Foudre, et les morts terminent leur geste hors du combat.
F6 : [galerie des actions](scenes/debug/action_lab.tscn), C pour Duck ; F8 puis F5 : Main.
[Recette / APK actif code 35](docs/steps/GRAPHICS-004.md), [contrat visuel](docs/combat-presentation.md).
34 bancs / 2 154 contrôles passent. Les effets de soin/Foudre suivent dans GRAPHICS-005/006.

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
