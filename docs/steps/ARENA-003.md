# ARENA-003 validée — 29 octobre 2026

Le propriétaire confirme sur Galaxy A16 : « Oui, step validée » pour les statistiques,
le MVP et le journal. Deux boutons indépendants sans chevron ; menus pleine largeur,
statistiques en colonnes Héros / Ennemis. Bordures alignées sur les panneaux héros,
espace inférieur de 12 px. MVP magenta, score dégâts effectifs + soins effectifs.
Journal continu des 1 000 dernières entrées en RAM, Direct et pause/lecture intégrée.
Horodatages mm:ss.mmm, mentions de non-paiement retirées et récupération d’Attaque omise.
Les 65 scènes / 4 451 contrôles et la recette Android avaient déjà réussi.
Clôture documentaire seule : code, ressources, configuration et APK identiques à
la livraison validée ; aucune nouvelle exécution des tests ni mesure de performances.
APK installé : `0.1.0-arena003-journal` (70), SHA-256
`0d33882137b374f25164d328a33f5642b28e6b66510982666002221af2e225dc`.
Gambits conservés octet pour octet ; pause et scroll du journal vérifiés sur Galaxy.
Clôture par commit et sauvegarde complète restaurée/vérifiée. Aucun push automatique.
Prochain GO : UI-005, qualification intégrée Android, puis STEP-029/030.
Les états précédents ci-dessous sont historiques.

# ARENA-003 — Statistiques, MVP et journal joueur

Statut : en recette, validation utilisateur attendue. Base :
`b2fb882500355a85633d08101fd746f1f5ecfd55` (ARENA-002 validée).

## Interface retenue

Deux commandes indépendantes visibles uniquement dans l’arène : tablette de notes
pour Statistiques à gauche, feuille sobre avec trois lignes et coin replié pour
Journal immédiatement à sa droite. Contour or, intérieur bleu nuit, icônes 30 px,
zones tactiles 48×48 px, aucun cadre ni fond de bouton. La première commande garde
la marge symétrique de l’engrenage droit. Aucun chevron de bascule ou pagination.

Les menus utilisent le même panneau translucide bleu nuit/or que les réglages.
Un seul menu de consultation est ouvert à la fois. Chacun prend toute la largeur
utile, sous le bandeau et jusqu’à 12 px au-dessus des quatre panneaux de héros.
Bords gauche et droit alignés sur ceux des panneaux héros (12 px de marge de zone sûre).
Le compteur Vague N est masqué tant qu’un menu de consultation est ouvert pour
éviter une superposition de texte. Les panneaux héros restent entièrement visibles.
Un nouveau clic sur l’icône active ou Retour ferme son menu. Le combat continue.
Ouvrir les réglages ferme la consultation, et inversement. Pause globale et mise en
arrière-plan ferment ces vues et conservent la reprise explicite habituelle.

Statistiques : colonnes de largeur égale, Héros à gauche, Ennemis à droite ; titres
fixes, défilements indépendants. Chaque groupe est trié par dégâts infligés décroissants,
puis ordre d’équipe en cas d’égalité. Trois barres par acteur : Infligés or #ffd16a,
Reçus rouge #e44949, Soins vert #b8ffcc, valeurs et libellés blancs. Les échelles se
basent sur le maximum de chaque mesure dans les fiches conservées ; aucune estimation
de dégâts potentiels. Les morts restent signalés par † jusqu’à leur retrait de vague.

## Comptage et MVP

Seuls les PV effectivement perdus ou rendus sont comptés : aucun surplus d’attaque
ou soin. Les effets entre camps atypiques restent attribués à leur vrai auteur.
Les totaux des héros, morts compris, couvrent tout le combat. Les fiches ennemies
incluent uniquement la vague actuelle et sont effacées au spawn de la suivante.
Le journal survit à cette transition. Nouveau Mode Infini/Rejouer remet tout à zéro.

MVP héros seulement : score = dégâts effectifs infligés + soins effectifs prodigués.
Un PV compte pour un point ; les dégâts reçus n’apportent aucun point. Égalité :
dégâts infligés, puis ordre dans l’équipe. Aucun MVP avant une contribution positive.
La mention MVP magenta puissant #ff00ff suit immédiatement le nom du héros, même
si le tri par dégâts le place en seconde position. Un ennemi ne peut jamais être MVP.

## Journal

Un seul scroll continu peut parcourir les 1 000 dernières entrées en ordre chronologique.
Ni pagination, ni réglage de capacité. Le cache et son texte ne sont jamais enregistrés
sur disque ; il ne reste rien du précédent journal après un nouveau combat. Les choix
antérieurs de capacité ne sont plus lus ni écrits. Les paragraphes évincés sont retirés
également de la console ; elle ne grossit pas indéfiniment.

Horodatage de combat mm:ss.mmm, arrondi à la milliseconde avec retenue correcte
à la minute suivante ; nom de source/cible, action et valeurs utiles : préparation,
incantation, résolution, récupération et interruption ; dégâts/soins effectifs et coût
PM payé à l’impact ; buff, durée, accélération, expiration et dissipation à la mort ;
morts, vagues, fin de combat, pause/reprise et abandon. Aucun déplacement ni tick de
régénération. Couleurs sobres selon le fait. Les noms sont ajoutés comme texte, sans
interpréter de BBCode. Les messages d’annulation ne contiennent aucune mention « aucun PM dépensé ».
Les récupérations de la compétence Attaque (fin ou interruption) sont omises ; celles
des sorts restent consignées. Préparations, impacts et annulations avant impact
d’Attaque restent visibles. Le paiement réel des compétences ne change pas.

Direct suit les dernières actions. Remonter le journal suspend ce suivi ; Direct le
rétablit. Le bouton || met uniquement le combat en pause, garde le journal ouvert et
le transforme en triangle de lecture. Le scroll reste utilisable. Lecture reprend
sans ouvrir de menu ni fermer le journal. Une défaite ne peut pas être reprise par
ce bouton. Les protections focus/suspension et contre les gestes résiduels restent
prioritaires. Fermer le journal ne reprend pas implicitement une pause demandée.

## Séparation et tests exécutés

Observateur `scripts/party/combat_report.gd`, alimenté par les événements de simulation ;
présentation dans `combat_statistics_menu.gd` et dessin virtualisé dans
`combat_statistics_list.gd`. Aucun état d’acteur ni coût n’est modifié par ces vues.
Le laboratoire `scenes/debug/combat_statistics_lab.tscn` utilise une fixture locale
et ne lit/écrit aucun gambit ni réglage du joueur. F5 conserve la scène principale.

65 scènes / 4 451 contrôles réussis, zéro erreur/warning moteur dans les tests.
Le nouveau banc `scenes/tests/combat_statistics_tests.tscn` couvre 130 contrôles :
comptage effectif sur vrais exécuteurs, dédoublonnage, invalidation d’ancien combat,
MVP, buff réel/expiration, reset de vague et de combat, limite RAM sur 2 200 entrées,
console continue et éviction incrémentale, boutons séparés sans chevron, colonnes
et groupes, layouts 540×960 et 360×640, pause/lecture sans menu, gel des temps/PM,
scroll tactile pendant pause, Direct, Retour, réglages exclusifs, arrière-plan et
absence d’orphelins. Les 64 bancs existants restent réussis.
Rendu GPU examiné et APK normal installé sur Galaxy A16 ; recette détaillée, captures
et empreinte installée dans la livraison. Gambits privés préservés octet pour octet.
Pas de nouvelle mesure de performances ni validation utilisateur déduite de ces tests.

## Ajustement du 29 octobre

Le propriétaire confirme : « Les marges sont OK ». Bords alignés sur les panneaux
héros et espace inférieur de 12 px conservés. La validation globale de l’étape reste
attendue après les modifications des messages et des horodatages demandées ensuite.

## Recette utilisateur

En Mode Infini : comparer les deux icônes ; ouvrir les statistiques et vérifier
les deux colonnes, couleurs, ordre et badge MVP. Ouvrir le journal via son propre
bouton ; remonter, revenir avec Direct, figer avec ||, défiler, reprendre avec lecture.
Vérifier les panneaux héros dégagés et l’absence de chevron. La recette automatisée
ne remplace pas la validation esthétique/tactile finale du propriétaire.

APK : `arena-003-journal-debug.apk`, version `0.1.0-arena003-journal` (70).
SHA-256 : `0d33882137b374f25164d328a33f5642b28e6b66510982666002221af2e225dc`.
Archive complète distincte, sources sans .git/.godot, historique de base séparé et
vérification de restauration. Aucun commit avant validation ni push automatique.
