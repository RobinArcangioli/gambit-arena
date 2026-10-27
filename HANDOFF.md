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

# Reprise actuelle — GRAPHICS-004/fix1 en recette

Dernier commit : b1dfb33 (GAMEPLAY-001 avec fix1), sauvegarde vérifiée.
Lire docs/steps/GRAPHICS-004.md et docs/combat-presentation.md. 34 bancs / 2 154 contrôles.
APK actif 0.1.0-graphics004-fix1 (35), installé et lancé sur Galaxy A16, version vérifiée par ADB.
GRAPHICS-004 n'est pas encore validée/commitée. Les états suivants sont historiques.

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

# Reprise actuelle — GAMEPLAY-001 en recette

Dernier commit : GRAPHICS-003 / 7956cfce2efcdaf4b95fd3f0631193cb9d442589, sauvegarde vérifiée.
GAMEPLAY-001 ajoute l'équipe, les compétences propres, les gambits alliés et les barres.
Lire docs/steps/GAMEPLAY-001.md et docs/party-gameplay.md. Validation attendue, aucun commit
GAMEPLAY-001 ni push effectué. Après clôture : GRAPHICS-004. Le texte suivant est historique.

# Reprise actuelle — GRAPHICS-003 en recette

Consulter docs/steps/GRAPHICS-003.md et docs/character-presentation.md.
Le dernier commit reste GRAPHICS-002 / 1e427560a9d2884ce1d3e339a093d576192fc22f.
GRAPHICS-003 est livrée sans commit ; attendre validation avant clôture.
GAMEPLAY-001 suit selon docs/party-skills-plan.md. Le texte suivant est historique.

# Passation Gambit Arena — HANDOFF-001

## Priorité actuelle — clôture GRAPHICS-002

STEP-028 est clôturée au commit 580ce64, poussé et sauvegardé avec restauration vérifiée.
Le propriétaire a demandé une roadmap graphique : [docs/graphics-roadmap.md](docs/graphics-roadmap.md).
La roadmap GRAPHICS-001 à GRAPHICS-007 est validée, avec GO pour la première étape.
GRAPHICS-001 a été validée, commitée localement (f5a790d) et sauvegardée avec restauration
vérifiée. GRAPHICS-002 est validée et son commit est demandé : voir docs/steps/GRAPHICS-002.md.
GRAPHICS-003 attend les modèles 3D annoncés par le propriétaire. Les mentions d'attente ci-dessous
décrivent les checkpoints historiques ; lire PROJECT_STATUS.md en priorité.

## Actualisation de reprise — STEP-028

Le 26 octobre 2026, main et GitHub ont été vérifiés sur cc91c79, arbre propre.
Le GO STEP-028 a ensuite été reçu. La couche de mesure et les campagnes Android sont terminées ;
le propriétaire a accepté explicitement la performance pour le périmètre réel (20 ennemis reste
un stress test), puis validé F6, F5, tactile Android et pause/reprise. Voir PROJECT_STATUS.md,
docs/performance.md et docs/steps/STEP-028.md pour l'état récent.
Les mentions ci-dessous « commit/push non effectués » sont le contexte historique de rédaction,
pas l'état actuel. STEP-028 est maintenant explicitement validée par l'utilisateur, mais n'est
pas encore commitée ni sauvegardée. STEP-029 n'est pas autorisée par cette validation seule.

Établie le 26 octobre 2026 à la demande de l’utilisateur. Ce document est le point
d’entrée de la prochaine IA. La passation ne démarre pas STEP-028.

## Situation exacte

- Dernière étape fonctionnelle : STEP-027, validée, commitée et sauvegardée.
- Commit vérifié : `665c0c8d86a6400f88c77773295ed06b1a518206`, branche `main`.
- Parent : `344a584ec680ba7b45fb648b3a2eceb8937a97ae`.
- Sauvegarde reçue : `gambit-arena-20261026-011155-665c0c8d86a6.tar.gz`.
- Bundle complet et `git fsck --full` vérifiés ; 307 fichiers identiques entre
  commit, sauvegarde et archive de validation ; clone propre.
- APK validé : `step-027-debug.apk`, version `0.1.0-step027`, code `27`.
- SHA-256 APK : `07467efcfb7e663e363e6f6fc61644fd2bf2889e7ee3a3001d42589e0c6cf611`.
- Retour utilisateur : F6 OK, tests manuels OK, fluidité OK. Retour global, sans
  mesures chiffrées ni résultats séparés par banc/scénario.
- HANDOFF-001 : documents préparés, commit et push non effectués par l’assistant.
  Le prochain commit documentaire aura un hash à relever, pas à inventer.
- Dépôt GitHub distant : URL/compte non fournis, aucun push confirmé.

## Ordre de lecture

1. [État et décisions](docs/handoff/STATE_AND_DECISIONS.md).
2. [Architecture actuelle](ARCHITECTURE.md), puis les scripts cités.
3. [Méthode de travail](docs/handoff/DEVELOPMENT_GUIDE.md).
4. [Tests, validation et environnement](docs/handoff/TESTING.md).
5. [Historique vérifiable](docs/handoff/HISTORY.md).
6. [Roadmap complète](ROADMAP.md) et [suite proposée](docs/handoff/NEXT_STEPS.md).
7. [Publication GitHub et restauration](docs/handoff/GITHUB.md).
8. [Prompt de reprise prêt à transmettre](docs/handoff/RESUME_PROMPT.md).

Les fichiers `docs/steps/STEP-XXX.md` et correctifs restent les recettes historiques.
Leurs mentions « commit en attente » décrivent la date de livraison. Pour l’état actuel,
consulter PROJECT_STATUS.md, l’historique Git et cette passation. Ne pas rejouer les
anciennes installations ou recréer leurs commits simplement parce qu’un texte ancien
indique une attente.

## Premières actions de la prochaine IA

Lire les documents ci-dessus et les instructions locales éventuelles, vérifier `git log -3`
et `git status --short --branch`, identifier si HANDOFF-001 a été commitée/poussée depuis
cette archive. Vérifier l’URL du remote, qui n’est pas stockée dans un bundle Git.
Si aucun Godot n’est disponible, l’annoncer : ne jamais prétendre avoir exécuté F6.
Demander le GO de la prochaine étape seulement s’il n’a pas déjà été donné après la passation.
La prochaine étape prévue est STEP-028 (mesures), pas une réécriture du combat.

## Contenu de l’archive

`gambit-arena/` contient le projet complet avec ces documents, sans `.git` ni `.godot`.
`gambit-arena-history-665c0c8.bundle` contient les 27 commits disponibles jusqu’à STEP-027.
Le bundle n’inclut pas HANDOFF-001, encore non commitée. Un inventaire SHA-256 et une notice
sont fournis à côté du projet. Aucun APK, SDK, clé de signature ou cache Godot n’est livré.
Code, scènes, tests, assets et configuration restent identiques à STEP-027.
