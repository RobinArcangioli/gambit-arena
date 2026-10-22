# STEP-006 — Arène fixe et réservations d’interface

## Statut et base

Phase 4 : Arène. Validée, commit en attente.
Base : 056a464b82869529b844571827b1aa01788bc2a6, TRANSITION-001 clôturée.
Sauvegarde reçue et vérifiée ; GO utilisateur reçu.
Livraison : gambit-arena-complet-step-006-v1.tar.gz. Aucun commit STEP-006.

## Objectif et périmètre

Une arène fixe entièrement visible en portrait, un sol 2D lisible, des limites
logiques partagées et un espace réservé pour le HUD et les futures commandes.
Réutiliser les mannequins 3D à 48 px ; aucun asset externe nécessaire.
Ne pas anticiper déplacement automatique, ciblage, combat, collisions ou gambits.

## Livré

Scène scenes/arena/arena.tscn, scripts scripts/arena/arena.gd, arena_floor.gd,
arena_bounds.gd, document docs/arena.md et cette fiche. Scène principale, version
Android et documentation de suivi actualisées. Les anciens diagnostics restent
intacts. La version d’export est 0.1.0-step006, code 5.

Le carré logique mesure 6 unités de côté ; la marge des racines vaut 0,35.
Le diagnostic demande centre puis quatre coins hors limites et applique le
bornage pour afficher les positions admissibles ±2,65. Les mannequins restent
immobiles entre les pressions. Les six cases de commande sont inactives.

## Installation

Fermer Godot. Vérifier main propre et HEAD 056a464 :

```bash
cd ~/gambit-arena
git status --short --branch
git log -1 --format="%h %s"
```

Si des modifications inattendues existent, les signaler avant extraction. Sinon :

```bash
tar -xzf ~/Downloads/gambit-arena-complet-step-006-v1.tar.gz -C ~
cd ~/gambit-arena
git diff --check
git status --short --branch
```

Ouvrir Godot et attendre l’import. Conserver les nouveaux .gd.uid générés.
Le .git est conservé ; ne pas réinitialiser le dépôt. Aucun document à recopier.

## Recette Godot

1. F5 : en-tête STEP-006 / ARENE, sol 2D et deux mannequins 3D, sans erreur.
2. L’arène et sa bordure sont visibles en entier entre les panneaux ; les
   personnages ne sont pas recouverts par les réservations d’interface.
3. La taille reste proche des 48 px validés, sans caméra suiveuse ni zoom.
4. Activer Repères. Parcourir Position 1/5 à 5/5 puis revenir au centre :
   les quatre coins sont bornés à la ligne intérieure ; les pieds restent au sol.
   Aucun mannequin ne sort du rendu ou ne touche les boutons.
5. Pause désactive Position ; P ne change rien en pause. Repères reste utilisable.
   Reprendre réactive Position. Espace/P/G fonctionnent sans double action.
6. Les six cases À venir sont inactives. Cliquer sur le sol ne déplace rien.
7. Changer de fenêtre puis revenir : état pause conservé. F8 arrête sans erreur.
8. Ouvrir scenes/hybrid/hybrid_lab.tscn puis F6 : l’ancien diagnostic fonctionne.
   F5 retourne à l’arène.

En cas d’erreur d’import ou GDScript, transmettre son texte avant export.

## Recette Galaxy A16

Exporter avec débogage, installer et relever le SHA-256 selon docs/android.md.
Destination obligatoire hors du dépôt : ~/gambit-arena-builds/step-006-debug.apk.

1. Vérifier l’en-tête STEP-006, la bordure entièrement visible et la lisibilité.
2. Refaire les cinq placements : aucune silhouette coupée, pieds sur le sol,
   marges entre arène et panneaux. Taille 48 px toujours satisfaisante.
3. Tester Position, Repères et Pause ; une pression = une action. Les six cases
   réservées ne doivent rien déclencher. Aucun déplacement manuel sur le sol.
4. Vérifier textes et boutons hors encoche/navigation.
5. Accueil dix secondes puis retour, et verrouillage/déverrouillage : pause
   conservée, Position bloqué jusqu’à Reprendre.
6. Fournir si possible une capture au centre et une avec un placement de coin.
   Transmettre les résultats et le SHA-256 de cet APK, pas celui de la transition.

## Acceptation

Arène fixe lisible et entièrement visible sur le téléphone, taille retenue
conservée, placements bornés et ancrages stables, panneaux séparés du jeu,
six réservations visibles et inactives, tactile/pause corrects, aucune erreur.
Validation explicite utilisateur requise avant commit.

## Vérifications et limites

Références, composition des scènes et géométrie du layout portrait contrôlées
par l’assistant. Anciennes sources et métadonnées conservées. Archive vérifiée.
Godot absent ici : compilation, rendu, export et tests manuels non exécutés.
Le bornage est utilisé par le diagnostic ; aucun contrôleur ne déplace encore
le héros. Il ne remplace ni collision physique ni séparation entre acteurs.
Les vrais modèles, animations 3D et l’illustration finale ne sont pas livrés.
Les petits viewports/paysage sont hors qualification. Le relevé 60 FPS précédent
ne constitue pas une mesure STEP-006 ou une garantie pour les étapes suivantes.

## Résultats

Validation explicite reçue le 22 octobre 2026.
L’utilisateur confirme :
- Arène et bordure entièrement visibles entre les panneaux : OK.
- Mannequins lisibles à 48 px : OK.
- Cinq placements dans les limites, sans silhouette coupée ni chevauchement : OK.
- Pause bloque Position ; Repères reste utilisable : OK.
- Six cases À venir inactives : OK.
- Aucun message d’erreur ; arrêt F8 correct : OK.

ADB : téléphone en état device, installation Success sur Galaxy A16.
APK testé : step-006-debug.apk. SHA-256 :

```text
133d5096305e9278d9262c55dd5bc4ea8f067a571e618017fc4976866833c125
```

Ces résultats sont transmis par l’utilisateur ; l’assistant n’a pas exécuté Godot.
Aucune capture ni mesure de performance STEP-006 n’a été transmise.
Le retour d’arrière-plan/verrouillage n’a pas été détaillé séparément dans ce
retour ; la validation globale de l’étape est reçue sans inventer de résultat par test.

## Clôture après validation

Recevoir la livraison complète consignant les résultats réels, vérifier le diff
préparé, inclure les nouvelles métadonnées Godot puis commiter :
feat: [STEP-006] installer l'arene fixe et les reservations du HUD.
Confirmer le hash et le statut propre, exécuter bash tools/create_backup.sh et
transmettre l’archive. STEP-007 attend ensuite un nouveau GO.

## Livraison de validation

Archive : gambit-arena-complet-step-006-validation.tar.gz.
Seule la documentation évolue depuis la v1 testée. Le bundle fourni contient
la base 056a464, pas encore le prochain commit STEP-006. Les .gd.uid générés
localement sont conservés à l’extraction et devront figurer dans la sauvegarde.
