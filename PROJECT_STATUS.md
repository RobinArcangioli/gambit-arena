# État du projet

## Référence confirmée

- RECOVERY-001 : restaurée, testée et commitée par l'utilisateur.
- HEAD de référence : 6282d81d18b8b013046821ee8bcafe459553c8b0, branche main.
- Message : chore: [RECOVERY-001] restaurer le projet valide jusqu'a STEP-003.
- Dépôt propre confirmé après commit.
- Sauvegarde reçue : gambit-arena-20261022-004333-6282d81d18b8.tar.gz.
- Son history.bundle a été cloné ; HEAD confirmé ; les 32 fichiers suivis
  correspondent exactement aux sources de la sauvegarde.
- Les anciens commits 6583515 et 5b9baac restent des références historiques
  perdues. La récupération ne recrée pas leurs objets Git.

## STEP-004 — Validée, commit en attente

Feu vert utilisateur reçu. Livraison de validation : gambit-arena-complet-step-004-validation.tar.gz.
Base : 6282d81. Aucun commit STEP-004 à ce stade.

Ajouts : quatre boutons tactiles, tailles de référence 48/64/80,
placement dans la zone sûre Android, pause locale au passage en arrière-plan,
reprise explicite et indicateur FPS. Version Android 0.1.0-step004, code 2.
Le laboratoire reste un diagnostic à trajets automatiques, sans combat.

## Validation réelle

- STEP-003 corrigée et projet restauré : validés par l'utilisateur sous Linux.
- STEP-004 : contrôles statiques des références et calculs effectués par l'assistant.
- Godot indisponible chez l'assistant : import, compilation GDScript, rendu et
  interactions STEP-004 non exécutés ici.
- Le 22 octobre 2026, l’utilisateur confirme tous les tests manuels réussis
  sous Godot et sur son Galaxy A16 et valide explicitement STEP-004.
- Export effectué ; installation ADB : Success. APK lancé et testé.
- Taille préférée confirmée par l’utilisateur : 48 px de référence.
- Capture et mesures détaillées non transmises ; validation globale utilisateur consignée.
- SHA-256 APK : c554729004c142a67223176b5c24dd86a28accb6cb6606001339aeeed2f3475b.
- Aucun résultat de performance soutenue établi.

## Prochaine action exacte

Appliquer l'archive complète de validation, vérifier le diff préparé et créer
le commit STEP-004. Confirmer son hash réel et le statut propre, puis exécuter
bash tools/create_backup.sh et transmettre la sauvegarde produite.
Message : feat: [STEP-004] valider le prototype visuel sur Android.
Ne pas commencer STEP-005 avant clôture, sauvegarde et nouveau feu vert.

## Conservation

Chaque livraison/correction reste une archive complète distincte.
Cette livraison inclut aussi le bundle du commit de base, séparé des sources
STEP-004 non commitées. Après le prochain commit : bash tools/create_backup.sh,
puis transmettre l'archive. Les changements locaux non transmis ne sont pas
automatiquement sauvegardés par l'assistant.
