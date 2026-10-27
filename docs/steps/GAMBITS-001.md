# GAMBITS-001 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour le nouveau modèle et son laboratoire
isolé. Validation globale, sans précisions supplémentaires. APK normal 0.1.0-gambits001 (48),
SHA-256 `b2a8e4defb65f46d41ebbd4f91cf57dcf85c8d066f58291943cad4d06e1c073e`.
APK laboratoire 0.1.0-gambits001-lab (48), SHA-256
`bfa7b4781efa728a54ebebaf5cefa71facd46a1adc07d8a13e85050bbe4eeb97`.
Seuls les documents sont actualisés ; code, scènes, assets, configuration et les deux APK
restent identiques à la livraison validée. Les 52 bancs / 3 461 contrôles déjà réussis ne
sont pas relancés. Aucune nouvelle mesure FPS. Règles de jeu Android v2 conservées.
Clôture par commit unique et sauvegarde restaurée/vérifiée. Prochain GO : GAMBITS-002,
bascule du combat et des éditeurs, sauvegarde immédiate sans Appliquer/Annuler, 100 ordres.
Le jeu normal conserve UI-004 en v2 jusqu'à cette bascule. Puis UI-005 et STEP-029/030.
GAMEPLAY-003 reste annulée. Les mentions de recette ci-dessous sont historiques.

# GAMBITS-001 — Catalogue, résolution et migration des ordres

Statut : implémentée en laboratoire isolé, en recette, non commitée. Base : UI-004 2f1e9b9603d7.

Dix Critères de ciblage à seuils fixes ; ordres activés à critère/capacité indépendants,
0 à 100 par héros ; résolution déterministe, allié incluant soi-même au plus faible ratio,
ennemis classés par PV actuels absolus ou distance. Codec v3, migration v2 avec seuil inférieur
et bilan des cas impossibles ; première mutation protège l'original avant écriture atomique.
Store par héros à sauvegarde immédiate, sans commande de validation dans le nouveau modèle.

F6 scenes/debug/gambits_criteria_lab.tscn : choix et résolution sans simulation, fichier
user://gambits_v3_lab.json uniquement. F5/Android normal conservent le jeu UI-004 en v2 ;
le raccordement réel du combat et des éditeurs est GAMBITS-002. Aucun ancien script de jeu,
routeur tactile, profil, modèle, gabarit ou project.godot modifié.
52 bancs / 3 461 contrôles réussis, captures GPU PC, laboratoire Android et retour à l'APK
normal ; règles Android v2 identiques. APK normal code 48, SHA-256 :
`b2a8e4defb65f46d41ebbd4f91cf57dcf85c8d066f58291943cad4d06e1c073e`.
[Modèle, preuves et recette](../gambits-model.md). [Plan de refonte](../gambits-refactor-roadmap.md).

Attendre validation, commit unique et sauvegarde restaurée/vérifiée, puis GO GAMBITS-002.
UI-005, STEP-029 et STEP-030 suivent. GAMEPLAY-003 reste annulée.
