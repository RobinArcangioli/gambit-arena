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

# GAMBITS-002 — Bascule du combat et éditeurs en ligne (plan)

Statut : proposée, non implémentée. Dépend de GAMBITS-001 validée et clôturée.

Raccorder ensemble le nouveau modèle, la migration et les consommateurs de configuration.
Retirer du moteur/exécuteur les restrictions cible/capacité et le remplacement de cible
incompatible avec le critère. Préserver annulation, paiement à la résolution, durées et
animations. Une ligne contient activation ✓/✕ vert/rouge, deux chevrons, liste de critères,
liste de capacités et suppression. Bouton Ajouter sous la liste, compteur n/100, défaut
Ennemi proche + Attaque, actif. Aucun réglage de seuil ni bouton Appliquer/Annuler.
Chaque changement (activation, listes, priorité, ajout/suppression) est sauvegardé
immédiatement. Retour conserve les modifications et revient à la même fiche. Aucun message
de réussite systématique ; un échec d’écriture restaure le dernier état enregistré avec
un bref message d’erreur.
Même modèle et mêmes règles pour l'édition en combat et hors combat ; aucune sélection
persistante dans Équipe. Fonds et thème existants conservés.

Recette : associations croisées allié/ennemi/soi-même, ajout/suppression et ordre, listes
vides et de 100 lignes, deux héros indépendants, sauvegarde immédiate et relecture après
chaque type de changement, échec d’écriture, migration expliquée et retour
à la bonne fiche, vrais taps/glissements/menus sur PC et A16. Adapter les tests historiques
à la nouvelle sémantique sans perdre leurs contrôles de cycle de vie et de combat.

Plan complet : [refonte](../gambits-refactor-roadmap.md). Attendre le GO de cette étape.
Après validation et clôture, UI-005 recettera le parcours et la charge complète sur Android.
