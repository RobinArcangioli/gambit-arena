# FIX-STEP-023-001 — Défilement au doigt sur Android

Statut : inclus dans STEP-024 v2 validée, commit en attente.
Signalement reçu le 25 octobre 2026 sur STEP-023 : molette fonctionnelle, swipe inopérant
dans les listes Gambits et Compétences. STEP-023 validée avec correction reportée sur demande.

## Retours et correction v2

La v1 modifiait les filtres STOP en PASS, avec seuil de scroll natif à 12 pixels.
Les premiers essais F6 de l’utilisateur ont échoué : la propagation seule n'a pas
produit le défilement attendu. Cette première hypothèse n'est pas une correction validée.

La v2 utilise TouchScrollRouter, limité aux zones défilantes actives. Les touches sont
capturées avant les boutons ; le déplacement du doigt règle le scroll directement.
Un appui court active une seule fois au relâchement, un swipe annule définitivement
l'appui. Le flux souris émulé est consommé pour éviter une seconde activation.
La souris physique et la molette restent sur leur chemin normal. Aucun changement
au réglage d'émulation tactile de project.godot. Pas d'inertie dans cette correction.

## Vérification

scenes/tests/touch_scroll_tests.tscn injecte les gestes dans le viewport réel, y compris
leur copie souris. Contrôles : swipe sur carte/espace/bouton, appuis courts, petit tremblement,
retour au point initial, annulation, second doigt, molette, formulaire, pause, dernier
détail accessible, reset et arrière-plan pendant un appui. Godot non exécuté ici.

Sur téléphone, faire défiler les deux listes dans les deux sens, depuis boutons et
espaces. Atteindre les dernières lignes sans action involontaire. Confirmer appuis courts,
formulaire, pause, reprise d'arrière-plan et molette PC. Voir FIX-STEP-024-001 pour la v2.

## Références officielles consultées

- https://docs.godotengine.org/en/stable/classes/class_control.html
- https://docs.godotengine.org/en/stable/classes/class_scrollcontainer.html
- https://github.com/godotengine/godot/blob/master/scene/gui/base_button.cpp
- https://docs.godotengine.org/en/stable/classes/class_viewport.html

La version du moteur sur l'appareil et les tests F6 restent l'autorité de validation.

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
