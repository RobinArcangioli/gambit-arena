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
