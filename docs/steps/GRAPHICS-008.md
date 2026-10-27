# GRAPHICS-008 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour les disques d'ombre indiquant le gabarit.
APK 0.1.0-graphics008 (42), SHA-256
`3cb968ff960280aece6b1636edd06f34fd33120eb7c429a89f5806011f11d8cc`.
Validation globale, sans détail supplémentaire ni nouvelle mesure de performance.
Code, scènes, assets, configuration et APK identiques à la livraison validée ; seuls les
documents sont actualisés. Les 40 bancs / 2 541 contrôles déjà réussis ne sont pas relancés.
Clôture par un commit unique puis sauvegarde restaurée/vérifiée. GAMEPLAY-003 reste annulée :
tailles et contournements conservés. STEP-029 attend un nouveau GO, puis viendra STEP-030.
Les mentions de recette et de réduction des gabarits suivantes sont historiques.

# GRAPHICS-008 — ombres indiquant le gabarit au sol

Demande du propriétaire du 27 octobre 2026 : annuler complètement GAMEPLAY-003 ; les tailles
et contournements conviennent. Ajouter des disques d'ombre sobres, transparents, sous tous
les personnages, dimensionnés selon l'emprise au sol.

Base : GAMEPLAY-002 clôturée, commit d3ff7df9125bf3acd9511b6c10d51a4a531739f7,
parent 440829bfca597654a520897f488cf97ea24fb1f4.
Sauvegarde gambit-arena-20261027-005100-d3ff7df9125b.tar.gz, SHA-256
7550e5378e4799f93f7ad2aab09434ea0090319a1d27ad6384d12ccda23f392e,
restaurée/vérifiée, 568 fichiers conformes et dépôt propre.
Travail isolé /tmp/gambit-graphics008-work.

## Livraison

Disque sous les quatre apparences actuelles, rayon 0,35 / diamètre 0,70, directement fourni
par le corps commun GroundCrowd via StatsActor. CharacterView possède le disque séparément
du modèle ; ni son échelle ni ses animations n'en modifient l'emprise. Un shader simple
non éclairé dessine le disque translucide, avec bord intérieur adouci. Couleur, opacité,
adoucissement et activation réglables dans CharacterDefinition. Pas de nouvelle collision,
texture ou lumière, ni d'ombre dynamique. Voir ../ground-shadows.md.

Rayon physique, échelle 0,65, navigation, règles, animations, stats, coûts, durées et portées
conservés. Les sources de mouvement, PartyUnit/PartySimulation, exécuteur et ressources
artistiques existantes sont identiques à la base. Le script historique d'export du laboratoire
de navigation conserve son code/version diagnostiques par expressions régulières, même
quand le preset normal change de version. Métadonnées du laboratoire de performance actualisées.

## Vérifications

Godot 4.7.2.stable.official.ed1daf0bf / Compatibility.
40 bancs headless / 2 541 contrôles, zéro échec, sans erreur/avertissement moteur dans cette
campagne. Les 39 bancs antérieurs / 2 481 contrôles passent ; 60 contrôles dédiés aux ombres.
Inspection GPU PC : 18 captures, quatre apparences × neuf fonds (deux acteurs par capture),
rayon constant et disques visibles sur les huit arènes et le fond de référence. Zéro orphelin
en sortie de galerie. Import et export finaux réussis sans erreur/avertissement moteur.
Le premier import sandboxé a échoué sur l'accès aux réglages éditeur/ADB ; il a été relancé
avec les permissions nécessaires. Les vérifications ci-dessus utilisent l'import final réussi.
Aucune nouvelle mesure FPS n'est revendiquée.

APK normal /tmp/graphics-008-debug.apk : 0.1.0-graphics008 (42), 37 493 150 octets,
SHA-256 3cb968ff960280aece6b1636edd06f34fd33120eb7c429a89f5806011f11d8cc.

Installation -r réussie et version 42 vérifiée par ADB sur Galaxy A16. Inspection visuelle
native du vrai Main : ombres sous les deux héros et les ennemis, puis partie laissée en
pause pour la recette. Captures jointes à la livraison. La capture initiale de fin de combat
montre aussi les disques des ennemis survivants. Pas de campagne automatisée Android sur
les neuf fonds dans cette étape, ni de mesure de performance supplémentaire.

## État

En recette, sans commit/push. GAMEPLAY-003 annulée et non implémentée ; tailles et
contournements conservés. Après validation/clôture de GRAPHICS-008 : STEP-029 puis STEP-030.
