# État du projet

## Base confirmée

- Branche main ; STEP-004 clôturée : 491cde8ecc276dac6728e06a579e3788ab423dda.
- Message : feat: [STEP-004] valider le prototype visuel sur Android.
- Dépôt propre confirmé après commit.
- Sauvegarde reçue : gambit-arena-20261022-011216-491cde8ecc27.tar.gz.
- Bundle cloné et vérifié : 33 fichiers identiques aux sources archivées.
- Historique disponible : RECOVERY-001 (6282d81) puis STEP-004 (491cde8).
- STEP-004 validée par l'utilisateur sous Godot et sur Galaxy A16 Android 16.
- Taille préférée : 48 px de référence.
- APK STEP-004 testé, SHA-256 :
  c554729004c142a67223176b5c24dd86a28accb6cb6606001339aeeed2f3475b.

## STEP-005 — Validée, commit en attente

Livraison testée : gambit-arena-complet-step-005-v1.tar.gz.
Livraison de validation : gambit-arena-complet-step-005-validation.tar.gz.
Deux acteurs temporaires vectoriels, cinq animations et quatre directions.
Laboratoire tactile : état, direction, pause, rejouer, croisement, image suivante.
Corps debout proche de 48 px ; cellules plus grandes pour contenir les armes.
Aucun gameplay anticipé, aucun dégât ni contrôleur de déplacement.
Version d’export : 0.1.0-step005, code 3. APK exporté et installé par
l’utilisateur : ADB Success. SHA-256 :
86459ba2a752ecd83e7d179d637a40f9c950b14293ebad88914b94fbdfe8d652.

## Vérifications et limites

Génération déterministe des SVG, découpes et références contrôlées ; rendu
vectoriel inspecté hors Godot. Code STEP-004 conservé comme ancien laboratoire.
Le 22 octobre 2026, l’utilisateur confirme les tests réussis, notamment
croisements, actions et boutons, et valide explicitement STEP-005.
Godot absent chez l’assistant : les essais d’exécution proviennent de l’utilisateur.
Aucun résultat de performance soutenue n'est déduit des FPS de diagnostic.

## Prochaine action

Appliquer la livraison de validation, vérifier le diff, commiter STEP-005,
confirmer le hash et le statut propre puis transmettre la sauvegarde complète.
Le prochain travail sera un prototype de transition 3D/2D (TRANSITION-001),
avant STEP-006. Il attend la clôture de cette étape et le prochain GO.

## Archives

Livraison complète comprenant les sources non commitées et, séparément, le
bundle de base 491cde8. Après commit validé : bash tools/create_backup.sh,
puis transmettre l'archive pour conserver le nouvel historique exact.
Les changements locaux non transmis ne sont pas automatiquement récupérés.

## Nouvelle direction décidée le 22 octobre 2026

Personnages 3D se déplaçant sur un fond 2D isométrique. La production de sprites
comme représentation finale des personnages est abandonnée. Le code livré
reste celui du laboratoire 2D validé ; aucune migration 3D n'est encore réalisée.
Le repère de 48 px reste une préférence de taille apparente, à réévaluer en 3D.
Décision et critères du prototype : docs/decisions/DEC-001-personnages-3d.md.
