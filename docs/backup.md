# Checkpoint GRAPHICS-005 vérifié

Commit bf4904d5d56338f7fbc11395c2e6ba24c4a96259, parent 074f971.
Archive gambit-arena-20261026-220804-bf4904d5d563.tar.gz,
SHA-256 0b14e3fe05096321b3269429b46147e30d55870fa2da970dfc721c7728ada73d.
Restauration /tmp/graphics005-restore-hl_br_9t : bundle valide, clone et fsck corrects,
HEAD/parent vérifiés, arbres propres et 506 fichiers identiques entre commit, sauvegarde
et projet. Fichiers non documentaires identiques à la livraison validée.
Base de GRAPHICS-006 ; aucun nouveau push réalisé.

# Checkpoint GRAPHICS-004/fix1 vérifié

Commit 074f971db7e9dd8a613b1e2a762140f392804ef0, parent b1dfb33.
Archive gambit-arena-20261026-200257-074f971db7e9.tar.gz,
SHA-256 ac2eb0e0c895a15a407cf24e5e20e01b3ad21158765e6fecb9ab21d4379f4a74.
Restauration /tmp/graphics004-restore-jeltyb1o : bundle valide, clone et fsck corrects,
HEAD/parent vérifiés, arbres propres et 492 fichiers identiques entre commit, archive
et projet. Base de GRAPHICS-005 ; aucun nouveau push réalisé.

# Checkpoint GAMEPLAY-001, fix1 inclus

Commit b1dfb33b12ba4ab74388894aefd0004cb1ce39e4.
Archive /home/arkhane/gambit-arena-backups/gambit-arena-20261026-172958-b1dfb33b12ba.tar.gz.
SHA-256 d24379a99c7ec0f42bb1f82e881bf5012cac9d18fc591703126ef96eafce11a8.
Restauration /tmp/gameplay001-restore-36lwhmgq : bundle cloné, fsck valide, HEAD/parent
et 479 fichiers identiques entre commit, archive et workspace. Checkpoint local.

# Checkpoint GRAPHICS-003

Commit 7956cfce2efcdaf4b95fd3f0631193cb9d442589.
Archive /home/arkhane/gambit-arena-backups/gambit-arena-20261026-161953-7956cfce2efc.tar.gz.
SHA-256 344fd7c86fbb58ed8e6e28e6b7ac695f83dd14615b6e39cedb32f712b74682cf.
Restauration /tmp/g003-restore-gkya6t6p : bundle cloné, fsck valide, 445 fichiers identiques
entre commit, sauvegarde et workspace avant GAMEPLAY-001. Checkpoint local, pas poussé.

# Sauvegarde du projet

## GRAPHICS-002 — validation reçue

Le propriétaire a explicitement validé GRAPHICS-002 et demandé son commit. La sauvegarde
post-commit doit inclure le catalogue, les huit décors et la documentation de validation.
Le code, les scènes, les assets et la configuration restent identiques à la livraison validée ;
seuls les documents sont actualisés pour consigner ce retour. GRAPHICS-003 attend les modèles
annoncés pour les personnages et ennemis.

## GRAPHICS-001 — checkpoint local vérifié

Validation utilisateur reçue avec GO pour GRAPHICS-002. Commit local :
`f5a790d38ed12cd3ccc3bac85162308986a5f894`. Sauvegarde
`gambit-arena-20261026-055618-f5a790d38ed1.tar.gz` restaurée : bundle vérifié, intégrité Git
contrôlée et 354 fichiers identiques au commit. Le code/configuration est identique à la
livraison GRAPHICS-001 validée ; la validation n'a modifié que les documents.
GRAPHICS-002 reste une évolution non commitée au-dessus de ce checkpoint.

## STEP-028 — validée, commit et sauvegarde en attente

Le 26 octobre 2026, le propriétaire a validé STEP-028 : F6, F5, tactile Android et
pause/reprise OK. Une archive complète de validation est fournie avant commit ; elle doit
contenir les sources STEP-028 sans `.git`/`.godot`, le bundle historique séparé et les preuves
de mesure. Le prochain bundle ne pourra inclure STEP-028 qu'après le commit réalisé par le
propriétaire. Exécuter ensuite `bash tools/create_backup.sh` depuis un arbre propre et
transmettre l'archive produite pour vérification.

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

## Passage à STEP-017

Base STEP-017 : 1da833e, sauvegarde
gambit-arena-20261023-153404-1da833e408b0.tar.gz vérifiée.
Attendre validation et commit STEP-017 avant la prochaine sauvegarde.

STEP-017 validée : appliquer l’archive de validation, commiter puis lancer
`bash tools/create_backup.sh`. Transmettre la sauvegarde produite pour vérification.

## Passage à STEP-018

Base STEP-018 : 5b2bc4d, sauvegarde
gambit-arena-20261023-160700-5b2bc4d692bd.tar.gz vérifiée.
Attendre validation et commit STEP-018 avant la prochaine sauvegarde.

STEP-018 validée : appliquer l’archive de validation, commiter puis lancer
`bash tools/create_backup.sh`. Transmettre la sauvegarde produite pour vérification.

STEP-018 clôturée au commit 4719e8d : sauvegarde du 24 octobre 2026 reçue et vérifiée,
207 fichiers identiques au commit et à la livraison validée ; bundle complet et intègre.
STEP-019 reste en attente de validation ; ne pas commiter avant le retour utilisateur.

STEP-019 v2 validée : appliquer l’archive de validation, commiter puis lancer
`bash tools/create_backup.sh`. Transmettre la sauvegarde produite pour vérification.

STEP-019 clôturée au commit 4125d44 : sauvegarde du 24 octobre 2026 reçue et vérifiée,
221 fichiers identiques au commit et à la livraison validée ; bundle complet et intègre.
STEP-020 reste en attente de validation ; ne pas commiter avant le retour utilisateur.

STEP-020 validée : appliquer l’archive de validation, commiter puis lancer
`bash tools/create_backup.sh`. Transmettre la sauvegarde produite pour vérification.

STEP-020 clôturée au commit ac58190 : sauvegarde du 25 octobre 2026 reçue et vérifiée,
229 fichiers identiques au commit et à la livraison validée ; bundle complet et intègre.
STEP-021 reste en attente de validation ; ne pas commiter avant le retour utilisateur.

STEP-021 validée : appliquer l’archive de validation, commiter puis lancer
`bash tools/create_backup.sh`. Transmettre la sauvegarde produite pour vérification.

STEP-021 clôturée au commit 9491d40 : sauvegarde du 25 octobre 2026 reçue et vérifiée,
240 fichiers identiques au commit et à la livraison validée ; bundle complet et intègre.
STEP-022 reste en attente de validation ; ne pas commiter avant le retour utilisateur.

STEP-022 validée : appliquer l’archive de validation, commiter puis lancer
`bash tools/create_backup.sh`. Transmettre la sauvegarde produite pour vérification.

STEP-022 clôturée au commit 307e8c6 : sauvegarde du 25 octobre 2026 reçue et vérifiée,
250 fichiers identiques au commit et à la livraison validée ; bundle complet et intègre.
STEP-023 reste en attente de validation ; ne pas commiter avant le retour utilisateur.

STEP-023 validée : appliquer l’archive de validation, commiter puis lancer
`bash tools/create_backup.sh`. Transmettre la sauvegarde produite pour vérification.
FIX-STEP-023-001 (swipe Android) est planifié pour STEP-024, sans changement de code ici.

STEP-023 clôturée au commit 7579504 : sauvegarde du 25 octobre 2026 vérifiée,
260 fichiers identiques au commit et à la livraison validée ; historique complet et intègre.
STEP-024 avec FIX-STEP-023-001 reste en attente de validation.

STEP-024 v2 validée : appliquer l’archive de validation, commiter puis lancer
`bash tools/create_backup.sh`. Transmettre la sauvegarde produite pour vérification.

## STEP-025 — Livraison en attente de validation

Base clôturée 89ae0f6. Main ouvre maintenant trois vagues ; le laboratoire STEP-024
reste disponible. Version 0.1.0-step025, code 24, export step-025-debug.apk.
Recette et commandes : docs/steps/STEP-025.md. Aucun SHA d’APK STEP-025 reçu.
Les sections STEP-024 ci-dessus décrivent la livraison précédente.

STEP-025 avec fix1 validée le 25 octobre 2026 : F6, tests manuels et fluidité OK.
APK fix1 : a05863ca35183215d53c270652a0a1927da4e74c8547fcf32112f6a42e97544a. Commit et sauvegarde en attente.

## STEP-026 — En attente de validation

Base clôturée f62162d, fix1 inclus. Fin de partie unique, bilan figé et nettoyage des
actions/cibles au redémarrage. Nouveau banc run_lifecycle_tests.tscn.
Recette : docs/steps/STEP-026.md. Android 0.1.0-step026, code 26,
export step-026-debug.apk ; aucun nouveau SHA d’APK reçu.
Les mentions des étapes précédentes sont historiques. Commit après validation.

STEP-026 validée le 25 octobre 2026 : F6, tests manuels et fluidité OK.
Retour global sans mesure chiffrée ; commit et sauvegarde en attente.
APK : 1c6e699d3acf44a6f3e5ce6e85d333ac9bb60c14e946a548992bd5eb099a47a2.

## STEP-027 — Livraison en attente de validation

Base clôturée 344a584. ApplicationLab ajoute la protection de retour au premier plan,
avec reprise explicite et rejet des anciens gestes. Recette : docs/steps/STEP-027.md.
Android 0.1.0-step027, code 27 ; export step-027-debug.apk. Aucun nouveau SHA reçu.
Les mentions antérieures décrivent les livraisons précédentes. Commit après validation.

STEP-027 validée le 26 octobre 2026 : F6, tests manuels et fluidité OK.
Retour global sans mesure chiffrée ; commit et sauvegarde en attente.
APK : 07467efcfb7e663e363e6f6fc61644fd2bf2889e7ee3a3001d42589e0c6cf611.

## HANDOFF-001 — 26 octobre 2026

STEP-027 clôturée au commit 665c0c8, backup vérifié (307 fichiers). L’archive de passation
contient le projet complet et des documents nouveaux, sans modification de code. Le bundle
séparé s’arrête à 665c0c8 ; il n’inclut pas le futur commit documentaire HANDOFF-001.
Après commit, exécuter bash tools/create_backup.sh pour obtenir une sauvegarde incluant
la passation. Voir docs/handoff/GITHUB.md pour push, vérification et restauration.
