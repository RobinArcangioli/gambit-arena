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
