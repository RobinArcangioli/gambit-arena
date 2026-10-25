# État du projet

## Base confirmée

STEP-024 clôturée : 89ae0f64d0b44943e3eef64be5b743d0b94ed1a8, main propre.
Parent : 7579504fd4a11b5b6fa1440567c597a92c67fa49.
Sauvegarde gambit-arena-20261025-152859-89ae0f64d0b4.tar.gz restaurée :
bundle complet, git fsck OK, 277 fichiers identiques au commit et à l’archive validée.
F6, tests manuels et fluidité OK, retour utilisateur global sans mesure chiffrée.
APK STEP-024 : d367d52fb3a3e6857d90c19f333d819a0b6e28d888fcab92c5a38a8dc46fcb09.
Les correctifs FIX-STEP-023-001 et FIX-STEP-024-001 sont inclus dans cette base.

## STEP-025 — Validée, commit en attente

GO reçu après clôture. Trois vagues, progression sans recréer le héros, compteurs
locaux et globaux, archives des vagues terminées. Scène principale WaveSequenceLab.
Livraison : gambit-arena-complet-step-025-v1.tar.gz.
Android 0.1.0-step025, code 24. Aucun SHA d’APK STEP-025 reçu.

## Contrôles et limites

Contrôles statiques des références, UID, différences autorisées et contenu de l’archive.
Nouveau banc wave_sequence_tests : transitions, comptes, pause, mort, suppression,
soin engagé et combat réel avec héros durable de test. Tests livrés, non exécutés ici.
Godot absent : compilation GDScript, F6, tests manuels et APK restent à vérifier.
Aucun nouvel équilibrage, changement d’animation ou de routeur tactile.

## Prochaine action

Appliquer l’archive de validation, vérifier le diff puis commiter STEP-025 avec fix1.
Transmettre le hash, le statut et la sauvegarde complète pour vérification.
STEP-026 attend clôture et nouveau GO.

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
