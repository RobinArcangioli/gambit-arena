# État du projet

## RECOVERY-001 — reconstruction au 22 octobre 2026

- Statut : Validée, commit en attente.
- Restauration confirmée par l’utilisateur le 22 octobre 2026 : projet fonctionnel.
- Dernière fonctionnalité validée : STEP-003, après correctif GroundProjection.
- Validation utilisateur : croisements confirmés sans ambiguïté avant suppression.
- Aucun commit STEP-003 n'a été confirmé.
- Historique Git perdu : les commits 6583515 et 5b9baac sont des références
  historiques observées, mais leurs objets ne sont plus disponibles.
- Dépôt reconstruit : aucun .git, aucune branche actuelle, aucun HEAD actuel.
- Dernière base source reçue : archive STEP-002 correspondant à 5b9baac.
- Archive complète de référence : gambit-arena-complet-recovery-001-validation.tar.gz.
- Contenu : STEP-002 + STEP-003 corrigée et validée + documents de reprise.

## Fonctionnement attendu

Godot 4.7.2 standard, Compatibility, portrait 540 × 960.
Main instance le laboratoire : trois acteurs, un pilier, tri aux pieds,
projection/inverse et commandes Espace/R/T. Pas de combat ni de gambits.
Android : SDK et templates préparés auparavant, ADB autorisé ; aucun APK généré.

## Vérifications

- Avant suppression : recette STEP-003 validée par l'utilisateur.
- Reconstruction : fichiers de base comparés à l'archive utilisateur ; correctif
  GroundProjection présent ; références locales et archive contrôlées.
- Godot absent chez l'assistant : pas de nouveau test d'import ou de rendu.
- Import et lancement du projet restauré : confirmés réussis par l’utilisateur.
- Reprise Git : nouveau dépôt, commit et sauvegarde encore à créer/vérifier.
- Annexe détaillée ROADMAP.md vide dans la source reçue ; registre des 30 étapes intact.

## Prochaine action exacte

Appliquer la livraison complète de validation, initialiser le nouveau dépôt,
vérifier le contenu préparé et créer le commit RECOVERY-001. Exécuter ensuite
bash tools/create_backup.sh et transmettre l’archive produite avec le hash et
le statut Git. Ne pas démarrer STEP-004 avant cette clôture et le feu vert utilisateur.

Fiches : docs/recovery.md et docs/backup.md.
Message de commit proposé :
chore: [RECOVERY-001] restaurer le projet valide jusqu'a STEP-003

## Suivi permanent des archives

Chaque prochaine livraison principale est complète, nommée et versionnée.
Après chaque commit : bash tools/create_backup.sh, puis transmettre l'archive
pour conserver également l'historique Git exact. Aucune modification locale
non transmise ne peut être incluse dans une sauvegarde de l'assistant.
