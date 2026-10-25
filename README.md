# Gambit Arena — STEP-025

STEP-024 clôturée au commit 89ae0f6 ; sauvegarde vérifiée, 277 fichiers conformes.
STEP-025 : en attente de validation. F5 ouvre trois vagues progressives de 12 ennemis,
avec au plus 6 vivants. Le mode Soin conserve son héros blessé ; Charge propose trois
vagues de 24 ennemis, au plus 20 vivants. Les profils et animations sont inchangés.

Une vague suivante commence seulement après toutes les apparitions et la mort du dernier
ennemi. Son premier ennemi attend une seconde de jeu. Le héros conserve PV, position,
ressource, cooldowns et action engagée. Il n’y a ni soin gratuit ni remise à zéro entre vagues.
La victoire exige les trois vagues complètes. La mort du héros reste prioritaire.
L’équilibrage reste provisoire : aucune victoire automatique du profil normal n’est promise.

Le HUD affiche la vague, les vivants et les totaux. Les détails des compétences donnent
les compteurs locaux et cumulés. Rejouer revient à la vague 1 en conservant les gambits
et l’état de pause. Le swipe tactile validé en STEP-024 est inchangé.

F6 : wave_sequence_tests, wave_schedule_tests, touch_scroll_tests, puis les bancs de
régression de la [recette](docs/steps/STEP-025.md). F8 entre chaque banc.
Godot absent chez l’assistant : contrôles statiques uniquement, aucun F6 exécuté ici.

- [Trois vagues](docs/wave-sequence.md)
- [Architecture](ARCHITECTURE.md), [état](PROJECT_STATUS.md), [roadmap](ROADMAP.md)
- [Android](docs/android.md), [sauvegarde](docs/backup.md)

Version Android 0.1.0-step025, code 24. Export : ../gambit-arena-builds/step-025-debug.apk.
Ne pas commiter avant validation utilisateur.

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
