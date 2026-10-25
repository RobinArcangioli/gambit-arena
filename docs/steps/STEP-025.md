# STEP-025 — Enchaîner trois vagues et garantir les compteurs

Statut : Validée, commit en attente. Base clôturée 89ae0f6, GO reçu le 25 octobre 2026.
Archive : gambit-arena-complet-step-025-v1.tar.gz. Version 0.1.0-step025, code 24.

## Périmètre et décisions

Trois vagues de 12, plafond 6 ; scénario Charge : trois fois 24, plafond 20.
Même héros et mêmes profils entre vagues. Pas de soin gratuit, pause intermédiaire
supplémentaire ou modification des animations. Les PV, cooldowns, ressource, action
engagée et temps de jeu se poursuivent. Première arrivée à une seconde par vague.
Voir ../wave-sequence.md pour les compteurs et conditions exactes.
Les anciens laboratoires et tests restent utilisables. Défaite/replay sont vérifiés
sur les transitions ; la campagne des dix redémarrages appartient à STEP-026.

## Fichiers

CombatSimulation : transitions et comptes. Nouveau WaveSequenceLab, scène et banc associé.
Main et export Android actualisés. Documentation actuelle actualisée.
WaveSchedule, routeur tactile, exécuteurs, animations, profils et project.godot inchangés.

## Installation

Fermer Godot. Depuis la base propre 89ae0f6 :

```bash
cd ~/gambit-arena &&
git status --short --branch &&
git log -1 --format="%h %s"
```

Après vérification de la base et de l’absence de modifications :

```bash
tar -xzf ~/Downloads/gambit-arena-complet-step-025-v1.tar.gz -C ~ &&
cd ~/gambit-arena &&
git diff --check
```

L’archive n’écrase pas .git et ne contient pas .godot. Le bundle séparé conserve
l’historique jusqu’à 89ae0f6 ; STEP-025 n’est pas encore commitée.

## F6 — tests livrés, non exécutés chez l’assistant

Ouvrir chaque scène dans scenes/tests ; F6 puis F8 avant la suivante :

1. wave_sequence_tests.tscn
2. wave_schedule_tests.tscn
3. touch_scroll_tests.tscn
4. manual_commands_tests.tscn
5. skill_slots_tests.tscn
6. portrait_hud_tests.tscn
7. gambit_fields_tests.tscn
8. attack_stationary_tests.tscn
9. gambit_editor_tests.tscn
10. gambit_diagnostics_tests.tscn
11. gambit_controller_tests.tscn
12. gambit_tests.tscn
13. lifecycle_tests.tscn
14. combat_simulation_tests.tscn

Attendu : OK, zéro échec, aucun nouvel avertissement. Le banc de séquence simule du
combat accéléré : attendre son bilan. Son héros durable est propre au test.

## Recette PC et Android

- F5 : vague 1/3, arrivés 0/36, pas de victoire dans l’arène initialement vide.
- Laisser combattre et utiliser soin/spéciale au besoin. À chaque fin complète :
  vague suivante, aucune remise à zéro des PV/ressource, délai avant nouvelle arrivée.
- À 2/3 puis 3/3, les arrivés/vaincus cumulés continuent. Les détails affichent les
  compteurs locaux. Victoire seulement après les 36 morts, zéro vivant, aucune vague 4.
- Si le héros meurt avant cela : DEFAITE, aucune apparition ultérieure ; signaler
  séparément si la difficulté empêche de vérifier manuellement les trois vagues.
- Pause près d’une transition puis reprise : aucun compteur ni délai n’avance en pause.
  Arrière-plan Android puis retour : reste en pause, sans rafale d’apparitions.
- Rejouer : vague 1, compteurs nuls, gambits conservés ; pause conservée si active.
- Mode Soin : héros blessé, 36 au total. Charge : 72 au total, jamais plus de 20 vivants.
- Swipe Gambits/Compétences et formulaire depuis bouton/espace libre : défilement sans
  commande ni édition parasite. Appui court : une action. Molette/clic PC inchangés.
- Attaque à portée : pas de nouveau mouvement de jambes ou déplacement du héros.

Équilibrage provisoire, aucune performance mesurée chez l’assistant.

## APK

Exporter Android Debug vers ~/gambit-arena-builds/step-025-debug.apk, puis :

```bash
~/Android/Sdk/platform-tools/adb devices -l &&
~/Android/Sdk/platform-tools/adb -d install -r ~/gambit-arena-builds/step-025-debug.apk &&
sha256sum ~/gambit-arena-builds/step-025-debug.apk
```

Transmettre F6, tests manuels PC/Android, fluidité et le nouveau SHA-256.
Ne pas réutiliser l’APK STEP-024. Ne pas commiter avant validation.
Commit prévu après documentation de la validation :
feat: [STEP-025] enchainer trois vagues et garantir les compteurs
Puis statut propre, sauvegarde complète et vérification avant GO STEP-026.

## STEP-025-fix1 — Cible offensive persistante

Retour utilisateur : F6 OK, tests manuels OK, fluidité OK ; STEP-025 déclarée validée.
SHA-256 de cette livraison avant correctif : 660feca8138818606bc2e9e2315019b83b05f7fd86e704362579b3c080f46329.
Réserve signalée simultanément : changement de cible avant sa mort, correction immédiate
demandée. La cible doit rester la même tant qu’elle est vivante et à portée.
STEP-025-fix1 : validée, commit en attente ; nouveau SHA reçu ci-dessous.
Cette section remplace les instructions de livraison précédentes : appliquer
gambit-arena-complet-step-025-fix1.tar.gz sur STEP-025 non commitée.
Recette : docs/steps/STEP-025-fix1.md. Export step-025-fix1-debug.apk,
version 0.1.0-step025-fix1, code 25. Commit après validation du correctif.

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
