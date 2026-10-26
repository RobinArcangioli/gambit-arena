# GRAPHICS-005 validée — 26 octobre 2026

Le propriétaire confirme « Step validée. » pour la livraison GRAPHICS-005,
APK 0.1.0-graphics005 (36), installé sur Galaxy A16.
SHA-256 APK : `060c79e8cedc6236d7d4ea33a7df8ec7245b9c938b94976fc9362f01251cc8da`.
Validation globale, sans détail supplémentaire ni nouvelle mesure FPS.
Les fichiers non documentaires sont identiques à la livraison validée ; les 35 bancs /
2 243 contrôles déjà réussis ne sont pas relancés pour cette clôture documentaire.
Clôture par un commit unique, puis sauvegarde et restauration vérifiées.
Prochaine étape : GRAPHICS-006, effet Foudre de Mako ; attendre GO avant de la démarrer.
Les mentions de recette ci-dessous décrivent les états antérieurs.

# GRAPHICS-005 — effet visuel du soin d'Anne

GO reçu après GRAPHICS-004/fix1 validée et clôturée au commit
074f971db7e9dd8a613b1e2a762140f392804ef0.
Sauvegarde : gambit-arena-20261026-200257-074f971db7e9.tar.gz,
SHA-256 ac2eb0e0c895a15a407cf24e5e20e01b3ad21158765e6fecb9ab21d4379f4a74.
Restauration et 492 fichiers vérifiés. Travail isolé : /tmp/gambit-graphics005-work.

## Résultat

Duck accompagne déjà l'incantation. Un halo vert local, quatre signes « + » et la valeur
réellement soignée apparaissent uniquement après une résolution positive. Le même chemin
sert le gambit et la commande manuelle, sur Anne elle-même comme sur Mako.
La cible vivante entraîne l'effet ; origine configurable par personnage. Scène, couleur,
rayon, durée 0,85 s et hauteur du nombre dans un profil graphique remplaçable.
Voir ../heal-presentation.md pour le contrat et la recette F6/F5.

Plafond huit effets, déduplication, ancienne partie refusée, nettoyage à la mort/replay,
au changement de scène et à la désactivation. Pause, retour d'arrière-plan et menus respectés.
Aucun fichier de logique de combat, de ciblage, de mana, de déplacement, de barres ou de
règles n'est modifié. GLB, arènes et priorités des animations existantes sont conservés.

## Vérifications

Godot 4.7.2.stable.official.ed1daf0bf, Compatibility.
35 bancs headless / 2 243 contrôles, zéro échec et aucune erreur/avertissement moteur.
Le nouveau banc comporte 89 contrôles : résolution positive et valeur tronquée, événements
doublés/périmés, préparation sans réussite, zéro soin, pause et progression, limite d'effets,
mort, scène absente, désactivation, dix nouvelles parties, manuel/gambit et soi/allié,
background/reprise explicite et premier tick rejeté, fermeture de menu, morts de source/cible,
PV pleins, hors portée, annulation, origine par modèle et suivi, galerie F6 et zéro orphelin.
Les 34 bancs précédents / 2 154 contrôles passent également.

Rendu en fenêtre inspecté sur Main : soin sur Anne et sur Mako, +30 et halo lisibles au-dessus
et sous les modèles ; galerie F6 inspectée. Fin des captures : zéro orphelin. Les traces de
jeu ne sont pas revendiquées comme remesurées : les fichiers de gameplay sont identiques
au commit de base, et les bancs existants passent. Aucune nouvelle campagne FPS.

APK exporté/signé : /tmp/graphics-005-debug.apk, 37 362 418 octets.
Version 0.1.0-graphics005, code 36.
SHA-256 060c79e8cedc6236d7d4ea33a7df8ec7245b9c938b94976fc9362f01251cc8da.
Après reconnexion du Galaxy A16 : installation adb install -r réussie, données conservées,
lancement à froid réussi ; version/name et code 36 vérifiés par dumpsys package.
La validation visuelle utilisateur de cette version reste attendue.

## État

Étape en recette, non commitée et non poussée. Validation utilisateur attendue sur F6,
F5 et Android : effet au soin réel, auto-soin et Mako, pause/menus/reprise et Rejouer.
Après clôture, GRAPHICS-006 raccordera l'effet Foudre de Mako.
