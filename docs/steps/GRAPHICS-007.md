# GRAPHICS-007 validée — 26 octobre 2026

Le propriétaire confirme « Step validée. » pour la livraison GRAPHICS-007,
APK normal 0.1.0-graphics007 (39), installé sur Galaxy A16.
SHA-256 APK : `adbbffbf33239c05622e83059827f45f32f263742631509d878617eca71b7231`.
Validation globale, sans détail supplémentaire ni nouvelle mesure FPS.
Les fichiers non documentaires sont identiques à la livraison validée ; les 37 bancs /
2 374 contrôles déjà réussis ne sont pas relancés pour cette clôture documentaire.
Clôture par un commit unique, puis sauvegarde et restauration vérifiées.
Le chantier GRAPHICS-001 à GRAPHICS-007 est validé. Prochaine étape : STEP-029,
clone/import/export/installation reproductibles ; attendre GO avant de la démarrer.
Les mentions de recette ci-dessous décrivent les états antérieurs.

# GRAPHICS-007 — qualification graphique et remplacement des assets

GO reçu après GRAPHICS-006 validée et clôturée au commit
834f532912a9ee0092133a6761ff40bc70a32933.
Sauvegarde gambit-arena-20261026-223245-834f532912a9.tar.gz,
SHA-256 5ebd326ba824424cc0fefd3960b457e26b789afff565b4e5e165463f1834ca80,
restaurée et vérifiée : 529 fichiers. Travail isolé /tmp/gambit-graphics007-work.

## Résultat

Laboratoire F6 distinct de Main, matrice des huit arènes avec Anne/Mako et les deux
squelettes, 48 captures natives (attaque, sorts et mort), inspectées. Démonstration de
remplacement d'arène, modèle et scène Foudre avec fiches exécutables, sans logique modifiée.
Inventaire de 26 fichiers graphiques avec empreintes, dimensions, glTF, clips et imports ;
auteurs/licences non inventés lorsqu'ils ne sont pas renseignés. Budgets de géométrie,
textures, transparence et effets fixés pour le contenu mesuré.

Voir ../graphics-qualification.md, ../graphics-replacement-recipes.md et
../graphics-assets-and-budgets.md, avec synthèse matérielle et inventaire sous docs/data.

## Vérifications

Godot 4.7.2.stable.official.ed1daf0bf, Compatibility.
37 bancs headless / 2 374 contrôles, zéro échec et aucune erreur/avertissement moteur dans
le bilan final. Les 36 bancs précédents / 2 320 contrôles passent. Le nouveau banc de
54 contrôles compare 600 ticks pour chacune de 18 compositions : 10 800 ticks tracés.
Les huit arènes et la référence, l'absence de vue, les modèles absents/invalides, l'arène
invalide, les scènes d'effets sans contrat, les permutations de modèle/squelette/éclair
conservent les mêmes valeurs de jeu. Soin et Foudre sont résolus dans chaque composition.
Résolution complète entre instantanés, débit unique, cap des fixtures, apparence des
nouvelles vagues, démonstration et nettoyage sans orphelin sont également contrôlés.

Le laboratoire a été vérifié en fenêtre après recalage de la collecte sur les callbacks
normaux de Main. Le panneau de démonstration est rendu sur un fond lisible. Les fichiers
normaux de combat, party, ciblage, déplacement, règles, barres, GLB et images sont inchangés.

## Galaxy A16

APK de diagnostic code 38, 0.1.0-graphics007-qualification, SHA-256
9fa1e8e10369d3397c4bfed873268553004eb84a54598b4d55db41a0af96441a.
Dix mesures complètes de 5 s de chauffe + 20 s de capture : logique, décor, modèles et
effets, avec deux ou six ennemis, puis paire finale inversée full/models à six.
Le collecteur STEP-028 est réutilisé sur le Main actuel (PartySimulation à deux héros),
avec physique à 60 Hz et affichage indépendant. Le passage initial à un tick par frame
rendue est exclu. Rapport brut final SHA-256
5d2b538c05e3a35d5e1c012f7557f358fb654487d648e3c56485c33ccfeaee23.

Cadence de callbacks environ 88–90/s, proche du plafond 90 Hz du téléphone. Avec six
ennemis, CPU Main moyen environ 4,7–5,0 ms et p95 6,7–7,0 ms avec modèles/effets.
Les effets ajoutent peu de coût CPU mesurable face à la variation et quelques draw calls.
Réserve : pointes de reconstruction du fixture (CPU 109–121 ms, frames 123–137 ms),
comprenant sa réapplication de profils ; ce n'est pas une charge continue de Foudre.
Tous les nettoyages reviennent à zéro effet et zéro orphelin, avec 184 nœuds après nettoyage
pour les variantes avec modèles. Les rapports retenus expliquent la petite croissance
mémoire bornée du collecteur. Méthode, valeurs et limites détaillées dans le rapport.

Après récupération des résultats, APK normal installé avec données conservées :
/tmp/graphics-007-debug.apk, 37 432 560 octets, version 0.1.0-graphics007, code 39.
SHA-256 adbbffbf33239c05622e83059827f45f32f263742631509d878617eca71b7231.
Cet APK démarre Main, pas le laboratoire. Version vérifiée par ADB ; jeu laissé en pause.

## État et recette

Étape en recette, non commitée et non poussée. Vérifier F6 du laboratoire et sa démo,
puis F8/F5 et Android : arènes, actions, soin/Foudre, menus, gestes tactiles, Rejouer et
pause/reprise. Le seuil historique 30 FPS ne constitue pas une nouvelle condition.
Réserves conservées : source Squelette A sans tête, soin plus discret sur fonds verts/clairs,
auteurs/licences des fonds et pirates à compléter avant diffusion publique.
Après validation et clôture, STEP-029 reprend le clone/import/export/install reproductible,
puis STEP-030 la recette finale MVP. Ces étapes ne sont pas réalisées par cette qualification.

La livraison originale validée, avec ses 48 PNG et rapports bruts, est conservée à part
dans les sauvegardes sous gambit-arena-graphics007-delivery-validated-5c3d9469.tar.gz.
Elle contient les documents de recette antérieurs ; le commit de clôture porte la validation.
