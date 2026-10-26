# GAMEPLAY-002 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour la livraison du contournement local partagé.
APK normal 0.1.0-gameplay002 (41), installé sur Galaxy A16 et laissé en pause.
SHA-256 APK : `105021ffe77922674c6a9c90be8cd60a79f5a8cbd748776ff76bcf1e1e6d0505`.
Validation globale, sans détail supplémentaire ni nouvelle mesure de performance.
Code, scènes, assets et configuration identiques à la livraison validée ; seuls les documents
sont actualisés. Les 39 bancs / 2 481 contrôles et 28 cas Android déjà réussis ne sont pas
relancés pour cette clôture documentaire. Clôture par un commit unique puis sauvegarde
restaurée/vérifiée. GAMEPLAY-003 (gabarits plus fins) attend un nouveau GO.
Les mentions de recette et de préparation suivantes décrivent les états historiques.

# GAMEPLAY-002 — contournement local partagé

GO reçu pour la première des deux étapes de déplacement. Base fonctionnelle :
GRAPHICS-007 clôturée au commit 440829bfca597654a520897f488cf97ea24fb1f4,
sauvegarde gambit-arena-20261026-232221-440829bfca59.tar.gz,
SHA-256 bbb2b967eba209400f048dc461b0c1c5bc7d2b8838213aa60c6f59111c80c95e,
restaurée/vérifiée (548 fichiers). Le plan GAMEPLAY-002/003 approuvé au GO est inclus.
Travail isolé /tmp/gambit-gameplay002-work ; implémentation les 26–27 octobre 2026.

## Résultat

Un LocalNavigator est composé dans chaque PartyUnit : même routage pour Anne, Mako et
les squelettes. Direction directe libre prioritaire, sinon petit A* natif sur grille 27 x 27,
chemins conservés/lissés, obstacles dynamiques revalidés, préférence de côté, attente stable
sans passage. Une recherche au maximum par pas, en rotation, et délai de 0,35 s par acteur.
GroundCrowd garde son dernier contrôle de contact et le mover indique le mouvement effectif.
Voir ../local-navigation.md pour l'API, le budget et les limites de résolution.

Rayon 0,35 et échelle 0,65 préservés. GroundCrowd, ArenaBounds, vitesses/statistiques,
PartyExecutor, gambits, clips/effets et assets ne sont pas modifiés. Seules la composition
des unités et la phase de déplacement de PartySimulation changent dans le jeu normal.
Le routage ne choisit jamais la cible. Chronologie et issue des combats peuvent évoluer
avec les nouvelles trajectoires ; aucune identité globale avec l'ancien déplacement promise.
Les laboratoires historiques sans pathfinding restent inchangés.

## Vérifications moteur

Godot 4.7.2.stable.official.ed1daf0bf / Compatibility.
39 bancs headless / 2 481 contrôles, zéro échec et aucune erreur/avertissement moteur dans
la campagne finale. Les 37 bancs antérieurs / 2 374 contrôles passent.

47 nouveaux contrôles bas niveau : rôles héros/ennemis à 30/60/120 Hz, détour, arrivée stable,
contacts/bornes/vitesse/budget, écran de deux corps, bordure, anneau fermé puis ouvert,
pause du retry, cible mobile/morte, départ au contact, intentions opposées, croisements,
reproductibilité, action active immobile et nettoyage. Le contact contre un corps à la
bordure est aussi vérifié à 30/60/120 Hz : raccord en deux segments sûrs avant la grille.
60 contrôles d'intégration : contournement et engagement réel sur les quatre apparences
par Main et son vrai planificateur ; cible et portée préservées ; échelle inchangée ; route
figée en pause/background et premier tick de retour rejeté ; reprise explicite ; dix Rejouer ;
28 compositions de galerie atteignables et sûres, puis zéro orphelin.

F6 inspecté en fenêtre : trace de détour et points de passage, anneau fermé en attente,
commandes et barres ; fin des captures sans orphelin. Aucun modèle rendu plus petit ici.

## Galaxy A16

Laboratoire Android code 40, version 0.1.0-gameplay002-lab,
SHA-256 46732a1ed0a6739815db00cf12f70f13ba7e3ae1effb06f94b16bf1cc8c99e57.
28 cas réussis (4 apparences x 7 situations), sans interruption ni violation du budget.
Le même mouvement et les mêmes gabarits sont utilisés dans le jeu et la galerie.
Les captures natives et leurs traces ont été inspectées via quatre planches de contact.
La recherche individuelle la plus longue mesurée dans les fixtures est 4,601 ms.

Un relevé supplémentaire utilise le vrai Main en combat, deux héros et jusqu'à six ennemis,
avec callbacks normaux : 5 s de chauffe, puis 20 s mesurées. Cadence moyenne de callbacks
88,94/s, intervalle p95 17,62 ms ; CPU physique Main moyen 5,02 ms, p95 7,13 ms,
max 30,75 ms. Intervalle maximal 78,09 ms ; aucune nouvelle cible de FPS imposée.
Recherche maximale observée pendant ce relevé (chauffe incluse) : 4,518 ms.
Le compteur de recherches est échantillonné à 1 Hz et peut manquer une requête brève ; le
budget est aussi vérifié à chaque pas dans les scénarios. Zéro orphelin dans la télémétrie.
Il ne s'agit pas d'un temps GPU ni d'une mesure de présentation effective de chaque image,
ni d'une comparaison directe avec la fixture et l'UI de GRAPHICS-007.

Synthèse versionnée : ../data/gameplay002-galaxy-navigation.json ; rapport brut joint à
la livraison, SHA-256 52686fae72282bf99a240db7a13f8c447471d37b427e22196bbd1e2dec786e88.

APK normal : /tmp/gameplay-002-debug.apk, 37 479 718 octets,
0.1.0-gameplay002, code 41,
SHA-256 105021ffe77922674c6a9c90be8cd60a79f5a8cbd748776ff76bcf1e1e6d0505.
Installé/lancé sur Galaxy A16 après la campagne, données conservées et version vérifiée
par ADB. Il démarre Main ; le laboratoire reste accessible dans l'éditeur avec F6.

## Recette et état

Étape en recette, sans commit/push de GAMEPLAY-002. F6 local_navigation_lab.tscn : choisir
les acteurs/scénarios, ouvrir le passage fermé, pause et Rejouer. F8 puis F5 : vérifier le
contournement naturel des alliés/ennemis, les attaques/casts à l'arrêt, cible morte/mobile,
menus, tactile et pause/reprise Android. Les passages très étroits restent limités par la
maille locale ; aucune traversée n'est autorisée pour les forcer.
Après validation/clôture seulement, GAMEPLAY-003 réduira l'emprise et la taille visuelle.
STEP-029 et STEP-030 restent ensuite au programme.
