# Gambit Arena

Arena RPG en temps réel sous Godot 4.7.2 standard, pour Android portrait.
Le héros utilisera des règles prioritaires configurables, appelées gambits.
À ce stade, le projet est un laboratoire visuel à déplacements scriptés.

## État actuel

STEP-001 à STEP-003 validées ; restauration validée et commitée dans 6282d81.
STEP-004 validée par l’utilisateur le 22 octobre 2026 sous Godot et sur Galaxy A16.
APK exporté, installé avec succès et testé. Commit STEP-004 en attente.
Taille préférée confirmée : 48 px de référence, retenus pour la suite.

Environnement : Ubuntu 24.04.5, Git 2.43.0, Godot Compatibility, référence
540 × 960, Samsung Galaxy A16 SM-A165F/DSB sous Android 16. SDK et modèles
installés, ADB autorisé, Java 21 conservé pour le premier export réel.

## Ouvrir et tester

Ouvrir project.godot dans Godot 4.7.2, attendre l'import, puis F5.
La scène principale conserve son UID et lance le laboratoire STEP-004.
F8 arrête le projet depuis l'éditeur. Vérifier le débogueur.

| Bouton | Clavier | Résultat |
|---|---|---|
| Pause / Reprendre | Espace | Suspend ou relance le cycle local |
| Taille | S | 48 → 64 → 80 → 48 pixels de référence |
| Repartir | R | Temps à zéro, conserve pause/marche |
| Silhouette | T | Active l'alternance normale/haute |

Trois acteurs, un pilier non bloquant et deux zones de croisement permettent
de vérifier le tri aux pieds. Le cycle dure huit secondes. Le changement de
taille touche les visuels, pas leurs positions logiques. La silhouette haute
est désactivée au lancement. La perte de focus suspend le laboratoire ;
la reprise est explicite. Les FPS affichés ne sont pas un benchmark.

## Premier APK

Suivre [Android](docs/android.md) pour exporter un APK Debug ARM64 standard,
sans Gradle personnalisé, dans ~/gambit-arena-builds/. L'APK STEP-004 porte
la version 0.1.0-step004, code 2, paquet org.gambitarena.prototype.
Les paramètres locaux SDK/JDK et de signature ne sont pas dans l'archive.
La recette complète figure dans [STEP-004](docs/steps/STEP-004.md).

## Sauvegardes

La livraison contient le projet complet et, à côté, le bundle Git du commit
de base 6282d81. Ce bundle ne contient pas les modifications STEP-004 encore
non commitées. Le dépôt Git existant est conservé lors de l'extraction.
Après chaque étape validée et commitée, avec un dépôt propre :

```bash
bash tools/create_backup.sh
```

Transmettre l'archive produite pour conserver aussi le nouvel historique.
Voir [Sauvegarde](docs/backup.md) et [Reprise](docs/recovery.md).

## Documents

- [État exact et prochaine action](PROJECT_STATUS.md)
- [Roadmap](ROADMAP.md)
- [Architecture réelle](ARCHITECTURE.md)
- [Coordonnées et profondeur](docs/coordinates.md)
- [Assets temporaires](docs/assets.md)
- [STEP-001](docs/steps/STEP-001.md), [STEP-002](docs/steps/STEP-002.md),
  [STEP-003](docs/steps/STEP-003.md), [STEP-004](docs/steps/STEP-004.md)

## Méthode

Une étape = livraison complète, tests, validation utilisateur, documents de
validation complets, commit puis sauvegarde. Aucun résultat matériel n'est
inféré d'un test PC. Godot est indisponible chez l'assistant pour cette livraison :
les contrôles statiques ne remplacent pas l'import et l'exécution sur le poste.
La prochaine étape attend la clôture de celle-ci et un nouveau feu vert.
