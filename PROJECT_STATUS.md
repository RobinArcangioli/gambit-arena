# État du projet

## Base confirmée

STEP-014 clôturée : implémentation 5c39ac2, documentation de validation 4f4244c.
HEAD : 4f4244c24887cbf938e46bc9dd56507784d8c2bd, main propre.
Sauvegarde gambit-arena-20261023-075612-4f4244c24887.tar.gz restaurée et vérifiée :
historique complet, 160 fichiers versionnés identiques, dépôt propre.
Retour utilisateur : F6 OK, tests manuels OK, fluidité OK, étape validée.
Le retour F6 est global, sans détail par banc ; aucune mesure chiffrée de performance.
SHA-256 APK STEP-014 : ac06b695682b55268e741cffbaa1c3316022feb1daf10e30a7851e9fc83417d8.

## STEP-015 — Validée, commit en attente

GO reçu. Horloge commune, garde de pause aux entrées de l'exécuteur et à l'impact,
annulation synchrone à la mort/sortie d'arbre, arrêt terminal et reset conservant
la pause. Laboratoire dédié et banc cycle de vie, non-régression des bancs partagés.
Livraison : gambit-arena-complet-step-015-v1.tar.gz.
Version Android 0.1.0-step015, code 14. Validation et empreinte APK reçues.

## Contrôles et limites

Contrôle statique des références, UID, changements autorisés et contenu de l'archive.
Godot absent : aucune compilation GDScript ni exécution moteur chez l'assistant.
Retour utilisateur : F6 OK, tests manuels OK, fluidité OK.
Retour F6 global, sans résultat séparé pour chacun des cinq bancs demandés.
Anciennes scènes conservées. Pas de gambits, ni d'animations finales ajoutées.
La pause de ce prototype n'utilise pas SceneTree.paused : l'interface reste utilisable.

## Prochaine action

Appliquer l’archive de validation, vérifier le diff puis commiter.
Transmettre le hash, le statut Git et la sauvegarde complète créée.
STEP-016 : évaluateur déterministe de gambits sans effet de bord, après clôture et GO.

## Validation utilisateur reçue — 23 octobre 2026

STEP-015 explicitement validée : F6 OK, tests manuels OK, fluidité OK.
Retour F6 global, sans résultat séparé pour chacun des cinq bancs demandés.
APK : step-015-debug.apk ; version de la livraison 0.1.0-step015, code 14.
SHA-256 communiqué : 90f39d41ad59a995179614e55bda1b9f41c96e0ca51081918b088cd12c137d5b.
Aucune mesure chiffrée de performance fournie.

Archive : gambit-arena-complet-step-015-validation.tar.gz.
Code, scènes, profils, tests et configuration identiques à la livraison v1.
Seule la documentation évolue ; aucun lancement Godot chez l’assistant.
Statut : Validée, commit en attente. Hash et sauvegarde à recevoir.
