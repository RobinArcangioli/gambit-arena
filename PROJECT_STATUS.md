# État du projet

## Base confirmée

STEP-006 clôturée : 1cc7f05947322fb34049f2fc12a8de37756d872b, main propre.
Sauvegarde reçue : gambit-arena-20261022-160117-1cc7f0594732.tar.gz.
Bundle cloné, HEAD confirmé ; 68 fichiers identiques aux sources archivées.
Arène, cinq placements, taille 48 px, réservations et boutons validés par l’utilisateur.
APK STEP-006 : 133d5096305e9278d9262c55dd5bc4ea8f067a571e618017fc4976866833c125.

## STEP-007 — Validée, commit en attente

Livraison testée : gambit-arena-complet-step-007-v1.tar.gz.
Livraison de validation : gambit-arena-complet-step-007-validation.tar.gz.
Déplacement automatique au sol, vitesse 1,2 unité/s, arrêt à 0,8 unité de la cible.
Le contrôleur reçoit une cible ; la source temporaire de diagnostic la choisit.
Scénarios : A puis B puis aucune, axes, cible hors arène, disparition de cible.
Boutons de sélection de cible réservés au diagnostic, pas de déplacement manuel.
Arène et mannequins 48 px réutilisés ; les six cases de compétences restent inactives.
Version Android 0.1.0-step007, code 6. APK exporté et installé avec succès
par l’utilisateur ; empreinte consignée ci-dessous.

## Vérifications et limites

Références, contrat numérique et géométrie du portrait contrôlés par l’assistant.
Le banc F6 exécutant le vrai GroundMover est confirmé OK, zéro échec par l’utilisateur.
Godot indisponible ici : aucun test GDScript, lancement, rendu ni export exécuté.
Le succès des précédents APK ne remplace pas les tests de cette nouvelle logique.
Pas de dégâts, physique de collision, évitement, séparation ou poursuite ennemie.
Les cibles sont des mannequins de diagnostic. Le réglage 0,8 n’est pas encore
une portée de combat. Modèles/animations 3D définitifs toujours hors livraison.

## Prochaine action

Appliquer la livraison de validation, vérifier le diff préparé et commiter
STEP-007, y compris les métadonnées Godot générées. Confirmer le hash et le
statut propre puis créer et transmettre la sauvegarde complète.
STEP-008 attend la clôture et un nouveau GO.

## Résultats reçus

Validation explicite utilisateur reçue le 22 octobre 2026.
- Banc de tests Godot F6 : OK, zéro échec, confirmé par l’utilisateur.
- Approche A puis B puis arrêt sans cible : OK.
- Changement de cible en mouvement sans téléportation et annulation : OK.
- Vitesse nominale proche de 1,20 u/s, hors dernier pas et bordure : OK.
- Respect de la limite avec une cible extérieure : OK.
- Disparition de A après 0,75 s, arrêt sans erreur : OK.
- Pause : position et pose figées, reprise sans saut : OK.
- ADB : téléphone en état device, installation Success sur Galaxy A16.

APK testé : step-007-debug.apk. SHA-256 :

```text
fa80fcb980db86072b1c8237540b7170d845fd266324ea287f4c4b9f90ade610
```

Ces résultats proviennent de l’utilisateur ; l’assistant n’a pas exécuté Godot.
Aucune mesure de performance ni capture n’a été transmise pour cette étape.
Les essais spécifiques accueil/verrouillage ne sont pas détaillés séparément
dans ce retour ; la validation globale est reçue sans inventer un relevé par test.
