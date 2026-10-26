# GRAPHICS-006 validée — 26 octobre 2026

Le propriétaire confirme « Step validée. » pour la livraison GRAPHICS-006,
APK 0.1.0-graphics006 (37), installé sur Galaxy A16.
SHA-256 APK : `fa3303a96264d5d5e4d847854f1fe6ad7c1cfa9adad54d6227677d285a6c9910`.
Validation globale, sans détail supplémentaire ni nouvelle mesure FPS.
Les fichiers non documentaires sont identiques à la livraison validée ; les 36 bancs /
2 320 contrôles déjà réussis ne sont pas relancés pour cette clôture documentaire.
Clôture par un commit unique, puis sauvegarde et restauration vérifiées.
Prochaine étape : GRAPHICS-007, qualification graphique et remplacement des assets ;
attendre GO avant de la démarrer. Les mentions de recette ci-dessous sont historiques.

# GRAPHICS-006 — Foudre descendante avec glow

GO reçu après GRAPHICS-005 validée et clôturée au commit
bf4904d5d56338f7fbc11395c2e6ba24c4a96259. Demande supplémentaire : « un joli effet foudre
qui vient du haut, rapide mais bien visible, avec un effet glow ».
Sauvegarde gambit-arena-20261026-220804-bf4904d5d563.tar.gz,
SHA-256 0b14e3fe05096321b3269429b46147e30d55870fa2da970dfc721c7728ada73d,
restaurée et vérifiée : 506 fichiers. Travail isolé /tmp/gambit-graphics006-work.

## Résultat

Préparation discrète sur Mako et sous la cible, liée à Duck et aux 2 s d'incantation.
Éclair descendant, cœur blanc bleuté, trois branches cyan et glow local diffus. Frappe
0,26 s avec une impulsion secondaire plus faible, anneau et neuf étincelles ; durée totale
0,52 s. Scènes, couleurs, dimensions, origines et durées visuelles sont remplaçables.
Voir ../lightning-presentation.md pour le contrat, les budgets et la recette.

Le succès visuel suit les dégâts réels, à la position capturée de la cible, y compris lors
d'un coup fatal. Les annulations, morts avant résolution, refus/hors portée ou mana
insuffisante ne créent pas de frappe. Manuel et gambits partagent la présentation.
Pause, arrière-plan, menus, fin de combat et Rejouer respectent le cycle de vie existant.

CombatPresenter transmet uniquement des instantanés à un adaptateur LightningPresenter
séparé. Les instantanés couvrent désormais aussi les acteurs dont la vue est absente.
Aucun fichier de logique de combat, ciblage, mana, mouvement ou gambits n'est modifié.
Les GLB, arènes, barres, règles, dégâts, coûts et priorités des animations restent identiques.

## Vérifications

Godot 4.7.2.stable.official.ed1daf0bf, Compatibility.
36 bancs headless / 2 320 contrôles : zéro échec et aucune erreur/avertissement moteur dans
le bilan final. Nouveau banc : 77 contrôles, incluant préparation/cancel/resolve, événement
doublé ou périmé, action complète entre instantanés, position et ciel, glow initial,
maillage borné, pause et expiration, saturation, impact létal après mort, scènes absentes,
dix Rejouer, désactivation, manuel et gambit réels, cible déplacée, coût conservé,
menus/background/reprise, nettoyage, source/cible morte, hors portée et mana insuffisante,
galerie F6 et absence d'orphelins.

Le banc historique GRAPHICS-004 compte maintenant les seuls enfants Death_ pour vérifier
la libération des cadavres : le nouveau module Foudre est un enfant permanent supplémentaire.
Le plafond et la vérification de libération restent identiques. La première campagne avait
signalé cette seule hypothèse de comptage ; ce banc et celui de Foudre ont été réexécutés
avec succès après correction. Les 35 bancs précédents / 2 243 contrôles passent.

Rendu réel en fenêtre inspecté : préparation, frappe au pic et rémanence sur Main et la
galerie. Glow renforcé après un premier rendu trop fin. Fin des captures : zéro orphelin.
Shader final compilé et rendu sans erreur. Les fichiers de gameplay sont identiques au
checkpoint ; aucune nouvelle trace comparative ni campagne FPS n'est revendiquée.

APK exporté/signé : /tmp/graphics-006-debug.apk, 37 397 826 octets.
Version 0.1.0-graphics006, code 37.
SHA-256 fa3303a96264d5d5e4d847854f1fe6ad7c1cfa9adad54d6227677d285a6c9910.
Galaxy A16 : adb install -r réussi (données conservées), lancement à froid réussi,
version/name et code 37 vérifiés par dumpsys package. Après un court Rejouer filmé,
le jeu a été laissé en pause. La capture vidéo du vrai combat a été relue : éclair descendant,
cœur blanc/cyan, glow bleu et impact visibles sur le Galaxy. Cette courte capture ne
constitue pas une campagne de performance. Validation utilisateur de l’aspect et de la
fluidité attendue.

## État

Étape en recette, non commitée et non poussée. Validation utilisateur attendue pour F6,
F5 et Android : aspect de Foudre et glow, cibles vivantes/mortes, soin, priorités, pause,
menus et Rejouer. Ensuite GRAPHICS-007 qualifiera l'ensemble et son remplacement artistique.
