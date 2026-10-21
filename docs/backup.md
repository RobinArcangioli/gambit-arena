# Sauvegarde du projet

## Engagement de livraison

À partir de RECOVERY-001, l'assistant fournit une archive du projet complet
à chaque livraison ou correction. Il conserve les versions distinctes et suit
l'état de référence dans PROJECT_STATUS.md : base connue, validation, commit
réel confirmé, tests effectués et limites. Les archives partielles ne constituent
plus la livraison principale.

L'assistant ne reçoit pas automatiquement les modifications locales. Pour
préserver l'état exact et les objets Git, transmettre la sauvegarde après commit.
Un hash communiqué seul ne permet pas de reconstruire l'historique Git.

## Sauvegarder après chaque commit

Depuis la racine du projet, avec le dépôt propre :

```bash
bash tools/create_backup.sh
```

Le script produit dans ~/gambit-arena-backups/ une archive horodatée contenant :

- les fichiers suivis du commit courant, dans gambit-arena/ ;
- l'historique et les références Git via history.bundle ;
- un fichier BACKUP_INFO.txt avec le commit exact et les instructions de reprise.

Il refuse un dépôt avec modifications non commitées ou fichiers non suivis.
Les caches ignorés, SDK/JDK, templates et paramètres personnels de Godot ne sont
pas sauvegardés. Ne pas stocker de clés de signature ou secrets dans Git.
Il ne modifie ni les fichiers du projet, ni la branche, ni l'historique.

Après création, transmettre l'archive à l'assistant pour rattacher cette version
exacte au suivi. Conserver également une copie hors du dossier du projet,
idéalement sur un autre support. Aucune tâche automatique en arrière-plan n'est
installée : cette commande est intégrée à la procédure de clôture de chaque étape.

## Restaurer une sauvegarde contenant history.bundle

1. Extraire l'archive dans un dossier séparé du projet endommagé.
2. Lire BACKUP_INFO.txt ; le bundle a été vérifié lors de sa création.
3. Cloner history.bundle vers un nouveau dossier vide avec git clone.
4. Vérifier le commit exact donné dans BACKUP_INFO.txt et le statut du dépôt.
5. Ouvrir le projet avec la version Godot documentée.

La toute première archive de reconstruction RECOVERY-001 ne contient pas de
bundle : l'ancien .git est perdu. Les sauvegardes ultérieures en contiendront un.

## Vérification de l'outil fourni

Le script a été testé par l'assistant dans un dépôt temporaire : archive créée,
source récupérée, bundle cloné au même commit, dépôt modifié refusé. Ce test
ne constitue ni un test Godot ni une sauvegarde de l'ancien historique perdu.

## Livraison STEP-004 avant commit

L'archive complète contient gambit-arena/ (sources modifiées), ainsi que
 gambit-arena-history-6282d81.bundle et gambit-arena-step-004-ARCHIVE.txt
à côté de ce dossier. Le bundle est une copie exacte de la sauvegarde reçue :
il contient le commit de base 6282d81, pas les modifications STEP-004.
Aucun dossier .git n'est livré par-dessus le dépôt local.

Pour appliquer cette livraison à un dépôt sain, extraire dans le dossier
parent du projet existant : son .git est conservé et Git expose les changements.
Pour une restauration après perte du dépôt, extraire dans un dossier séparé,
cloner le bundle vers un nouveau dossier vide, puis y copier les sources
STEP-004. Elles apparaîtront comme modifications non commitées de la base.
Ne jamais relancer git init sur le projet sain pour appliquer cette livraison.
Après validation et commit STEP-004, créer une nouvelle sauvegarde afin que
le bundle inclue réellement le nouveau commit.
