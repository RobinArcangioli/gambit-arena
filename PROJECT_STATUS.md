# État du projet

## Base confirmée

STEP-007 clôturée : 9b3240c16632e89afa6354cda2eecbe5077e57ba, main propre.
Sauvegarde reçue : gambit-arena-20261022-203734-9b3240c16632.tar.gz.
Bundle cloné et vérifié ; 78 fichiers versionnés identiques aux sources archivées.
Tests manuels Godot et Galaxy A16 validés, banc F6 OK sans échec.
APK STEP-007 : fa80fcb980db86072b1c8237540b7170d845fd266324ea287f4c4b9f90ade610.

## STEP-008 — Validée, commit en attente

Livraison : gambit-arena-complet-step-008-v1.tar.gz.
Apparitions déterministes aux quatre côtés, cadence une seconde de simulation,
poursuite directe du héros et arrêt à 0,8 unité. Vitesse ennemie 0,9 u/s ; héros
mobile 1,2 u/s. Trois scénarios : fixe (4), mobile (4), plafond (20).
Contrôleur GroundMover de STEP-007 réutilisé sans modification, un par acteur.
Retrait/rétablissement de cible, pause, arrêt des apparitions et réinitialisation.
Version Android 0.1.0-step008, code 7. APK installé et validé ; empreinte ci-dessous.

## Vérifications et limites

Contrôles statiques des références, fichiers antérieurs et archive effectués
chez l’assistant. Banc Godot F6 fourni, à exécuter par l’utilisateur.
Godot absent ici : aucune exécution GDScript, mesure de rendu ou export réalisé.
Les ennemis peuvent se chevaucher ; séparation et encerclement sont STEP-009.
Pas de combat, dégâts, vagues, collision physique ou animation 3D définitive.
Le plafond de 20 est une limite technique, pas un résultat de performance mesuré.
Les données de performance TRANSITION-001 ne valident pas cette nouvelle scène.

## Prochaine action

Appliquer l’archive complète de validation, commiter les fichiers et les UID
générés par Godot, confirmer le hash et le statut propre, puis créer et transmettre
la sauvegarde complète. STEP-009 attend cette clôture et un nouveau GO.

## Validation reçue le 22 octobre 2026

Validation explicite de STEP-008 par l’utilisateur : tous les tests manuels OK,
aucune saccade observée, verrouillage et réduction/retour OK. Installation ADB
Success sur Samsung Galaxy A16 SM-A165F, Android 16.
APK testé : step-008-debug.apk ; version 0.1.0-step008, code 7.
SHA-256 : 214b055b0f4af6c095c0827018d0f1a2108bffa603dd97a43a18c80dbfe50f3c.

Aucun chiffre FPS ou temps d’image fourni. Le résultat du banc automatisé F6
n’est pas mentionné séparément dans ce retour ; aucun résultat chiffré ni
« zéro échec » n’est ajouté par déduction. Validation globale utilisateur reçue.
Code testé conservé à l’identique dans cette livraison documentaire.
Statut : Validée, commit en attente.
