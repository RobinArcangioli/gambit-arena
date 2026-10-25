# État du projet

## Base confirmée

STEP-022 clôturée : 307e8c6fcb294102638cd55fab388c10352dcb70, main propre.
Parent : 9491d40df3d396cf4f8532d603b4edaaf5d03176.
Sauvegarde gambit-arena-20261025-025458-307e8c6fcb29.tar.gz restaurée et vérifiée :
bundle complet, git fsck OK ; 250 fichiers identiques au commit et à la livraison validée.
F6, tests manuels et fluidité OK ; retour global sans détail par banc ni mesure chiffrée.
SHA-256 APK : 2c3c52c1d17d10049a037dac8a7618ee197f54b6d2099bbf1473e7dc0a77366d.

## STEP-023 — Validée, commit en attente

GO reçu le 25 octobre 2026. Commande manuelle prioritaire, une attente remplaçable,
expiration après trois secondes de jeu, revalidation et exécuteur partagé.
Livraison : gambit-arena-complet-step-023-v1.tar.gz.
Version Android 0.1.0-step023, code 22. Validation et empreinte APK reçues.

## Contrôles et limites

Contrôles statiques des références, UID, fichiers préservés et contenu de l'archive.
Godot absent : aucune compilation GDScript ni exécution moteur chez l'assistant.
Retour utilisateur : F6 OK, tests manuels OK, fluidité OK.
Retour global sans résultat séparé par banc ni mesure chiffrée. Swipe Android défaillant,
explicitement reporté à la prochaine étape par l’utilisateur ; voir correctif prévu ci-dessous.
Décisions : cible verrouillée à l'appui ; pas de nouvelle commande en pause ; attente
prioritaire même indisponible, sans paiement anticipé, puis reprise des gambits.

## Prochaine action

Appliquer l’archive de validation, vérifier le diff puis commiter.
Transmettre le hash, le statut Git et la sauvegarde complète créée.
STEP-024 attend clôture et GO : vague progressive et plafond simultané.

## Validation utilisateur reçue — 25 octobre 2026

STEP-023 explicitement validée : F6 OK, tests manuels OK, fluidité OK.
Retour F6 global, sans résultat séparé pour chacun des onze bancs demandés.
APK : step-023-debug.apk ; version de la livraison 0.1.0-step023, code 22.
SHA-256 communiqué : 32a325594643055c00fa01a80a294f559be570c0bbc599bacc47680a47b005a1.
Aucune mesure chiffrée de performance fournie.
Anomalie de swipe Android signalée avec demande de correction à l’étape suivante.
Cette validation ne vaut donc pas réussite du défilement au doigt sur téléphone.

Archive : gambit-arena-complet-step-023-validation.tar.gz.
Code, scènes, profils, tests et configuration identiques à la livraison v1.
Seule la documentation évolue ; aucun lancement Godot chez l’assistant.
Statut : Validée, commit en attente. Hash et sauvegarde à recevoir.

## FIX-STEP-023-001 — Prévu pendant STEP-024

Signalement utilisateur du 25 octobre 2026 : les zones de défilement Gambits et
Compétences fonctionnent à la molette, mais pas par glissement du doigt sur téléphone.
L’utilisateur valide STEP-023 et demande explicitement ce correctif à la prochaine étape.
Statut : à faire, aucune correction de code dans cette archive. Cause à diagnostiquer.

À intégrer au périmètre de STEP-024 : rétablir le swipe dans les deux listes, jusqu’aux
dernières règles/cartes/détails. Vérifier les gestes commencés sur les boutons et sur
les espaces libres ; un glissement ne doit ni commander une compétence, ni ouvrir ou
modifier un gambit. Conserver les appuis courts, la molette, les zones sûres et la pause.
Ajouter une régression ciblée et faire valider le geste sur le téléphone Android.
