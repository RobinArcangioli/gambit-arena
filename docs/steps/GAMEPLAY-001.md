# Livraison active : GAMEPLAY-001-fix1

Le propriétaire a signalé l'exclusion d'Anne du soin et le débit de mana trop tôt.
Ces deux points sont corrigés dans [GAMEPLAY-001-fix1](GAMEPLAY-001-fix1.md), APK code 33.
La recette ci-dessous décrit la première livraison (code 32) remplacée par le correctif.

# GAMEPLAY-001 — équipe Anne/Mako, compétences et incantations

GO reçu après validation de GRAPHICS-003. Base clôturée au commit
7956cfce2efcdaf4b95fd3f0631193cb9d442589. Sauvegarde
/home/arkhane/gambit-arena-backups/gambit-arena-20261026-161953-7956cfce2efc.tar.gz,
SHA-256 344fd7c86fbb58ed8e6e28e6b7ac695f83dd14615b6e39cedb32f712b74682cf.
Restauration, clone du bundle, fsck et 445 fichiers identiques au commit vérifiés dans
/tmp/g003-restore-gkya6t6p avant l'étape. Travail isolé dans /tmp/gambit-gameplay001-work.

## Résultat

Anne et Mako combattent ensemble, avec Soin allié et Foudre propres à chaque héros,
attaque de base commune, mana et incantations 1,5/2 s. Gambit Allié PV < 50 %, commandes
manuelles par personnage, trois règles éditables par héros et sauvegarde versionnée.
Barres au-dessus de tous les acteurs : vie rouge, mana bleu, incantation jaune or conditionnelle.
Catalogue d'arènes, pause/reprise Android, fin d'équipe et Rejouer raccordés à Main.
Voir ../party-gameplay.md pour les paramètres retenus et les limites d'équilibrage.

## Vérifications

Godot 4.7.2.stable.official.ed1daf0bf, Compatibility. **31 bancs headless, 1 921 contrôles,
zéro échec et aucun warning/erreur dans la campagne finale.**

- 61 contrôles gameplay : compétences autorisées, coûts uniques, résolution à 1,5/2 s,
  pause, cible morte/remplacée, mana, seuil 50 %, migration/sauvegarde, focus, morts et vagues.
- 52 contrôles Main/HUD : événements tactiles réels et copie souris, commande unique,
  barres, reprise, swipe, éditeur, neuf arènes, douze Rejouer et nettoyage.
- 5 contrôles de séquences visuelles : 900 ticks identiques entre modèles/mannequin/vue
  nulle, avec vrais impacts de Soin/Foudre, aucun nœud orphelin après destruction.
- 28 anciens bancs / 1 803 contrôles : comportements historiques conservés. Les trois
  tests qui visaient l'ancienne composition Main pointent explicitement sa scène de
  référence GRAPHICS-003 ; les nouveaux tests ci-dessus couvrent le Main actuel.

Rendu en fenêtre inspecté : équipe avec deux incantations simultanées, trois barres,
gambits de Mako et édition du soin allié d'Anne. Zéro orphelin après fermeture du banc.
APK exporté/signé, installé et lancé sur Galaxy A16 SM-A165F, Android 16. Version confirmée
0.1.0-gameplay001, code 32. Capture réelle de l'équipe avec mana et barre de Foudre ;
appuis Android sélection Anne/Rejouer/Pause contrôlés, jeu laissé en pause. Pas de nouvelle
campagne FPS ; le bon fonctionnement observé ne constitue pas une qualification exhaustive.

APK : /tmp/gameplay-001-debug.apk — 37 289 284 octets.
SHA-256 : 09f235e53abdb02b765d3c301cd6fa21eade89ea94e3dc36fe3eceace03e7d7a.

Les modèles sources, project.godot et les imports artistiques sont conservés. Le preset
Android passe à GAMEPLAY-001. Le banc historique de performance reste disponible en F6 ;
ses métadonnées précisent qu'il mesure la simulation à un héros, pas la nouvelle équipe.

## Recette utilisateur

F6 scenes/party/party_application.tscn (terrain de référence), F8 puis F5 (Colisée).
Sélectionner les héros, vérifier leurs compétences distinctes et le soin allié d'Anne.
Modifier les gambits, vérifier le seuil strict 50 %, annuler/appliquer, changer d'arène,
mettre en pause et reprendre, tester le retour Android et Rejouer. Observer l'ordre et
la visibilité conditionnelle des barres. Fermer/relancer conserve les règles sauvegardées.

Étape livrée en recette, sans commit/push et sans validation utilisateur à ce stade.
GRAPHICS-004 (attaque/réaction/mort) vient après validation et clôture ; Duck et les effets
restent aux étapes graphiques de soin/Foudre prévues. L'équilibrage de l'équipe est provisoire.

## Validation du propriétaire

« Steps validée. » : GAMEPLAY-001 et son correctif fix1 sont validés.
Les fichiers non documentaires ont été vérifiés identiques à la livraison fix1.
Clôture par un commit unique GAMEPLAY-001, correctif inclus ; sauvegarde à créer et vérifier.
