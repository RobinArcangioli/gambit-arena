# État du projet — 26 octobre 2026

## STEP-028 — validée par l'utilisateur, commit et sauvegarde en attente

Base réelle vérifiée : cc91c79b0bcf82df6fb852d9b792fce63aa32148, main propre et identique
à GitHub au démarrage. Aucun changement utilisateur à écraser. HANDOFF-001 a bien été
commitée et publiée ; les sections historiques ci-dessous décrivent sa rédaction antérieure.

Instrumentation optionnelle, captures bornées, menu de mesures et export JSON implémentés.
Protocole fixé dans docs/performance.md : chauffe 30 s, capture 60 s, trois répétitions
Normal/20 ennemis et dix resets. Tests et mesures effectifs : docs/steps/STEP-028.md.
L'objectif initial de 30 FPS n'est pas atteint par cet APK Debug, avec ou sans économie
d'énergie ; le propriétaire a explicitement accepté la performance pour le contenu prévu et a
retiré 20 ennemis simultanés des critères de livraison. Aucun correctif de rendu spéculatif n'a
été intégré. Le propriétaire a explicitement validé F6, F5, tactile Android et pause/reprise.
STEP-028 est donc validée par l'utilisateur ; aucun commit/push ni sauvegarde STEP-028 n'a été
effectué.

## Dernière étape fonctionnelle clôturée

STEP-027 : validée et commitée, sauvegarde reçue et vérifiée.
Commit : 665c0c8d86a6400f88c77773295ed06b1a518206 ; branche main propre au checkpoint.
Parent : 344a584ec680ba7b45fb648b3a2eceb8937a97ae.
Backup : gambit-arena-20261026-011155-665c0c8d86a6.tar.gz.
Bundle complet, fsck OK, 307 fichiers identiques entre commit/backup/livraison validée.
APK : step-027-debug.apk ; version 0.1.0-step027, code 27.
SHA-256 : 07467efcfb7e663e363e6f6fc61644fd2bf2889e7ee3a3001d42589e0c6cf611.
Retour utilisateur : F6 OK, tests manuels OK, fluidité OK. Aucun résultat détaillé par banc
ou mesure chiffrée fourni. Aucune nouvelle réserve signalée à cette clôture.

## HANDOFF-001 — Documents préparés, commit/push à effectuer

Demande utilisateur : documenter le projet pour une prochaine IA, créer une archive et
fournir les commandes de push GitHub. Livrable : gambit-arena-complet-handoff-001.tar.gz.
Documents d’entrée actualisés et dossier docs/handoff ajouté. Aucun changement de code,
scène, test, asset, preset ou project.godot ; aucun nouvel APK requis.
Le bundle inclus reste celui de 665c0c8 ; les documents sont dans les sources mais pas encore
commités. Aucun hash documentaire ni URL GitHub ne sont inventés. Aucun push effectué ici.
La prochaine IA doit vérifier si le commit/push a été réalisé après rédaction de cet état.

## Suite

Préparer le commit STEP-028, créer la sauvegarde après le commit et vérifier celle-ci.
Transmettre le hash, le statut et la nouvelle sauvegarde pour vérification. STEP-029 et
STEP-030 restent à faire et nécessitent leur propre GO ; aucun push n'est implicite.

## Limites de preuve

Les limites « Godot non disponible » des sections historiques décrivent HANDOFF-001, non le
travail STEP-028 effectivement exécuté. Le clone propre final et la recette MVP finale restent
à réaliser. Voir HANDOFF.md et docs/handoff/NEXT_STEPS.md.
