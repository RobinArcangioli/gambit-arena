# RECOVERY-001 — Reconstruction après suppression locale

## État et sources

Statut : Validée, commit en attente.
Validation utilisateur reçue le 22 octobre 2026 :
« Tout est restauré et fonctionne correctement. »
Seuls README.md, ROADMAP.md, PROJECT_STATUS.md et docs/steps/STEP-003.md
étaient encore présents selon l'inventaire utilisateur du 22 octobre 2026.
Les scènes, scripts, réglages et métadonnées Git étaient absents.

Le projet est reconstruit depuis :

1. L'archive Git STEP-002 fournie par l'utilisateur, base 5b9baac.
2. La livraison STEP-003 complète préparée par l'assistant.
3. Le correctif 1 : renommage Projection vers GroundProjection.
4. Les documents consignant la validation utilisateur de STEP-003.

Les anciens commits 6583515 et 5b9baac ont réellement été observés, mais leurs
objets Git ont été perdus. Ils ne sont pas restaurés par cette archive.
STEP-003 a été validée sur le poste avant la suppression, sans commit confirmé.
La nouvelle vérification porte sur la restauration de ce même contenu.

## Livré

Projet Godot complet, sources SVG, scripts, scènes, preset Android, documentation,
exclusions Git, et outil de sauvegarde. Aucun SDK/JDK, cache .godot/ ni ancien
historique .git n'est inclus. Les métadonnées d'import des nouveaux SVG et les
.gd.uid seront régénérées par Godot puis suivies dans le nouveau dépôt.

Les chemins SDK/JDK sont des paramètres de l'éditeur, hors projet. Si Godot les
conserve, il n'est pas nécessaire de réinstaller les outils Android.

## Installation et recette

1. Fermer Godot.
2. Conserver une copie des quatre documents restants.
3. Extraire l'archive complète dans le dossier personnel : elle contient
   directement le dossier gambit-arena/.
4. Vérifier la présence de project.godot, scenes/, scripts/, assets/ et docs/.
5. Importer project.godot depuis le gestionnaire Godot si nécessaire.
6. Attendre les imports ; F5 ; vérifier Projection/inverse : OK, croisements,
   passage du violet devant/derrière le pilier, Espace/R/T ; arrêter avec F8.
7. Vérifier l'absence d'erreur et transmettre le résultat.

La préparation a contrôlé les références locales, le correctif de nommage,
les fichiers de base conservés et le contenu de l'archive. Godot n'est pas
installé dans l'environnement de l'assistant ; aucun nouveau lancement affirmé.

## Nouveau dépôt après validation de la restauration

Un premier commit de reprise contiendra tout le projet et la documentation,
avec le message proposé :

chore: [RECOVERY-001] restaurer le projet valide jusqu'a STEP-003

Aucun commit n'a été créé ici. Ne pas inventer ou recréer les anciens hashes.
Cette opération est une reprise technique, pas une nouvelle fonctionnalité.
STEP-004 attendra cette clôture et le feu vert utilisateur.

## Sauvegardes futures

Voir backup.md. Chaque livraison de l'assistant doit être une archive complète,
avec un nom de version unique, et préciser si elle est testée ou en attente.
Une sauvegarde Git complète exige aussi les objets Git réels du poste :
ils seront transmis par la sauvegarde produite après chaque commit.

## Résultat de la restauration

L'utilisateur a confirmé que le projet complet restauré s'ouvre et fonctionne
correctement. Cette confirmation clôt la recette de restauration, pas la reprise
Git : le nouveau commit et sa sauvegarde restent à créer puis vérifier.

Après le commit, exécuter depuis la racine :

```bash
bash tools/create_backup.sh
```

Transmettre le hash, le statut Git et l'archive produite. Le hash réel du commit
de reprise sera enregistré dans la livraison suivante, sans commit documentaire
supplémentaire ni amendement uniquement pour inscrire ce hash.

## Clôture confirmée — RECOVERY-001

La restauration a ensuite été commitée sur main :
6282d81d18b8b013046821ee8bcafe459553c8b0.
L'utilisateur a confirmé un dépôt propre et créé la sauvegarde
gambit-arena-20261022-004333-6282d81d18b8.tar.gz.
L'archive reçue a été extraite et son bundle cloné par l'assistant : HEAD
exact confirmé et 32 fichiers suivis identiques aux sources archivées.
Les mentions de commit « à créer » plus haut décrivent la procédure initiale.
STEP-004 repart de cette nouvelle base réelle ; l'ancien historique reste perdu.
