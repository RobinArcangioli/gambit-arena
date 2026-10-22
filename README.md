# Gambit Arena

Jeu Android portrait sous Godot 4.7.2 standard, rendu Compatibility.
Cible : personnages 3D sur fond 2D isométrique, déplacement automatique et gambits.
Le gameplay n’est pas encore implémenté : le projet est un prototype de rendu.

## État

STEP-005 validée et sauvegardée dans 44f81d5. TRANSITION-001 validée par
l’utilisateur le 22 octobre 2026 sous Godot et sur Galaxy A16, commit en attente.
Taille préférée confirmée en 3D : 48 px de référence. Relevé du diagnostic :
60 FPS moyens, pire image 16,7 ms, aucune saccade signalée.

## Ouvrir et lancer

Ouvrir project.godot, attendre l’import puis F5. L’en-tête doit être
TRANSITION-001 / 3D + FOND 2D. F8 arrête depuis l’éditeur.
La grille est dessinée en 2D ; les mannequins sont de vrais volumes éclairés.
Le mode décor utilise une image 2D verticale dans le même monde 3D pour tester
l’occultation. Il ne s’agit pas encore du fond artistique définitif.

| Bouton | Touche | Effet |
|---|---|---|
| Mode | M | Croisement → Décor 2D → Charge 20 |
| Échelle | S | 48 → 64 → 80, échelle relative des mannequins |
| Pause / Reprendre | Espace | Fige/reprend le cycle, les poses et les mesures |
| Repartir | R | Cycle et mesures à zéro, conserve l’état de pause |
| Repères | G | Grille, axes et croix d’ancrage |
| Marche | W | Balancement des membres activé/désactivé |

Marche ne commande pas les trajets : désactivée, les mannequins glissent
volontairement pour inspecter l’ancrage. La perte de focus ou l’arrière-plan
Android suspend le diagnostic ; la reprise attend une action explicite.
Les métriques sont indicatives et ne qualifient pas le futur jeu en combat.

Anciens laboratoires conservés : ouvrir scenes/debug/animation_lab.tscn ou
projection_lab.tscn puis F6. F5 ouvre toujours la transition.

## Android et tests

Suivre [TRANSITION-001](docs/steps/TRANSITION-001.md), puis exporter Android Debug
avec débogage vers ~/gambit-arena-builds/transition-001-debug.apk.
Version 0.1.0-transition001, code 4 ; signature et paquet conservés.
Godot et le téléphone ne sont pas disponibles chez l’assistant : aucune exécution
ou export de cette transition n’a été fait ici. Transmettre les erreurs exactes.

## Sources et sauvegardes

Les mannequins sont générés par GDScript avec des primitives Godot ; aucun modèle
externe ni logiciel 3D n’est requis pour ce prototype. Le SVG du décor est fourni.
Conserver les .gd.uid et .svg.import générés par l’import, et ignorer .godot/.
La livraison complète conserve le .git existant et contient, séparément, le
bundle du commit de base. Après validation et commit, dépôt propre :

```bash
bash tools/create_backup.sh
```

Transmettre l’archive obtenue avant l’étape suivante.

## Documents

- [État exact](PROJECT_STATUS.md), [Roadmap](ROADMAP.md), [Architecture](ARCHITECTURE.md)
- [Contrat du rendu hybride](docs/hybrid-rendering.md)
- [Décision 3D/2D](docs/decisions/DEC-001-personnages-3d.md)
- [Assets](docs/assets.md), [Android](docs/android.md), [Sauvegardes](docs/backup.md)
- Fiches historiques STEP-001 à STEP-005 dans docs/steps/
