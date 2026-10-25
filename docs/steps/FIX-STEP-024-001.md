# FIX-STEP-024-001 — Routeur tactile et initialisation du ciblage

Statut : inclus dans STEP-024 v2 validée, commit en attente.
Date : 25 octobre 2026. Base commitée 7579504 ; correctif appliqué sur STEP-024 v1.

## Signalement

UNASSIGNED_VARIABLE dans ManualCommands.nearest (chosen lu avant initialisation).
Échecs de touch_scroll_tests : swipe sur carte, espace libre, annulation, clic souris,
et autres erreurs signalées. STEP-024 v1 non validée.

## Correction

chosen est initialisé explicitement à null, sans changer le choix de cible.
TouchScrollRouter gère les gestes dans les zones défilantes actives avant le GUI natif,
avec seuil de 12 pixels, scroll borné et appui court unique au relâchement. Un swipe,
une annulation, un second doigt ou un reset empêchent toute activation du bouton.
Le flux souris émulé est consommé ; souris physique et molette sont conservées.
La vague, le combat, les animations et le correctif d’immobilité à portée ne changent pas.

## Livraison et recette

Archive complète gambit-arena-complet-step-024-v2.tar.gz. Fermer Godot, extraire dans ~
sur le projet STEP-024 non commité, puis git diff --check. Aucun git restore requis.
Godot absent chez l’assistant : contrôle statique seulement, pas de succès F6 présumé.

F6 touch_scroll_tests, wave_schedule_tests et manual_commands_tests, puis les dix autres
bancs de STEP-024. Aucun échec ni avertissement attendu. Confirmer les vrais swipes sur
Android, l’absence de commandes/modifications parasites, les appuis courts et la molette.
Réexporter step-024-debug.apk (version 0.1.0-step024, code 23 inchangés), réinstaller et
communiquer le nouveau SHA-256. Commit seulement après validation explicite.

## Validation utilisateur reçue — 25 octobre 2026

STEP-024 v2 explicitement validée : F6 OK, tests manuels OK, fluidité OK.
FIX-STEP-023-001 et FIX-STEP-024-001 inclus dans cette version validée.
Retour global, sans résultat séparé pour chacun des treize bancs ni chaque geste tactile.
Aucune mesure chiffrée de performance fournie. Aucune réserve nouvelle signalée.
APK : step-024-debug.apk ; version 0.1.0-step024, code 23.
SHA-256 communiqué : d367d52fb3a3e6857d90c19f333d819a0b6e28d888fcab92c5a38a8dc46fcb09.

Archive : gambit-arena-complet-step-024-validation.tar.gz.
Code, scènes, profils, tests et configuration identiques à la livraison v2.
Seule la documentation évolue ; aucun lancement Godot chez l’assistant.
Statut : Validée, commit en attente. Hash et sauvegarde à recevoir.
Les mentions d’attente précédentes décrivent les recettes et livraisons antérieures.
