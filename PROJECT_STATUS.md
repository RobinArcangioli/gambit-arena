# État du projet

## Base confirmée

STEP-017 clôturée : 5b2bc4d692bd99f29774c19caf4eec3d3d93598f, main propre.
Sauvegarde gambit-arena-20261023-160700-5b2bc4d692bd.tar.gz restaurée et vérifiée :
historique complet, 194 fichiers versionnés identiques à la livraison validée.
F6, tests manuels et fluidité confirmés OK ; retour F6 global sans détail par banc.
SHA-256 APK STEP-017 : ab0c538b8e84c680d4992dc19dbec32bfa0de7f33f94974079981e55e7ace6a8.

## STEP-018 — Validée, commit en attente

GO reçu. Raisons des règles, journal de 64 événements maximum, diagnostic désactivable,
huit cas fixes reproductibles et comparaison de combats avec/sans journal.
Livraison : gambit-arena-complet-step-018-v2.tar.gz.
Version Android 0.1.0-step018, code 17. Validation et empreinte APK reçues.

## Contrôles et limites

Contrôles statiques des références, UID, changements autorisés et contenu de l'archive.
Godot absent : aucune compilation GDScript ni exécution moteur chez l'assistant.
Retour utilisateur : F6 OK, tests manuels OK, fluidité OK.
Retour F6 global, sans résultat séparé pour chacun des cinq bancs demandés.
Aucune mesure nouvelle de performance matérielle. Le journal ne prétend pas enregistrer
tous les impacts ni constituer une sauvegarde de partie. Aucun export de logs ajouté.

## Prochaine action

Appliquer l’archive de validation, vérifier le diff puis commiter.
Transmettre le hash, le statut Git et la sauvegarde complète créée.
STEP-019 attend clôture et GO : trois règles visibles, activables et réordonnables au toucher.

## FIX-STEP-018-001 — 24 octobre 2026

Retour F6 utilisateur sur v1 : avertissement CONFUSABLE_LOCAL_DECLARATION pour
report et échec du contrôle des résidus après dix resets en pause. À ce stade,
STEP-018 restait en attente de validation ; ce retour ne constituait pas un succès global F6.

Le test utilisait World.get_child_count() == 4, mais World possède aussi une caméra,
un WorldEnvironment et un DirectionalLight3D. Le correctif compte les ProxyActor
(et leurs sous-classes) et vérifie leur appartenance aux quatre acteurs courants.
Pause et remise à zéro du journal disposent désormais de contrôles séparés.
Le texte du bilan est renommé summary_text pour éviter le nom report utilisé dans
une boucle du même bloc parent. Aucun composant de gameplay ou diagnostic ne change.

Livraison corrigée : gambit-arena-complet-step-018-v2.tar.gz.
Validation utilisateur reçue le 24 octobre 2026 : F6, tests manuels et fluidité OK.
FIX-STEP-018-001 validé dans ce retour global ; aucun résultat détaillé par banc fourni.
Contrôles statiques effectués ; Godot non exécuté chez l'assistant.

## Validation utilisateur reçue — 24 octobre 2026

STEP-018 explicitement validée : F6 OK, tests manuels OK, fluidité OK.
Retour F6 global, sans résultat séparé pour chacun des cinq bancs demandés.
APK : step-018-debug.apk ; version de la livraison 0.1.0-step018, code 17.
SHA-256 communiqué : aadad09948a5ce8ccf5c078075cce4a86e1e3fb38158fffae6602aa096af96ef.
Aucune mesure chiffrée de performance fournie.

Archive : gambit-arena-complet-step-018-validation.tar.gz.
Code, scènes, profils, tests et configuration identiques à la livraison v2.
Seule la documentation évolue ; aucun lancement Godot chez l’assistant.
Statut : Validée, commit en attente. Hash et sauvegarde à recevoir.
