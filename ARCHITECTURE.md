# Architecture réelle — STEP-007 validée, commit en attente

## Composition

Main conserve son UID et instance scenes/movement/movement_lab.tscn.
Cette scène hérite de scenes/arena/arena.tscn ; son script dérive du script d’arène.
Le parent continue de gérer caméra, éclairage, zone sûre, fond 2D, six réservations
et pause. Le diagnostic de déplacement ajoute une cible B, quatre boutons, des
étiquettes A/B et un état de mouvement. L’arène statique reste lançable avec F6.
Les nouveaux boutons sont dans l’espace libre au-dessus du terrain ; ils ne
réutilisent pas les six emplacements de compétences.

| Source | Responsabilité |
|---|---|
| scripts/movement/ground_mover.gd | Exécute une cible fournie, calcule mouvement/arrêt/limite |
| scripts/movement/movement_lab.gd | Source temporaire d’intentions, scénarios et présentation |
| scenes/movement/movement_lab.tscn | Scène principale dérivée de l’arène |
| tests/test_ground_mover.gd | Tests du vrai contrôleur au sein d’un SceneTree |
| scenes/tests/ground_mover_tests.tscn | Point d’entrée F6 des tests |
| scripts/arena/arena_bounds.gd | Limites au sol, réutilisées sans modification |
| scripts/hybrid/proxy_actor.gd | Présentation 3D et marche procédurale, inchangées |

## Contrat de déplacement

GroundMover est un RefCounted par acteur : position au sol, vitesse effective,
orientation, cible Node3D et état. Il ne possède ni boucle de traitement, ni
recherche de cible, ni accès au HUD. Sa méthode step(delta) est appelée par
le laboratoire dans _physics_process quand la pause locale est inactive.
La source de diagnostic fournit la cible via set_target ou clear_target.
À terme, un décideur remplacera cette source sans donner la sélection au mover.

Les coordonnées sont locales au même World3D, qui reste à l’identité : Vector2(x,z)
pour les pieds, y=0 en 3D. Le contrôleur relit la position de la cible à chaque
pas. Les cibles doivent appartenir au même repère ; transformer leurs positions
sera nécessaire si leur hiérarchie change. Le déplacement au sol est normalisé,
limité à speed×delta et à la distance restante avant stopping_distance, puis
borné par ArenaBounds. Les quatre états sont NO_TARGET, MOVING, ARRIVED et BLOCKED.
Voir docs/movement.md pour le contrat détaillé et les cas limites.

Un Node3D détruit, en attente de suppression ou sorti de l’arbre est rejeté
avant tout accès à sa position. Aucune ancienne destination n’est conservée
pour poursuivre un trajet quand la cible disparaît. Une cible hors arène reste
une intention hors domaine : le héros s’arrête à sa limite sans prétendre être arrivé.

## Présentation et pause

Le laboratoire applique la position à la racine du héros et sa vitesse/orientation
au mannequin. La pose de marche ne décide ni du déplacement ni d’un dégât.
L’horloge de marche avance uniquement lorsque le héros se déplace. À l’arrêt,
la pose devient immobile, en conservant la dernière orientation utile.
La pause suspend le temps de scénario et les pas du mover ; elle bloque aussi
les choix de cible. Rejouer remet volontairement le scénario à zéro, même en pause.
Repères reste utilisable. Le retour d’arrière-plan ne reprend pas automatiquement.

La source A→B→aucune attend une arrivée puis 0,5 seconde avant de changer la cible.
Les commandes A/B/Aucune interrompent cette séquence de test. Le scénario
Disparition retire réellement A de l’arbre par queue_free après 0,75 seconde ;
le mover doit détecter cette invalidité lui-même.

## Configuration et limites

Rendu hybride et layout STEP-006 conservés : caméra orthographique 2:1, fond 2D,
SubViewport 3D transparent, mêmes mannequins à 48 px, Compatibility Android.
APK ARM64 standard, Gradle désactivé, version 0.1.0-step007 code 6.
SDK/JDK et signature restent locaux. Aucun export ou test Godot fait ici.

Pas de collision, évitement, séparation, attaque, ennemi poursuivant ou gambit.
La distance d’arrêt est un réglage d’approche de diagnostic, pas une portée de combat.
La vitesse au sol est constante hors arrivée/bordure ; une direction projetée
peut sembler plus rapide qu’une autre à l’écran. Les vrais modèles et animations
restent à produire séparément. La phase actuelle conserve le diagnostic visuel validé.

## Validation reçue

Le 22 octobre 2026, l’utilisateur confirme le banc F6 sans échec et valide
approche A/B, retargetage, annulation, vitesse au sol, bordure, disparition et
pause/reprise. APK installé avec succès. Aucun changement fonctionnel n’est
introduit dans la livraison de validation ; l’empreinte est dans la fiche STEP-007.
