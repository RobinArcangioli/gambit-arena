# STEP-008 — Apparition et poursuite des ennemis

## Statut et dépendances

Validée, commit en attente. GO reçu après clôture STEP-007, base
9b3240c16632e89afa6354cda2eecbe5077e57ba. Sauvegarde avec historique reçue,
clonée et comparée : 78 fichiers versionnés identiques.
Livraison : gambit-arena-complet-step-008-v1.tar.gz.

## Objectif et périmètre

Ennemis apparaissant aux côtés intérieurs de l’arène, poursuivant la position
actuelle du héros, sans dépassement d’arrivée. Un contrôleur indépendant par
ennemi, plafond 20, pause commune et réinitialisation reproductible.
Les mannequins 3D 48 px et le fond 2D sont conservés. Pas de séparation ni de
combat à cette étape ; les superpositions entre ennemis sont attendues.

## Installation

Fermer Godot. Depuis un dépôt propre sur 9b3240c :

```bash
cd ~/gambit-arena
git status --short --branch
git log -1 --format="%h %s"
tar -xzf ~/Downloads/gambit-arena-complet-step-008-v1.tar.gz -C ~
git diff --check
git status --short --branch
```

Ne pas supprimer le dossier du projet ni .git. L’archive contient le projet
complet, une notice et le bundle de base séparé ; elle ne remplace pas .git.
Rouvrir project.godot et attendre la fin de l’import. Conserver les nouveaux UID.

## Banc automatisé Godot

Ouvrir scenes/tests/enemy_director_tests.tscn puis F6.
Attendu : OK, zéro échec. Signaler toute erreur avec son texte complet.
F8 pour arrêter ; F5 pour le laboratoire. Le banc vérifie les vrais scripts,
pas une recopie du calcul. Il n’a pas été exécuté chez l’assistant (Godot absent).

## Recette manuelle éditeur puis téléphone

1. F5 : titre STEP-008 / POURSUITE. En mode 1/3 Héros fixe, les ennemis arrivent
   un par un aux quatre côtés, une seconde entre apparitions. Le compteur atteint
   4/20, émis 4/4, puis reste stable. Ils s’arrêtent près du héros sans oscillation.
2. Bouton 1/3 (P) : mode 2/3 Héros mobile. Le héros suit un carré automatiquement,
   les ennemis le poursuivent et tournent avec lui, sans téléportation.
3. Apparitions non (S) pendant la séquence : aucun nouveau mannequin, les ennemis
   présents continuent. Oui : cadence reprise sans création groupée.
4. Retirer héros (H) : cyan invisible, ennemis arrêtés, nouvelles apparitions
   suspendues. Rendre héros : poursuite reprise, aucun saut de position.
5. Pause pendant des apparitions : temps, positions et poses restent figés.
   Repères reste utilisable ; choix de mode, apparitions et retrait sont bloqués.
   Reprendre : pas de rafale ni de saut. Rejouer en pause réinitialise en restant figé.
6. Mode 3/3 Plafond 20 : attendre au moins 25 secondes actives ; compteur 20/20,
   émis 20/20, aucun dépassement après dix secondes supplémentaires. Mannequins
   dans l’arène et interface accessible ; les chevauchements sont attendus.
7. Rejouer plusieurs fois, y compris après retrait du héros : compteur zéro,
   héros restauré, aucun ancien ennemi visible, premières apparitions après 1 s.
8. Les six cases À venir restent inactives. Aucun message d’erreur. F8 arrête.
9. Sur Android, accueil puis retour et verrouillage puis retour : pause conservée,
   reprise explicite, sans rafale d’apparitions. Noter toute anomalie.

Sur le téléphone, indiquer les saccades éventuelles en mode 20 et, si disponible,
FPS moyen/pire image via les outils habituels. Aucune performance n’est présumée.

## Export et installation Android

Exporter Android Debug, option de débogage cochée, vers :
~/gambit-arena-builds/step-008-debug.apk. Version 0.1.0-step008, code 7.

```bash
mkdir -p ~/gambit-arena-builds
~/Android/Sdk/platform-tools/adb devices -l
~/Android/Sdk/platform-tools/adb -d install -r ~/gambit-arena-builds/step-008-debug.apk
sha256sum ~/gambit-arena-builds/step-008-debug.apk
```

Résultats et empreinte consignés ci-dessous. Ne pas ajouter APK/idsig au dépôt.

## Fichiers et architecture

Nouveaux scripts : scripts/enemies/enemy_unit.gd, enemy_director.gd, pursuit_lab.gd.
Nouvelles scènes : scenes/enemies/pursuit_lab.tscn et scenes/tests/enemy_director_tests.tscn.
Tests : tests/test_enemy_director.gd. Description : docs/enemies.md.
Main et version Android mis à jour ; documentation actualisée. GroundMover,
arène, anciens laboratoires, assets et métadonnées existantes conservés.

Les commandes de scénario sont temporaires. L’IA sélectionne uniquement le héros
fourni ; aucun gambit, déplacement tactile manuel ou système de vagues ajouté.
La route du héros est une source d’intentions de diagnostic, pas le futur gameplay.

## Vérifications de livraison et clôture

Références res://, préservation des fichiers antérieurs, espaces de fin de ligne,
configuration et intégrité de l’archive vérifiés statiquement. Exécution Godot,
rendu Android et export restent à confirmer par l’utilisateur.
Après validation explicite : archive complète de validation avec résultats,
puis commit feat: [STEP-008] ajouter les ennemis et leur poursuite.
Sauvegarde propre via bash tools/create_backup.sh et transmission pour vérification.
STEP-009 attend cette clôture et un nouveau GO.

## Validation reçue le 22 octobre 2026

Validation explicite de STEP-008 par l’utilisateur : tous les tests manuels OK,
aucune saccade observée, verrouillage et réduction/retour OK. Installation ADB
Success sur Samsung Galaxy A16 SM-A165F, Android 16.
APK testé : step-008-debug.apk ; version 0.1.0-step008, code 7.
SHA-256 : 214b055b0f4af6c095c0827018d0f1a2108bffa603dd97a43a18c80dbfe50f3c.

Aucun chiffre FPS ou temps d’image fourni. Le résultat du banc automatisé F6
n’est pas mentionné séparément dans ce retour ; aucun résultat chiffré ni
« zéro échec » n’est ajouté par déduction. Validation globale utilisateur reçue.
Code testé conservé à l’identique dans cette livraison documentaire.
Statut : Validée, commit en attente.

## Clôture confirmée

Commit 46dfaa77ac79fccccebe165973a1bdbfb1000cf4, main propre. Sauvegarde
reçue gambit-arena-20261022-210049-46dfaa77ac79.tar.gz : historique complet,
clone restauré, HEAD confirmé, 90 fichiers identiques. STEP-009 autorisée par GO.
Les mentions « commit en attente » ci-dessus décrivent la livraison de validation.
