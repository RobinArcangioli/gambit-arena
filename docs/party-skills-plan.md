# Équipe, compétences et lancement de sorts

Décisions du propriétaire du 26 octobre 2026, à implémenter. Elles remplacent les
hypothèses antérieures « un héros avec deux apparences », « soin personnel uniquement »
et « Foudre comme simple habillage de la spéciale ». Aucun code de combat n'est modifié
par cette mise à jour du plan.

## Règles retenues

- Anne et Mako sont deux héros distincts présents dans la même équipe.
- Anne possède le soin ; Mako possède la Foudre. L'attaque de base reste disponible.
- Il n'y a plus de catégorie ou de slot « compétence spéciale/secondaire » : les compétences
  portent leur nom et appartiennent au personnage concerné.
- Le geste de présentation `cast_spell` correspond au clip `Duck` pour tous les personnages,
  héros comme ennemis. Ce geste commun ne donne pas automatiquement un sort aux squelettes.
- Le gambit « Allié < 50 % PV → Soin » permet à Anne de cibler et soigner Mako.
  « Allié » désigne un autre membre vivant de l'équipe, excluant le lanceur et les ennemis.
  Le seuil est strict : 50 % exactement ne déclenche pas cette condition.
- La cible du soin est distincte de la cible offensive mémorisée. Anne conserve cette
  dernière pendant le soin et la reprend si elle est toujours valide.

Les effets sont résolus par le jeu. Le clip Duck ne déclenche ni soin, ni dégâts, ni coût.
Le choix d'un modèle ne détermine pas les compétences : profil de personnage logique et
profil de présentation restent séparés.

## Incantation et barres au-dessus des acteurs

Décision complémentaire du propriétaire : le soin a un temps d'incantation de **1,5 s**,
la Foudre de **2 s**. Ce sont des durées de jeu, communes aux commandes manuelles et aux
gambits, et non des durées imposées par le clip importé. Le soin ou les dégâts ne sont
résolus qu'à la fin de l'incantation, après revalidation de la cible ; une animation
terminée ne peut jamais provoquer l'impact. Les anciennes durées de préparation ne font
plus foi pour ces deux sorts. Les coûts, cooldowns et temps de récupération restent des
paramètres distincts de l'incantation.

Chaque héros et chaque ennemi possède un affichage compact ancré au-dessus de son modèle,
dans cet ordre strict de haut en bas :

1. **Vie — rouge**, valeur courante / maximum.
2. **Mana — bleu**, valeur courante / maximum.
3. **Incantation — jaune or**, uniquement pendant le lancement d'un sort.

La barre d'incantation se remplit de 0 à 100 % suivant le temps de jeu écoulé divisé par
la durée du sort. Elle disparaît à la résolution ou à l'annulation, sans rester pendant
la récupération. Pause et mise en arrière-plan figent sa progression ; la reprise ne
rattrape pas le temps mural. La présentation de Duck est adaptée à la durée logique de
chaque sort, avec la même source de temps que la barre.

Les barres sont une vue réutilisable, indépendante du mesh et de la simulation : elles
lisent PV, mana et progression d'action, sans les modifier, avec un ancrage configurable
par modèle. Taille, espacement et couleurs sont modifiables dans la présentation. Elles
restent lisibles en portrait, suivent l'acteur et ne capturent pas les entrées tactiles.
Retirer un acteur ou rejouer nettoie aussi ses barres.

La mana devient la ressource affichée pour les héros et ennemis. La conversion de
l'énergie actuelle, les maxima, les coûts et la régénération seront explicités dans
GAMEPLAY-001 ; cette demande ne fixe pas leurs nouvelles valeurs et ne donne pas de
sort aux ennemis par le seul ajout d'une barre de mana.

## Ordre de réalisation

1. **GRAPHICS-003** : intégrer les quatre modèles pirates, repos et déplacement, avec
   profils visuels remplaçables et présentation nulle. Le banc graphique peut montrer
   Anne et Mako ; la coexistence en combat arrive avec l'étape suivante.
2. **GAMEPLAY-001 — Équipe et compétences propres aux héros** : faire fonctionner Anne
   et Mako ensemble, gérer alliés et ennemis, ciblage et états individuels, soin d'un allié,
   Foudre de Mako, gambits et commandes par personnage. Introduire les incantations
   de 1,5 s / 2 s, la mana et les trois barres au-dessus des acteurs. Adapter le HUD et la sauvegarde
   des règles ; remplacer la notion de spéciale dans les parcours actifs. Prévoir une
   migration explicite des anciennes règles `special` au lieu de les réinterpréter
   silencieusement. Les laboratoires historiques restent des références de leur version.
3. **GRAPHICS-004** : attaque, réaction et mort sur ce socle d'équipe.
4. **GRAPHICS-005** : Duck sur 1,5 s et effet de soin d'Anne sur l'allié effectivement soigné.
5. **GRAPHICS-006** : Duck sur 2 s et éclair de Mako sur l'ennemi effectivement touché.
6. **GRAPHICS-007** : recette de l'équipe complète, arènes, actions et Android.

L'étape gameplay a sa propre validation et son commit : ses changements de règles ne
doivent pas être attribués à l'import des modèles ou aux animations.

## Points à fixer à la préparation de GAMEPLAY-001

Le propriétaire n'a pas encore fixé les portées du soin et de la Foudre, le comportement
d'approche d'un allié, l'accès éventuel d'Anne au soin personnel, ni le contrôle manuel
des deux héros. Définir aussi le ciblage des ennemis face à deux héros et la condition de
défaite quand un seul héros meurt. Présenter ces choix avec la préparation de cette étape.
Les anciens coûts, cooldowns et quantités constituent une base de comparaison, pas une
nouvelle validation d'équilibrage pour une équipe à deux.

## Recette à prévoir

- Anne soigne Mako sous 50 %, jamais un ennemi, un allié mort ou une cible absente.
- À 50 % exactement, aucune sélection par cette règle ; sous le seuil, sélection
  déterministe, puis validation de la cible à l'engagement et à la résolution.
- Mako ne peut pas lancer le soin d'Anne ; Anne ne peut pas lancer la Foudre de Mako.
- Manuel et gambits passent par le même exécuteur ; coût, cooldown et impact uniques.
- Les effets suivent la cible réelle ; la mort d'une cible pendant la préparation est traitée.
- Pause, reprise, fin de partie et Rejouer nettoient les deux héros, actions et effets.
- États de combat identiques avec modèles, mannequins et présentation nulle.
- Aucun soin avant 1,5 s, aucun impact de Foudre avant 2 s ; un seul effet au franchissement
  du seuil, y compris si une image couvre la fin de l'incantation.
- Vie rouge, mana bleu, incantation jaune or : ordre et valeurs corrects pour chaque héros
  et ennemi ; barre de sort absente au repos, après résolution, annulation et Rejouer.
- Duck et barre de sort restent synchronisés en pause/reprise Android ; les barres ne
  gênent ni le toucher ni les gestes de défilement.
