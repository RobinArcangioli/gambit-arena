# Gambit Arena

Arena RPG en temps réel, développé sous Linux pour Android portrait.
Le héros se déplace automatiquement selon des règles prioritaires
configurables, appelées gambits.

## Environnement retenu

- Godot 4.7.2, édition standard, GDScript.
- Rendu Compatibility sur ordinateur et mobile.
- Git 2.43.0 utilisé pour l'initialisation.
- Poste observé : Ubuntu 24.04.5 LTS, x86_64.
- Téléphone : Samsung Galaxy A16 SM-A165F/DSB, Android 16.
- ADB retourne SM-A165F et l'état device.
- SDK Android et templates Godot préparés ; JDK 21 conservé pour le premier essai.
- Aucun export réel n'a encore confirmé le fonctionnement de cette chaîne.

## Reconstruction et sauvegardes

Cette archive contient le projet complet jusqu'à STEP-003 corrigée et validée.
Le dossier Git ayant été supprimé, aucun ancien historique n'est inclus.
La copie restaurée a été testée et validée par l’utilisateur le 22 octobre 2026.
Le nouveau commit de reprise reste à créer et à vérifier.
Voir [la reprise](docs/recovery.md) et [la politique de sauvegarde](docs/backup.md).
Après chaque commit propre : `bash tools/create_backup.sh`.

## État actuel

STEP-003 livre un laboratoire de projection : trois acteurs temporaires mobiles,
un pilier non bloquant, un tri aux pieds, des coordonnées et un contrôle numérique.
Cette scène de diagnostic ne constitue pas encore le gameplay du héros.
Aucun APK n'a été généré ou testé.

## Ouvrir et lancer sous Linux

1. Ouvrir le gestionnaire de projets Godot 4.7.2.
2. Importer le fichier project.godot de ce dossier si nécessaire.
3. Ouvrir le projet.
4. Appuyer sur F5.
5. Vérifier que le laboratoire STEP-003 apparaît, sans erreur dans le débogueur.
6. Appuyer sur F8 pour arrêter.

La scène principale est scenes/main.tscn. Elle est référencée par UID
dans project.godot. Cet UID est également enregistré dans la scène.

## Recette du laboratoire

- Espace : pause/reprise locale.
- R : retour au début du cycle, sans changer l'état pause/marche.
- T : alternance de la silhouette normale/haute.
- Observer un cycle complet de huit secondes et le texte Projection/inverse.

Procédure et résultats attendus : [STEP-003](docs/steps/STEP-003.md).
Le lancement corrigé et la recette ont été validés par l'utilisateur le
22 octobre 2026, avec croisements confirmés sans ambiguïté. Godot n'était
pas disponible dans l'environnement de préparation de l'assistant.

## Vérifications Git

Depuis la racine du projet :

- git status --short --branch : état de la branche et des fichiers.
- git diff : modifications des fichiers déjà suivis.
- git diff --cached : contenu préparé pour le prochain commit.
- git log --oneline : historique après le premier commit.

Attention : git diff ne montre pas le contenu des fichiers non suivis.

## Android

L'environnement Android, les templates et le preset sont préparés.
La connexion USB est vérifiée sur le téléphone de référence.
Voir [la procédure Android](docs/android.md).

Le projet est configuré en portrait, avec une référence initiale de 540 × 960.
Le preset Android Debug cible ARM64 et utilise les templates APK standards,
sans compilation Gradle personnalisée.

Aucun APK n'a été généré, installé ou testé. La compatibilité de Java 21 dans
cette chaîne, la signature et l'export restent à éprouver.
Le premier APK avec sprite mobile et tri visuel est prévu en STEP-004.

## Documents

- [Roadmap](ROADMAP.md)
- [Architecture réelle](ARCHITECTURE.md)
- [État de reprise](PROJECT_STATUS.md)
- [Livraison STEP-001](docs/steps/STEP-001.md)
- [Préparation STEP-002](docs/steps/STEP-002.md)
- [Environnement Android](docs/android.md)
- [Livraison STEP-003](docs/steps/STEP-003.md)
- [Coordonnées et profondeur](docs/coordinates.md)
- [Assets temporaires](docs/assets.md)

## Méthode

Une étape = un résultat observable, des tests, une validation utilisateur,
puis un commit comprenant sa documentation.

Les vérifications exécutées par le développeur sont identifiées comme
telles. Aucune validation matérielle n'est déduite d'un test sur PC.

Les mises à jour documentaires sont livrées sous forme de fichiers complets
à remplacer, puis à relire avec le diff Git. Le développeur n'a pas à reporter
manuellement les modifications dans chaque document.
