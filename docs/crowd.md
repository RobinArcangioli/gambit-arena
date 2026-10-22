# Foule et séparation — STEP-009

Statut : validé par l’utilisateur, commit en attente. Tests manuels et F6 OK,
fluidité confirmée sur la recette livrée.

## Paramètres

| Paramètre | Valeur |
|---|---|
| Rayon d’empreinte | 0,35 u |
| Distance nominale entre centres | 0,70 u |
| Distance exigée à l’apparition | 0,71 u |
| Vitesse de correction maximale | 0,6 u/s |
| Vitesse souhaitée héros / ennemi | 1,2 / 0,9 u/s |
| Pas de temps accepté maximal | 1/30 s |
| Pas maximal héros / ennemi | 0,04 / 0,05 u |
| À 60 pas/s, maxima correspondants | 0,02 / 0,025 u |
| Arrêt d’approche ennemi | 0,8 u du héros |
| Plafond d’ennemis | 20 |

Le pas affiché au HUD est un maximum depuis le dernier Rejouer, pas une vitesse
ni un temps d’image. Les maxima comprennent la correction ; ils sont des bornes,
pas une vitesse à atteindre. Pause ne change ni ce maximum ni les positions.
L’apparition et la remise à zéro créent des positions initiales et sont exclues.

## Lecture visuelle

Repères dessine les disques sur le sol. Leur projection est elliptique. Les
silhouettes peuvent encore se masquer sans que leurs empreintes se chevauchent.
Pour les configurations initialement valides, le test du segment empêche deux
acteurs de se traverser. Le cas de Bordure commence volontairement avec deux
centres identiques ; une récupération progressive est attendue, pas un saut.

La correction est locale, bornée et dépend de l’ordre stable des instances.
Elle n’est ni une poussée physique ni un mécanisme garantissant de démêler
n’importe quelle pile dense. Le héros fixe n’est pas poussé par les ennemis.
L’encerclement provient des arrivées sur plusieurs côtés ; aucune place autour
du héros n’est réservée et tous les ennemis ne sont pas garantis à portée.

## Blocage et reprise

Dans Blocage, six gardiens fixes sont placés à 0,95 u autour du héros. Il vise
un point à +2,3 sur X. Après environ 0,25 u, le contact l’arrête : état BLOQUE.
Ouvrir passage retire uniquement le gardien sur X+. La même intention devient
réalisable : le héros continue jusqu’au point, sans nouvelle cible ni téléportation.
Les cinq autres gardiens restent immobiles, ce sont des fixtures de diagnostic.

Dans Poursuite, un héros bloqué ne saute pas au point suivant. Il attend que
l’espace se libère. Une autre route peut exister, mais aucun pathfinding n’est ajouté.
Dans Bordure, deux mannequins apparaissent superposés au coin (−2,65, −2,65),
le héros est en (2,3, 2,3). Tous restent dans la limite intérieure.

## Tests et portée

Le banc scenes/tests/ground_crowd_tests.tscn (F6) exécute GroundCrowd et
CrowdSimulation : vitesse libre 30/60/120 Hz, séparation d’une paire coincidente
au coin, budget de correction, face-à-face, delta nul/long, couronne fermée puis
ouverte, pause, nettoyage, 20 acteurs, contrôle du pas et invalidation du héros.
Résultat F6 confirmé OK par l’utilisateur pour STEP-009.
Une simulation Python séparée de conception a vérifié les cas numériques ;
elle n’est pas une compilation ni une exécution des scripts Godot livrés.
Les essais manuels et la fluidité ont été confirmés par l’utilisateur.
