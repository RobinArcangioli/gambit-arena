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
Son fonctionnement dans cette chaîne n'est pas encore confirmé par un export.

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
- Version : 0.1.0 ; code 1 ; signature activée ; chemin de sortie vide.
- Aucune permission activée dans l'extrait inspecté.

Le nom Android Debug ne sélectionne pas à lui seul le mode de génération :
la case Export With Debug devra être vérifiée au premier export.
La validation globale de l'étape a été reçue ; aucun résultat UI distinct
n'a été transmis pour Runnable et les messages de la fenêtre d'export.

## Limites de validation

Aucun APK généré, installé ou lancé. Le fonctionnement de l'export,
de la signature et du JDK dans cette chaîne reste à vérifier.
F5/F8 ont été testés uniquement sous Linux.
Le premier prototype visuel sur téléphone est prévu en STEP-004.
