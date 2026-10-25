# Environnement Android

## Versions observées — 21 octobre 2026

| Composant | Version / état |
|---|---|
| Poste | Ubuntu 24.04.5 LTS, x86_64 |
| Godot | 4.7.2 standard, archive officielle |
| Templates | Gestionnaire : All templates installed |
| Java et javac | OpenJDK 21.0.12.1 |
| Android Studio | Installé ; version exacte non relevée |
| Platform-Tools | 37.0.1 |
| Build-Tools retenus | 35.0.1 |
| Plateforme SDK retenue | android-35, révision 2 |
| Command-line Tools | 23.0.0, dossier latest |
| NDK | 28.1.13356709 |
| CMake | 3.10.2.4988404 |
| Téléphone | Samsung Galaxy A16 SM-A165F/DSB |
| Modèle retourné par ADB | SM-A165F |
| Android du téléphone | 16 |

Les autres versions SDK déjà installées ont été conservées. La plateforme
SDK de compilation et la version Android du téléphone sont distinctes.

## Java et chemins de l'éditeur

La documentation Godot 4.7 recommande JDK 17 et accepte les versions
supérieures. JDK 21 est conservé pour réutiliser l'installation existante.
Le premier export STEP-004 et l'installation ont depuis été confirmés réussis
par l'utilisateur, sans changement de JDK signalé.

Source :
https://docs.godotengine.org/en/4.7/tutorials/export/exporting_for_android.html

- SDK Android : ~/Android/Sdk.
- JDK observé : /usr/lib/jvm/java-21-openjdk-amd64.
- JAVA_HOME : non défini à l'inventaire.
- ANDROID_HOME : défini vers le SDK utilisateur.
- ANDROID_SDK_ROOT : non défini à l'inventaire.

Les dossiers sont renseignés dans Éditeur > Paramètres de l'éditeur >
Export > Android. Adapter ces chemins sur un autre poste ; utiliser le
sélecteur de dossier sans présumer que les champs développent le tilde.
Ces paramètres locaux ne sont pas des chemins à inscrire dans le preset.

## Installation effectuée

Les composants manquants ont été ajoutés avec le SDK Manager d'Android Studio.
Les templates ont été installés depuis le gestionnaire de Godot.
La commande sdkmanager --list_installed a aussi téléchargé et initialisé
son remplaçant Android CLI : elle n'a pas été strictement sans modification.
Aucun android init n'est requis pour ce projet.

## Connexion USB reproductible

1. Activer les options développeur et le débogage USB du téléphone.
2. Brancher le téléphone déverrouillé avec un câble de données.
3. Exécuter la première commande ci-dessous.
4. Accepter la demande d'autorisation sur le téléphone.
5. Relancer la commande et vérifier l'état device.
6. Lire le modèle et la version Android.

```bash
~/Android/Sdk/platform-tools/adb devices -l
~/Android/Sdk/platform-tools/adb -d shell getprop ro.product.model
~/Android/Sdk/platform-tools/adb -d shell getprop ro.build.version.release
```

Résultats transmis : device, SM-A165F, 16.
L'état initial unauthorized a été résolu par l'autorisation USB.
Aucune modification des permissions Linux n'a été nécessaire.
Le numéro de série n'est pas conservé dans les documents.

## Projet et preset

- Compatibility ; référence initiale 540 × 960 ; orientation Portrait.
- Étirement canvas_items, aspect expand.
- Import des formats VRAM ETC2/ASTC activé ; réglages des futurs sprites à définir.
- Fichier : export_presets.cfg ; preset Android Debug ; plateforme Android.
- Ressources : all_resources ; Gradle désactivé ; arm64-v8a uniquement.
- Paquet : org.gambitarena.prototype ; nom : Gambit Arena.
- STEP-004 : version 0.1.0-step004 ; code 2 ; signature activée ; sortie vide.
- Aucune permission activée dans l'extrait inspecté.

Le nom Android Debug ne sélectionne pas à lui seul le mode de génération :
la case Export With Debug devra être vérifiée au premier export.
Le fichier reçu confirme [runnable_presets] avec Android="Android Debug".
Les éventuels messages de la fenêtre d’export restent à contrôler sur le poste.

## Limites de validation

Le 22 octobre 2026, l'utilisateur confirme tous les tests manuels réussis
sous Godot et sur le Galaxy A16. L'export a produit un APK ; ADB retourne
Success à l'installation. La validation matérielle de STEP-004 est reçue.
Taille préférée confirmée : 48 px de référence.
Aucune mesure de performance soutenue n’a été transmise.
APK testé : step-004-debug.apk. SHA-256 :

```text
c554729004c142a67223176b5c24dd86a28accb6cb6606001339aeeed2f3475b
```

L'assistant n'a pas exécuté cet APK ; ces résultats proviennent de l'utilisateur.

## Export et installation STEP-004

1. Vérifier d'abord F5/F8 et les quatre boutons sous Linux, sans erreur Godot.
2. Créer le dossier de sortie hors du dépôt :

```bash
mkdir -p ~/gambit-arena-builds
```

3. Dans Projet > Exporter, choisir Android Debug puis Exporter le projet.
4. Choisir le fichier step-004-debug.apk dans le dossier gambit-arena-builds
   de son dossier personnel. Garder Export With Debug / Exporter avec débogage coché.
5. Attendre la fin, sans erreur. Exporter PCK/ZIP n'est pas la génération d'un APK.
6. Brancher le téléphone déverrouillé, puis :

```bash
~/Android/Sdk/platform-tools/adb devices -l
~/Android/Sdk/platform-tools/adb -d install -r ~/gambit-arena-builds/step-004-debug.apk
sha256sum ~/gambit-arena-builds/step-004-debug.apk
```

Résultat attendu : device, puis Success. Ouvrir Gambit Arena depuis le téléphone.
Le SHA-256 permet d'identifier exactement l'APK testé ; le transmettre avec
les résultats. Aucun APK ne doit être ajouté au dépôt.

En cas d'erreur d'export ou d'installation, transmettre le texte exact et
s'arrêter à ce point. Ne pas désinstaller aveuglément ni modifier le SDK,
le JDK ou la signature. Les paramètres de signature restent locaux et aucun
mot de passe ni clé ne doit être transmis.

Le protocole tactile, visuel et arrière-plan se trouve dans
[STEP-004](steps/STEP-004.md). Les tests PC ne remplacent pas ces essais.

## Export STEP-005 — validation en attente

La chaîne installée et les tests STEP-004 restent les références validées.
Après import et recette Linux STEP-005, exporter le projet Android Debug avec
Exporter avec débogage coché, vers ~/gambit-arena-builds/step-005-debug.apk.
Le preset livré porte la version 0.1.0-step005, code 3 ; paquet et signature
restent identiques. Aucun APK STEP-005 n'est généré par l'assistant.

```bash
mkdir -p ~/gambit-arena-builds
~/Android/Sdk/platform-tools/adb devices -l
~/Android/Sdk/platform-tools/adb -d install -r ~/gambit-arena-builds/step-005-debug.apk
sha256sum ~/gambit-arena-builds/step-005-debug.apk
```

Exécuter l'installation seulement après la fin de l'export. Résultat attendu :
Success ; ouvrir l'application et vérifier l'en-tête STEP-005. Suivre la recette
docs/steps/STEP-005.md. Transmettre l'erreur exacte si l'une des étapes échoue.

## Résultat STEP-005 reçu — 22 octobre 2026

L’utilisateur confirme croisements, actions et boutons fonctionnels et valide
l’étape. ADB : device, puis installation Success. APK step-005-debug.apk :

```text
86459ba2a752ecd83e7d179d637a40f9c950b14293ebad88914b94fbdfe8d652
```

Les passages « validation en attente » de la procédure de livraison ci-dessus
sont désormais historiques. Le prochain prototype 3D/2D nécessitera son propre
APK et ses propres essais ; aucune performance 3D n’est déduite de ce résultat.

## Export TRANSITION-001 — en attente de validation

Conserver Godot 4.7.2, Compatibility, le SDK/JDK et la signature ayant fonctionné.
Après import et tests PC, exporter Android Debug avec débogage coché vers
~/gambit-arena-builds/transition-001-debug.apk. Version 0.1.0-transition001,
code 4. Aucun APK n’a été produit chez l’assistant.

```bash
mkdir -p ~/gambit-arena-builds
~/Android/Sdk/platform-tools/adb devices -l
~/Android/Sdk/platform-tools/adb -d install -r ~/gambit-arena-builds/transition-001-debug.apk
sha256sum ~/gambit-arena-builds/transition-001-debug.apk
```

Installer seulement après export réussi. Attendu : Success. Ouvrir l’application,
vérifier l’en-tête TRANSITION-001 puis suivre docs/steps/TRANSITION-001.md.
En cas d’échec ou d’écran opaque masquant le fond, transmettre le message/capture
sans modifier au hasard le renderer ou le SDK. La 3D doit être validée séparément.

## Résultat TRANSITION-001 — 22 octobre 2026

Validation explicite utilisateur reçue le 22 octobre 2026.
- Damier 2D sous les mannequins : OK.
- Projection 2.000:1, erreur < 0,001 : OK.
- Ancrages et profondeur entre personnages : OK.
- Passage derrière/devant le décor 2D : OK.
- Boutons, pause et F8 : OK ; validation globale de l’étape reçue.
- Taille préférée en 3D : 48 px de référence.
- Relevé utilisateur : moyenne 60 FPS, pire image 16,7 ms, aucune saccade.
- Installation ADB : Success sur Galaxy A16 Android 16.
- SHA-256 APK : 124654de74db47ac162a9f925d7f4f3844aa7504a316f43a559c4a3d86635f10.

Ces mesures concernent le diagnostic livré et sont rapportées par l’utilisateur.
Elles ne qualifient pas les futurs modèles riggés, animations, combat ou effets.
Durée exacte du relevé, charge batterie/secteur et économie d’énergie non précisées
séparément dans le retour ; aucun profil GPU ni capture n’a été transmis.

La section d’export « en attente de validation » ci-dessus est désormais historique.

## Export STEP-006 — en attente de validation

Après tests Godot, exporter Android Debug avec débogage vers
~/gambit-arena-builds/step-006-debug.apk. Version 0.1.0-step006, code 5.
Ne pas laisser l’APK ou le .idsig à la racine du dépôt : ils bloqueraient la
sauvegarde propre, comme lors de la clôture précédente. Aucun export fait ici.

```bash
mkdir -p ~/gambit-arena-builds
~/Android/Sdk/platform-tools/adb devices -l
~/Android/Sdk/platform-tools/adb -d install -r ~/gambit-arena-builds/step-006-debug.apk
sha256sum ~/gambit-arena-builds/step-006-debug.apk
```

Installer seulement après l’export. Attendu : Success, puis en-tête STEP-006.
Suivre docs/steps/STEP-006.md. Conserver le JDK/SDK et la signature qui fonctionnent.

## Résultat STEP-006 reçu — 22 octobre 2026

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

La mention « en attente de validation » de la procédure d’export ci-dessus est historique.

## Export STEP-007 — validation en attente

Après les tests F6 et la recette F5, exporter Android Debug avec débogage vers
~/gambit-arena-builds/step-007-debug.apk. Version 0.1.0-step007, code 6.
Conserver le SDK/JDK, le renderer et la signature qui fonctionnent.

```bash
mkdir -p ~/gambit-arena-builds
~/Android/Sdk/platform-tools/adb devices -l
~/Android/Sdk/platform-tools/adb -d install -r ~/gambit-arena-builds/step-007-debug.apk
sha256sum ~/gambit-arena-builds/step-007-debug.apk
```

Installer seulement après export réussi. Attendu : Success, en-tête STEP-007.
Suivre docs/steps/STEP-007.md, notamment perte de cible et pause en déplacement.
Aucun APK ni test matériel de cette étape réalisé chez l’assistant.

## Résultat STEP-007 reçu — 22 octobre 2026

Validation explicite utilisateur reçue le 22 octobre 2026.
- Banc de tests Godot F6 : OK, zéro échec, confirmé par l’utilisateur.
- Approche A puis B puis arrêt sans cible : OK.
- Changement de cible en mouvement sans téléportation et annulation : OK.
- Vitesse nominale proche de 1,20 u/s, hors dernier pas et bordure : OK.
- Respect de la limite avec une cible extérieure : OK.
- Disparition de A après 0,75 s, arrêt sans erreur : OK.
- Pause : position et pose figées, reprise sans saut : OK.
- ADB : téléphone en état device, installation Success sur Galaxy A16.

APK testé : step-007-debug.apk. SHA-256 :

```text
fa80fcb980db86072b1c8237540b7170d845fd266324ea287f4c4b9f90ade610
```

Ces résultats proviennent de l’utilisateur ; l’assistant n’a pas exécuté Godot.
Aucune mesure de performance ni capture n’a été transmise pour cette étape.
Les essais spécifiques accueil/verrouillage ne sont pas détaillés séparément
dans ce retour ; la validation globale est reçue sans inventer un relevé par test.

La mention « validation en attente » dans la procédure précédente est historique.

## STEP-008 — validation reçue

Version 0.1.0-step008, code 7, export Android Debug avec débogage vers
~/gambit-arena-builds/step-008-debug.apk. Installation Success confirmée.
Tests manuels OK, aucune saccade ; verrouillage et réduction/retour OK.
SHA-256 : 214b055b0f4af6c095c0827018d0f1a2108bffa603dd97a43a18c80dbfe50f3c. Aucune mesure FPS chiffrée reçue.
Voir docs/steps/STEP-008.md pour installation ADB, SHA-256 et critères : côtés,
poursuite, plafond 20, pause, reprise Android et réinitialisation.
L’APK STEP-007 reste validé : fa80fcb980db86072b1c8237540b7170d845fd266324ea287f4c4b9f90ade610.
Ne jamais exporter dans le dépôt ; ne pas commiter APK/idsig.

## STEP-009 — validation reçue

Version 0.1.0-step009, code 8. Export Android Debug avec débogage vers
~/gambit-arena-builds/step-009-debug.apk. Installation Success confirmée.
Tests manuels et F6 OK, fluidité confirmée. SHA-256 :
ff61292efe28c5688fd537982efe2f5ff03672c7934f2edeab19b5e7bf8bb24f.
Tester encerclement, poursuite, blocage puis ouverture, bordure, pause et retours
Android. Voir docs/steps/STEP-009.md. Les performances STEP-008 ne valident pas
cette nouvelle logique de contacts. Conserver APK/idsig hors du dépôt.

## Passage à STEP-010

STEP-010 : version 0.1.0-step010, code 9. Export Debug avec débogage vers
~/gambit-arena-builds/step-010-debug.apk. Recette : docs/steps/STEP-010.md.
Installation ADB Success confirmée sur SM-A165F. Tests manuels et F6 OK,
aucun doublon. SHA-256 APK :
1ca1bbdaca13512c31d5627bea7fa0994aaeaa2d9619950a01a44b794b5a6c1e.

## Passage à STEP-011

STEP-011 : version 0.1.0-step011, code 10. Export Android Debug avec débogage
vers ~/gambit-arena-builds/step-011-debug.apk, hors dépôt.
Recette : docs/steps/STEP-011.md. F6, tests manuels et fluidité OK.
SHA-256 APK communiqué :
b6fe668b4647f2b84e2b8271a1e06bb351fe0e3247412de80f58663d7b879c3e.

## Passage à STEP-012

STEP-012 : version 0.1.0-step012, code 11. Export Debug avec débogage vers
~/gambit-arena-builds/step-012-debug.apk. Recette : docs/steps/STEP-012.md.
F6, tests manuels et fluidité confirmés OK. SHA-256 APK communiqué :
cb301ad46d5332a33f22162c20cba0257126f403f914c5ea14c7daba8e100892.

## Passage à STEP-013

STEP-013 : version 0.1.0-step013, code 12. Export Debug avec débogage vers
~/gambit-arena-builds/step-013-debug.apk. Recette : docs/steps/STEP-013.md.
F6, tests manuels et fluidité confirmés OK. SHA-256 APK communiqué :
8d8dfe72772347cb335f1849207b222a0683dec78bd656ba7b61543dce2c5cf2.

## Passage à STEP-014

STEP-014 : version 0.1.0-step014, code 13. Export Debug avec débogage vers
~/gambit-arena-builds/step-014-debug.apk. Recette : docs/steps/STEP-014.md.
F6, tests manuels et fluidité confirmés OK. SHA-256 APK communiqué :
ac06b695682b55268e741cffbaa1c3316022feb1daf10e30a7851e9fc83417d8.

## Passage à STEP-015

STEP-015 : version 0.1.0-step015, code 14. Export Debug avec débogage vers
~/gambit-arena-builds/step-015-debug.apk. Recette : docs/steps/STEP-015.md.
F6, tests manuels et fluidité confirmés OK. SHA-256 APK communiqué :
90f39d41ad59a995179614e55bda1b9f41c96e0ca51081918b088cd12c137d5b.

## Passage à STEP-016

STEP-016 : version 0.1.0-step016, code 15. Export Debug avec débogage vers
~/gambit-arena-builds/step-016-debug.apk. Recette : docs/steps/STEP-016.md.
F6, tests manuels et fluidité confirmés OK. SHA-256 APK communiqué :
a844beb6d1c6bb10010944d52b35153267ce9bd3f21a953aed44304d2180971c.

## Passage à STEP-017

STEP-017 : version 0.1.0-step017, code 16. Export Debug avec débogage vers
~/gambit-arena-builds/step-017-debug.apk. Recette : docs/steps/STEP-017.md.
F6, tests manuels et fluidité confirmés OK. SHA-256 APK communiqué :
ab0c538b8e84c680d4992dc19dbec32bfa0de7f33f94974079981e55e7ace6a8.

## Passage à STEP-018

STEP-018 : version 0.1.0-step018, code 17. Export Debug avec débogage vers
~/gambit-arena-builds/step-018-debug.apk. Recette : docs/steps/STEP-018.md.
F6, tests manuels et fluidité confirmés OK. SHA-256 APK communiqué :
aadad09948a5ce8ccf5c078075cce4a86e1e3fb38158fffae6602aa096af96ef.

## Passage à STEP-019

STEP-019 : version 0.1.0-step019, code 18. Export Debug avec débogage vers
~/gambit-arena-builds/step-019-debug.apk. Recette : docs/steps/STEP-019.md.
STEP-019 v2 validée par le retour utilisateur global. SHA-256 APK :
804fb0fd6521cbcafe374c582560d0284cc93f13cab9002acbd47d89593806c8.

STEP-019 v1 : SHA-256 reçu 7fd4027080d9f560a77168d0256ced18ab322ec139084690271b805b89f4672a,
avec réserve sur un petit pas à l’attaque. V2 FIX-STEP-019-001 ensuite validée ; empreinte ci-dessus.

## Passage à STEP-020

STEP-020 : version 0.1.0-step020, code 19. Export Debug avec débogage vers
~/gambit-arena-builds/step-020-debug.apk. Recette : docs/steps/STEP-020.md.
F6, tests manuels et fluidité confirmés OK. SHA-256 APK communiqué :
084cc3ea0e03a553f00a111683f048db0b5f4331a3c5b6782c4aa872b5cfe97e.

## Passage à STEP-021

STEP-021 : version 0.1.0-step021, code 20. Export Debug avec débogage vers
~/gambit-arena-builds/step-021-debug.apk. Recette : docs/steps/STEP-021.md.
F6, tests manuels et fluidité confirmés OK. SHA-256 APK communiqué :
224dfb87269dd7cd4a955eb3813711fdfb6c72b68af8e060ffa39a5d94a68b35.

## Passage à STEP-022

STEP-022 : version 0.1.0-step022, code 21. Export Debug avec débogage vers
~/gambit-arena-builds/step-022-debug.apk. Recette : docs/steps/STEP-022.md.
F6, tests manuels et fluidité confirmés OK. SHA-256 APK communiqué :
2c3c52c1d17d10049a037dac8a7618ee197f54b6d2099bbf1473e7dc0a77366d.
