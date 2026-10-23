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

## Référence STEP-005

Base confirmée et sauvegardée : 491cde8ecc276dac6728e06a579e3788ab423dda.
Archive reçue : gambit-arena-20261022-011216-491cde8ecc27.tar.gz.
Le bundle a été cloné et les 33 fichiers suivis comparés avec succès.
La livraison STEP-005 contient les sources complètes non commitées dans
gambit-arena/, le bundle de base dans gambit-arena-history-491cde8.bundle et
une notice externe gambit-arena-step-005-ARCHIVE.txt. Aucun .git n'est écrasé.
Le bundle ne contiendra STEP-005 qu'après son commit et une nouvelle sauvegarde.

## Base de TRANSITION-001

44f81d5597e061d47df59cf376908a71d1a904cb est la nouvelle base sauvegardée.
Archive reçue : gambit-arena-20261022-152338-44f81d5597e0.tar.gz.
La livraison contient les sources complètes dans gambit-arena/, le bundle de
base dans gambit-arena-history-44f81d5.bundle et une notice de livraison.
Le bundle ne contient pas les changements TRANSITION-001 non commitées.
Les fichiers locaux .gd.uid/.svg.import générés à l’import seront conservés à
l’extraction, puis devront être inclus dans le commit et la prochaine sauvegarde.

## Base STEP-006

Base reçue et vérifiée : 056a464b82869529b844571827b1aa01788bc2a6.
Sauvegarde : gambit-arena-20261022-154651-056a464b8286.tar.gz, 59 fichiers suivis.
La livraison STEP-006 contient les sources complètes et le bundle de cette base,
séparés. Le bundle ne contient pas encore les changements STEP-006.
Exporter les APK hors du dépôt, puis inclure les métadonnées Godot générées dans
le commit validé avant de lancer la prochaine sauvegarde.

## Base STEP-007

Base 1cc7f05947322fb34049f2fc12a8de37756d872b ; sauvegarde reçue et vérifiée :
gambit-arena-20261022-160117-1cc7f0594732.tar.gz, 68 fichiers suivis.
La livraison contient le projet complet et séparément le bundle de cette base.
Les nouveaux .gd.uid de scripts/tests seront générés par Godot et inclus dans
le commit puis la prochaine sauvegarde. Le bundle livré ne contient pas STEP-007.

## Point de reprise STEP-007 et livraison STEP-008

Sauvegarde reçue gambit-arena-20261022-203734-9b3240c16632.tar.gz,
commit 9b3240c16632e89afa6354cda2eecbe5077e57ba, historique complet et
78 fichiers versionnés vérifiés par restauration. L’archive STEP-008 conserve
l’intégralité du projet et joint ce bundle séparément. Les ajouts STEP-008 ne
sont pas dans ce bundle de base ; ils entreront dans la sauvegarde après validation
et commit propre. Conserver les deux archives hors du dossier du projet.

## Point de reprise STEP-008 et livraison STEP-009

Sauvegarde reçue gambit-arena-20261022-210049-46dfaa77ac79.tar.gz,
commit 46dfaa77ac79fccccebe165973a1bdbfb1000cf4. Historique complet et
90 fichiers versionnés vérifiés par restauration. L’archive STEP-009 conserve
le projet entier et joint ce bundle séparément. STEP-009 non commitée n’est pas
dans ce bundle ; elle entrera dans la sauvegarde après validation et commit propre.

## Passage à STEP-010

Base STEP-010 : ec576ce, sauvegarde
gambit-arena-20261022-212152-ec576ce356ce.tar.gz vérifiée.
Attendre validation STEP-010 et commit avant la prochaine sauvegarde.

STEP-010 validée : appliquer l’archive de validation, commiter puis lancer
`bash tools/create_backup.sh`. Transmettre l’archive produite pour vérification.

## Passage à STEP-011

Base STEP-011 : ba56209, sauvegarde
gambit-arena-20261022-220637-ba56209085c2.tar.gz vérifiée.
Attendre validation STEP-011 et commit avant la prochaine sauvegarde.

STEP-011 validée : appliquer l’archive de validation, commiter puis lancer
`bash tools/create_backup.sh`. Transmettre l’archive produite pour vérification.

## Passage à STEP-012

Base STEP-012 : 3633927, sauvegarde
gambit-arena-20261023-015545-3633927fdb21.tar.gz vérifiée.
Attendre validation STEP-012 et commit avant la prochaine sauvegarde.

STEP-012 validée : appliquer l’archive de validation, commiter puis lancer
`bash tools/create_backup.sh`. Transmettre l’archive produite pour vérification.

## Passage à STEP-013

Base STEP-013 : 9725f5d, sauvegarde
gambit-arena-20261023-021229-9725f5d2476a.tar.gz vérifiée.
Attendre validation STEP-013 et commit avant la prochaine sauvegarde.

STEP-013 validée : appliquer l’archive de validation, commiter puis lancer
`bash tools/create_backup.sh`. Transmettre l’archive produite pour vérification.

## Passage à STEP-014

Base STEP-014 : 1ffd24a, sauvegarde
gambit-arena-20261023-025301-1ffd24ad0279.tar.gz vérifiée.
Attendre validation STEP-014 et commit avant la prochaine sauvegarde.

STEP-014 validée : appliquer l’archive de validation, commiter puis lancer
`bash tools/create_backup.sh`. Transmettre l’archive produite pour vérification.

## Passage à STEP-015

Base STEP-015 : 4f4244c, sauvegarde
gambit-arena-20261023-075612-4f4244c24887.tar.gz vérifiée.
Attendre validation et commit STEP-015 avant la prochaine sauvegarde.

STEP-015 validée : appliquer l’archive de validation, commiter puis lancer
`bash tools/create_backup.sh`. Transmettre la sauvegarde produite pour vérification.

## Passage à STEP-016

Base STEP-016 : dd9fec8, sauvegarde
gambit-arena-20261023-151439-dd9fec88067d.tar.gz vérifiée.
Attendre validation et commit STEP-016 avant la prochaine sauvegarde.

STEP-016 validée : appliquer l’archive de validation, commiter puis lancer
`bash tools/create_backup.sh`. Transmettre la sauvegarde produite pour vérification.
