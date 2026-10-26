# Historique disponible et preuves de clôture

Extrait du bundle vérifié à 665c0c8, 27 commits. Tous sont des objets disponibles dans
l’historique livré. Ce registre ne contient aucun hash inventé pour HANDOFF-001.

| Commit complet | Sujet |
|---|---|
| `6282d81d18b8b013046821ee8bcafe459553c8b0` | chore: [RECOVERY-001] restaurer le projet valide jusqu'a STEP-003 |
| `491cde8ecc276dac6728e06a579e3788ab423dda` | feat: [STEP-004] valider le prototype visuel sur Android |
| `44f81d5597e061d47df59cf376908a71d1a904cb` | feat: [STEP-005] ajouter les acteurs temporaires animes |
| `056a464b82869529b844571827b1aa01788bc2a6` | feat: [TRANSITION-001] prototyper les personnages 3D sur fond 2D |
| `1cc7f05947322fb34049f2fc12a8de37756d872b` | feat: [STEP-006] installer l'arene fixe et les reservations du HUD |
| `9b3240c16632e89afa6354cda2eecbe5077e57ba` | feat: [STEP-007] ajouter le deplacement automatique vers une cible |
| `46dfaa77ac79fccccebe165973a1bdbfb1000cf4` | feat: [STEP-008] ajouter les ennemis et leur poursuite |
| `ec576ce356ce3a6e3f2f2b43e18b82bcd7939935` | feat: [STEP-009] ajouter la separation bornee des acteurs |
| `ba56209085c2d89153ca9ff7fbeba21fbf385719` | feat: [STEP-010] isoler les statistiques et PV des acteurs |
| `3633927fdb21273ca67c1d9343d012c6e9d20d3e` | feat: [STEP-011] garantir un impact unique par action |
| `9725f5d2476a2db427a7379c58a2c95351b6ad62` | feat: [STEP-012] integrer le premier combat autonome |
| `1ffd24ad027991f57f2aee1d96b1cbcfa87228c6` | feat: [STEP-013] partager lexecution et garantir les couts uniques |
| `5c39ac2f304e4e65cd4c727a6a7e3192c746186f` | feat: [STEP-014] ajouter soin speciale et recuperation de ressource |
| `4f4244c24887cbf938e46bc9dd56507784d8c2bd` | docs: [FIX-STEP-014-001] consigner la validation de STEP-014 |
| `dd9fec88067da7e677e731b4e5338840ba8dccdf` | feat: [STEP-015] unifier la pause et annuler les actions a la mort |
| `1da833e408b04a8e2627940842dd0ca7bd3adbd6` | feat: [STEP-016] ajouter un evaluateur deterministe de gambits |
| `5b2bc4d692bd99f29774c19caf4eec3d3d93598f` | feat: [STEP-017] piloter le heros uniquement par les gambits |
| `4719e8d2790cb6dd371733d2beebcec51d145d46` | feat: [STEP-018] ajouter des diagnostics bornes et des scenarios reproductibles |
| `4125d44e048c34f6ff8ae197e2d912e2db57fad5` | feat: [STEP-019] activer et reordonner trois gambits au toucher |
| `ac581907fc1a5a9b3bc4573a75d35805e2ebf151` | feat: [STEP-020] editer et valider les champs des gambits |
| `9491d40df3d396cf4f8532d603b4edaaf5d03176` | feat: [STEP-021] adapter le HUD portrait aux zones de securite |
| `307e8c6fcb294102638cd55fab388c10352dcb70` | feat: [STEP-022] afficher six emplacements et la disponibilite des competences |
| `7579504fd4a11b5b6fa1440567c597a92c67fa49` | feat: [STEP-023] prioriser une commande manuelle a attente bornee |
| `89ae0f64d0b44943e3eef64be5b743d0b94ed1a8` | feat: [STEP-024] ajouter une vague progressive et retablir le swipe tactile |
| `f62162db145d4a3e3b70a7cc839770f34df4caaa` | feat: [STEP-025] enchainer trois vagues et conserver la cible a portee |
| `344a584ec680ba7b45fb648b3a2eceb8937a97ae` | feat: [STEP-026] figer la defaite et fiabiliser les redemarrages |
| `665c0c8d86a6400f88c77773295ed06b1a518206` | feat: [STEP-027] securiser la pause et le retour Android |

## Avant la reprise

STEP-001 (ancien hash 6583515) et STEP-002 (ancien hash 5b9baac) sont attestées dans les documents historiques mais leurs anciens objets ont
été perdus. STEP-003 avait été validée sans commit confirmé avant suppression.
RECOVERY-001, commit racine 6282d81, restaure le projet validé jusqu’à STEP-003 ; il ne
reconstitue pas artificiellement les anciens objets. Voir ../recovery.md.
TRANSITION-001, après STEP-005, documente le choix des personnages 3D.

## Dernier point de reprise complet

STEP-027 : commit 665c0c8d86a6400f88c77773295ed06b1a518206 ; parent
344a584ec680ba7b45fb648b3a2eceb8937a97ae. Sauvegarde reçue :
gambit-arena-20261026-011155-665c0c8d86a6.tar.gz.
Vérifications réalisées : extraction sans chemin traversant/lien spécial, clone du bundle,
bundle verify, git fsck --full, HEAD/parent, statut propre et égalité des 307 fichiers
entre backup, commit et archive de validation STEP-027.

Les comptes des derniers points vérifiés sont : STEP-024 277 fichiers ; STEP-025 fix1 289 ;
STEP-026 297 ; STEP-027 307. Les nouveaux documents HANDOFF-001 ne sont pas dans le bundle
jusqu’à leur futur commit utilisateur. Le projet extrait de cette archive inclut ces documents.

## Archives de documents historiques

Tous les STEP-XXX.md et correctifs sous ../steps sont conservés. Ils décrivent leur livraison,
leurs tests et leurs retours à la date de rédaction. Les mentions « commit en attente » sont
normales dans un commit de validation : le hash n’existait pas encore lors de sa rédaction.
L’historique Git et PROJECT_STATUS.md établissent la clôture courante.
