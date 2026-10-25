# État du projet

## Base confirmée

STEP-023 clôturée : 7579504fd4a11b5b6fa1440567c597a92c67fa49, main propre.
Parent : 307e8c6fcb294102638cd55fab388c10352dcb70.
Sauvegarde gambit-arena-20261025-061552-7579504fd4a1.tar.gz restaurée et vérifiée :
bundle complet, git fsck OK ; 260 fichiers identiques au commit et à la livraison validée.
F6, tests manuels et fluidité OK ; retour global, sans mesure chiffrée.
SHA-256 APK : 32a325594643055c00fa01a80a294f559be570c0bbc599bacc47680a47b005a1.
Le swipe Android Gambits/Compétences était explicitement reporté à STEP-024.

## STEP-024 — Validée, commit en attente

GO reçu le 25 octobre 2026. Vague unique progressive, quota et plafond simultané,
fin correcte et correctif FIX-STEP-023-001 inclus, validé avec la v2 par le retour utilisateur global.
Livraison : gambit-arena-complet-step-024-v2.tar.gz.
Version Android 0.1.0-step024, code 23. Validation et empreinte APK v2 reçues.

## Contrôles et limites

Contrôles statiques des références, UID, fichiers préservés et contenu de l'archive.
Godot absent : aucune compilation GDScript ni exécution moteur chez l'assistant.
F6, tests manuels et fluidité confirmés OK ; retour global sans résultat séparé par banc
ni par geste et sans mesure chiffrée. L'équilibrage de la vague reste provisoire.
FIX-STEP-023-001 : v1 en échec au banc tactile ; nouvelle prise en charge livrée en v2.
FIX-STEP-023-001 et FIX-STEP-024-001 inclus dans la v2 validée.

## Prochaine action

Appliquer l’archive de validation, vérifier le diff puis commiter.
Transmettre le hash, le statut Git et la sauvegarde complète créée.
STEP-025 attend clôture et GO : enchaînement de trois vagues et compteurs exacts.

## Retour v1 et correction v2 — 25 octobre 2026

L’utilisateur signale UNASSIGNED_VARIABLE pour chosen (manual_commands.gd:34), et des
échecs dans touch_scroll_tests : swipe depuis carte/espace vide, annulation, clic souris,
puis d’autres erreurs. Aucune réussite complète du banc ou du swipe Android n’est présumée.
La v2 initialise chosen à null et remplace la dépendance au scroll tactile natif par un
routeur local aux zones défilantes. La vague et ses tests sont identiques à la v1.
Appliquer sur STEP-024 non commitée ; ne pas restaurer les fichiers validés auparavant.

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
