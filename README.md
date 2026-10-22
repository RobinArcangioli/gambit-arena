# Gambit Arena

Arena RPG en temps réel, Godot 4.7.2 standard, Android portrait.
Le projet actuel est un laboratoire d'assets ; le combat et les gambits
restent aux étapes prévues dans ROADMAP.md.

## État

STEP-004 validée sous Linux et sur Galaxy A16, commit 491cde8 sauvegardé.
STEP-005 : laboratoire 2D validé le 22 octobre 2026, commit en attente.
Nouvelle cible décidée : personnages 3D sur fond 2D isométrique.
La migration n’est pas encore implémentée ; voir docs/decisions/DEC-001-personnages-3d.md.
Taille retenue en 2D : 48 pixels de référence, à l’échelle 540 × 960.
Ce repère visuel sera réévalué avec les personnages 3D.
Godot Compatibility ; Galaxy A16 SM-A165F/DSB, Android 16 ; Java 21 et SDK
existants conservés après le premier export réussi.

## Lancer

Ouvrir project.godot, attendre l'import, puis F5. Le nouveau laboratoire
STEP-005 montre un héros cyan et un ennemi rouge, immobiles au départ.
F8 arrête l'exécution depuis l'éditeur. Vérifier le débogueur.

| Bouton | Touche | Fonction |
|---|---|---|
| État | A | Idle → Move → Attack → Hit → Death |
| Direction | D | SE → SO → NE → NO |
| Pause / Reprendre | Espace | Suspend les animations et le trajet de diagnostic |
| Rejouer | R | Retour à la première image et au début du trajet |
| Croisement | C | Active les trajets automatiques pour vérifier le tri |
| Image suivante | N | Passe en pause et avance d'une image |

Idle et Move bouclent. Attack, Hit et Death sont jouées une fois puis gardent
leur dernière image. Rejouer les relance ; en pause, il faut aussi Reprendre.
Le changement d'état/direction repart à l'image 1 sans quitter la pause.
La perte de focus suspend le laboratoire ; le retour attend Reprendre.
Les croisements sont un diagnostic indépendant de l'animation choisie.

L'ancien laboratoire STEP-004 reste disponible : ouvrir
scenes/debug/projection_lab.tscn et utiliser F6 pour le lancer seul.
F5 lance toujours le nouveau laboratoire.

## Tester et exporter

Recette : [STEP-005](docs/steps/STEP-005.md).
Export Android Debug, version 0.1.0-step005, code 3, paquet inchangé.
Exporter vers ~/gambit-arena-builds/step-005-debug.apk puis installer avec ADB.
Voir [Android](docs/android.md). Aucun APK de cette étape n'est fourni.

Les nouveaux .svg.import et .gd.uid seront générés par Godot à l'import :
les inclure dans le commit validé, en conservant .godot/ ignoré.
Le script Python tools/generate_actor_atlases.py est une source reproductible
facultative ; les SVG sont déjà présents, aucun outil externe à installer.

## Sauvegardes et méthode

Chaque livraison est une archive complète. Le bundle fourni à côté du projet
contient le commit de base, pas les modifications STEP-005 non commitées.
Après validation, documents actualisés et commit, avec dépôt propre :

```bash
bash tools/create_backup.sh
```

Transmettre cette sauvegarde avant la prochaine étape.
L'extraction de la livraison conserve le .git local ; ne pas réinitialiser Git.
Godot n'est pas disponible chez l'assistant : les contrôles statiques et le
rendu SVG ne sont pas une compilation ou un test Godot.

## Documents

- [État exact](PROJECT_STATUS.md), [Roadmap](ROADMAP.md), [Architecture](ARCHITECTURE.md)
- [Assets et animations](docs/assets.md), [Coordonnées](docs/coordinates.md)
- [Android](docs/android.md), [Sauvegardes](docs/backup.md), [Reprise](docs/recovery.md)
- Fiches historiques : docs/steps/STEP-001.md à STEP-004.md
- [Étape en cours](docs/steps/STEP-005.md)
