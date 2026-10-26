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
