# STEP-025-fix1 — Conserver la cible vivante à portée

Statut : Validée, commit en attente. Correctif demandé immédiatement après STEP-025.
Base Git : 89ae0f6 ; s’applique par-dessus STEP-025 non commitée, sans git restore.

## Cause et comportement

Controller.plan recalculait le plus proche à chaque évaluation (10 Hz hors action active).
Le verrou de l’exécuteur ne durait qu’une action. Un autre ennemi devenu plus proche pouvait
donc remplacer la cible vivante entre deux attaques. ManualCommands choisissait aussi
le plus proche indépendamment du contrôleur.

La cible offensive est maintenant commune aux gambits et commandes manuelles.
Elle reste sélectionnée tant qu’elle est vivante, présente dans le combat et à une distance
inférieure ou égale à 1 unité (portée actuelle). Un ennemi plus proche ne la remplace pas.
Un soin sur soi conserve cette mémoire ; le retour à une attaque utilise la même cible.
Une condition de gambit non satisfaite n’autorise pas à sélectionner un autre ennemi :
les règles suivantes sont évaluées sur la cible retenue, ou le héros attend sans action.
Cible morte ou hors portée : sélection habituelle à nouveau autorisée. Suppression de
l’acteur ou remplacement de son état invalident aussi sa référence, par sécurité de cycle de vie.
Aucune action engagée n’est interrompue pour recalculer la cible ; les validations d’impact
et annulations par mort restent celles de l’exécuteur existant.

## Installation

Fermer Godot, conserver les modifications STEP-025 en place, puis :

```bash
tar -xzf ~/Downloads/gambit-arena-complet-step-025-fix1.tar.gz -C ~ &&
cd ~/gambit-arena &&
git diff --check
```

Archive complète sans .git/.godot ; bundle historique séparé au commit 89ae0f6.
Pas de restauration Git, pas de commit avant validation du correctif.

## F6

F6 puis F8 entre chaque scène dans scenes/tests :

1. target_lock_tests.tscn (nouveau)
2. gambit_controller_tests.tscn
3. manual_commands_tests.tscn
4. wave_sequence_tests.tscn
5. wave_schedule_tests.tscn
6. attack_stationary_tests.tscn
7. touch_scroll_tests.tscn

Attendu : OK, zéro échec et aucun nouvel avertissement. Les autres bancs de STEP-025
restent disponibles. Godot absent chez l’assistant : aucune compilation/exécution F6 ici.
Le nouveau banc exerce le vrai contrôleur, l’exécuteur et la file manuelle : ennemi plus
proche après attaque, borne de portée, soin, édition des règles, condition non satisfaite,
commande manuelle, sortie de portée, mort et disparition d’un acteur.

## Recette PC et Android

- Plusieurs ennemis proches : tant que la cible attaquée vit et reste à portée, le héros
  continue de l’attaquer, même si une autre devient plus proche.
- Soin automatique ou manuel, puis reprise des attaques : même cible offensive si valide.
- Spéciale manuelle : même cible que l’attaque automatique si elle vit et reste à portée.
- À sa mort, sélection d’une nouvelle cible ; hors portée, nouveau choix autorisé.
- Pause/reprise et changement des gambits : aucun changement parasite de cible valide.
- Rejouer et passage à une nouvelle vague : aucune référence à un ancien ennemi.
- Toujours trois vagues, compteurs cohérents, swipe fonctionnel, attaque immobile à portée.

Exporter Android Debug vers ~/gambit-arena-builds/step-025-fix1-debug.apk.
Version 0.1.0-step025-fix1, code 25. Puis :

```bash
~/Android/Sdk/platform-tools/adb devices -l &&
~/Android/Sdk/platform-tools/adb -d install -r ~/gambit-arena-builds/step-025-fix1-debug.apk &&
sha256sum ~/gambit-arena-builds/step-025-fix1-debug.apk
```

Transmettre F6, tests manuels PC/Android, fluidité et le nouveau SHA-256.
Le SHA de STEP-025 avant correctif ne valide pas cet APK.

## Validation finale — 25 octobre 2026

STEP-025 avec STEP-025-fix1 explicitement validée par l’utilisateur :
F6 OK, tests manuels OK, fluidité OK. Aucune nouvelle réserve signalée.
Retour global ; aucun résultat séparé par banc ou mesure chiffrée fourni.
APK : step-025-fix1-debug.apk ; version 0.1.0-step025-fix1, code 25.
SHA-256 : a05863ca35183215d53c270652a0a1927da4e74c8547fcf32112f6a42e97544a.
La validation précédente et son SHA décrivent STEP-025 avant correction du ciblage.

Statut actuel : Validée, commit en attente. Archive de validation :
gambit-arena-complet-step-025-validation.tar.gz. Seule la documentation change
par rapport à fix1 ; code, scènes, tests et configuration strictement identiques.
Aucun lancement Godot chez l’assistant. Les instructions de recette et mentions
antérieures d’attente décrivent les livraisons précédentes ; ne pas les relancer
pour cette seule mise à jour documentaire.
Prochaine action : commit, statut propre et sauvegarde complète à transmettre.
STEP-026 attend cette clôture et un nouveau GO.
