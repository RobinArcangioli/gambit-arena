# Roadmap graphique — GRAPHICS-001 à GRAPHICS-007

Préparée le 26 octobre 2026 à la demande du propriétaire, sur STEP-028 clôturée au commit
`580ce641390f30667133cec0a580ee3d64f0c51a`. Roadmap validée. GRAPHICS-001 est clôturée
au commit local f5a790d avec sauvegarde vérifiée. GRAPHICS-002 est validée après intégration
du catalogue, clôturée au commit local `1e427560a9d2884ce1d3e339a093d576192fc22f`.
Les modèles de GRAPHICS-003 sont reçus : Anne et Mako du Pirate Kit pour les héros,
les deux squelettes du même Pirate Kit pour les ennemis (KayKit réservé pour plus tard). Voir [l'inspection des assets](character-assets-intake.md)
pour les clips disponibles et les raccordements à prévoir. GRAPHICS-003 est clôturée au commit 7956cfc. GAMEPLAY-001 est validée avec fix1 ; voir docs/steps/GAMEPLAY-001.md.
Le chantier graphique s'intercale avant STEP-029 et STEP-030, qui gardent leurs identifiants
et seront exécutées sur la version enrichie. Voir docs/steps/GAMEPLAY-001.md pour la livraison actuelle.

## Objectif et périmètre

### Révision : équipe et compétences propres aux héros

La décision du propriétaire du 26 octobre 2026 ajoute Anne et Mako dans la même équipe,
le soin d'Anne sur Mako via « Allié < 50 % PV », et la Foudre propre à Mako. `Duck`
est le geste `cast_spell` commun aux héros et ennemis. La notion de compétence
spéciale/secondaire disparaît. Le [plan équipe et compétences](party-skills-plan.md)
fait foi et remplace les hypothèses antérieures contradictoires ci-dessous concernant
le héros unique, le soin personnel et Foudre comme habillage inchangé de `special`.
GAMEPLAY-001 s'intercale après GRAPHICS-003 et avant GRAPHICS-004 ; les étapes graphiques
restent indépendantes des règles. Les sections suivantes conservent le plan initial
comme référence pour les invariants non remplacés.

Les temps d'incantation sont désormais fixés à **1,5 s pour le soin** et **2 s pour la
Foudre**. GAMEPLAY-001 inclut la mana et les barres au-dessus de tous les héros et ennemis :
vie rouge, puis mana bleu, puis incantation jaune or uniquement pendant le lancement.
GRAPHICS-005/006 synchronisent Duck sur ces durées de jeu. Ces décisions remplacent les
anciennes hypothèses de durées inchangées pour les sorts ; détails et recette dans le
plan équipe et compétences.

### Arènes fournies par le propriétaire

Archive reçue : `arenes_isometriques_540x960.zip`. Inspection effectuée : huit décors PNG
540 × 960, une grille PNG transparente de même taille et `grille_8x8_coordonnees.json`.
Les huit thèmes fournis remplacent les suggestions artistiques initiales de cette roadmap :

| Identifiant proposé | Décor fourni |
|---|---|
| colisee_solaire | 01_colisee_solaire_540x960.png |
| sanctuaire_polaire | 02_sanctuaire_polaire_540x960.png |
| forteresse_volcanique | 03_forteresse_volcanique_540x960.png |
| temple_sylvestre | 04_temple_sylvestre_540x960.png |
| arcane_bleu_sombre | 05_arcane_bleu_sombre_540x960.png |
| chaos_vert_toxique | 06_chaos_vert_toxique_540x960.png |
| lumiere_angelique | 07_lumiere_angelique_540x960.png |
| pirates_fantomes | 08_pirates_fantomes_540x960.png |

Ce sont des fonds opaques avec décor et éclairage déjà illustrés. La première intégration
les utilise comme fonds 2D ; aucun décor 3D, découpage d'occultation ou animation des flammes
n'est présumé fourni. La provenance détaillée et les conditions de redistribution restent à
consigner ; la réception des fichiers ne permet pas d'inventer une licence.

Le JSON décrit une grille 8 × 8 : sommet (270,317), centre (270,455), bases par case
(30,17,25) et (-30,17,25), sommets latéraux (30,455)/(510,455) et bas (270,593).
Sa note mentionne quatre visuels alors que l'archive en contient huit : vérifier le calage sur
chaque décor. Ces données servent de repères visuels, pas de navigation ni de collision.
Les lignes incorporées aux illustrations ne garantissent pas une grille exacte.

GRAPHICS-001 doit comparer ces repères à la projection actuelle : pente fournie 0,575 contre
0,5 pour la caméra dimétrique actuelle, huit cases de référence contre le sol dessiné actuel
de six cases. Ne pas assimiler une case d'illustration à une unité logique. Définir dans le
profil la transformation image/viewport et l'aire jouable projetée, puis vérifier pieds,
perspective et bordures au centre et aux extrémités. Conserver le ratio de l'image et vérifier
le cadrage avec le HUD portrait. Si un calage satisfaisant exige de retoucher l'image ou
d'adapter la caméra commune, présenter la comparaison visuelle avant de retenir ce choix ;
ne pas déformer silencieusement les personnages ou modifier les limites du combat.

Introduire d'abord des variantes d'arène, puis des personnages 3D remplaçables et leurs
animations : attaque, soin et lancement d'un premier sort, Foudre. Préserver le gameplay
validé et rendre possible le remplacement ultérieur d'un décor, modèle, rig, animation ou
effet depuis des scènes et ressources de présentation.

Le socle reste Android portrait, Compatibility, caméra dimétrique fixe, sol logique 2D,
personnages 3D et arrière-plan 2D. « Modèle d'arène » signifie ici un habillage visuel du même
terrain : mêmes dimensions jouables, apparitions, limites et règles. Des terrains de formes
différentes, obstacles, collisions ou mécaniques élémentaires constitueraient un chantier gameplay.

Hypothèse proposée pour Foudre : c'est la présentation de la compétence interne `special`,
déjà partagée par le manuel et les gambits. Son coût 30, cooldown 6 s, portée 1 et formule
de dégâts restent inchangés. Aucun effet de zone, saut entre cibles, étourdissement ou nouveau
slot n'est ajouté. L'appellation affichée pourra devenir « Foudre » en gardant l'identifiant
interne, les règles et leur compatibilité. Cette hypothèse fait partie de la validation du plan.

## Frontière entre jeu et présentation

Constat dans la base : `StatsActor` hérite de `ProxyActor`, `CombatUnit.present()` appelle
ses poses, et la simulation appelle cette présentation. Le sol et l'éclairage sont construits
par `Arena`/`ArenaFloor`. Cette séparation est donc un travail à réaliser, pas un acquis.

Architecture cible, à introduire progressivement :

| Partie | Possède | Ne décide pas |
|---|---|---|
| Simulation et exécuteurs | Identités, positions logiques, orientation, action et phases, coûts, impacts, PV, morts, temps de jeu | Mesh, squelette, matériaux, animations, particules |
| Adaptateur de présentation | Capture de valeurs et événements visuels, association des identités aux vues | Cibles, dégâts, soin, disponibilité des compétences |
| Vue d'acteur | Modèle enfant, rig, animations, sockets, orientation visuelle et ancrage | Mouvement logique, portée, durée effective de l'action |
| Vue d'arène | Fond, décor, matériaux, lumière, points d'ancrage visuels | Limites jouables, vagues, apparitions, séparation |
| Effets visuels | Préparation, frappe, soin, éclair, fin et nettoyage | Application d'un effet de gameplay |
| Composition de scène | Catalogue et choix d'arène, apparence héros/ennemi, profils d'animation et d'effets | Règles de combat |

Le sens des dépendances va du jeu vers un contrat de valeurs puis vers la présentation.
La simulation doit pouvoir fonctionner avec une présentation nulle. Les ressources artistiques
ne sont pas chargées par les exécuteurs. Le nœud logique peut rester un `Node3D` pour préserver
les interfaces actuelles ; sa représentation devient un enfant interchangeable, pas sa classe mère.
Les anciennes scènes de laboratoire gardent un adaptateur compatible avec le mannequin.

Noms et dossiers proposés, à stabiliser lors de GRAPHICS-001 :

- `scripts/presentation/` : contrats et adaptateurs, sans règles de combat.
- `resources/presentation/` : définitions d'arène, d'apparence et de compétence visuelle.
- `scenes/presentation/arenas/`, `characters/`, `effects/` : scènes remplaçables.
- `assets/art/` : sources artistiques, imports et provenance ; aucune règle de jeu.
- `scenes/debug/graphics_lab.tscn` : galerie isolée pour prévisualiser variantes et actions.

Une définition référence des `PackedScene`, matériaux, noms de clips et réglages d'import,
d'échelle, d'orientation et de sockets. Elle ne contient ni dégâts ni coût ni portée. Les noms
des os/clips propres à un fournisseur restent confinés dans son adaptateur. Les modèles
importés restent intacts ; une scène enveloppe porte les adaptations Godot.

## Ordre d'intégration

Chaque étape donne un résultat jouable ou prévisualisable, sa recette et une archive complète.
Validation et sauvegarde vérifiée précèdent la suivante selon le cycle du projet.

| Étape | Livraison | Critère principal d'acceptation |
|---|---|---|
| GRAPHICS-001 | Socle de présentation et première arène interchangeable | L'arène actuelle est un profil de référence ; Colisée solaire se charge avec calage vérifié sans toucher aux règles de combat |
| GRAPHICS-002 | Catalogue des huit arènes fournies | Huit habillages sélectionnables dans la galerie et par configuration de partie, plus le terrain de diagnostic |
| GRAPHICS-003 | Personnages 3D et locomotion | Héros et ennemi riggés, Idle/Move, modèles remplaçables avec ancrage cohérent |
| GRAPHICS-004 | Attaque, réaction et mort | Animation synchronisée sur l'action réelle, frappe unique et cycle de vie conservés |
| GRAPHICS-005 | Soin | Geste et effet dédiés, synchronisés sur le soin effectivement résolu |
| GRAPHICS-006 | Sort Foudre | Lancement, éclair ciblé et impact correspondant à `special`, sans changement des règles |
| GRAPHICS-007 | Cohérence et recette graphique Android | Matrice arènes/personnages/actions, remplacement d'assets démontré et comparaison matérielle |

### GRAPHICS-001 — Socle et première variante d'arène

Extraire la représentation du terrain sans réécrire les chaînes de laboratoires. Définir le
contrat d'ancrage au sol, la caméra commune et les racines de décor. Convertir le visuel actuel
en arène de référence, puis ajouter une première variante simple. Ouvrir une galerie de
prévisualisation indépendante du combat. Prévoir le point de composition des apparences et
la présentation nulle ; l'extraction complète du mannequin sera terminée dans GRAPHICS-003.

Acceptation : changer uniquement une ressource remplace l'arène ; les positions projetées,
la surface jouable, le HUD et les entrées sont conservés. Comparer une même séquence de
simulation avec les deux vues et sans vue : mêmes états de combat. Les props sont décoratifs,
ne capturent pas le toucher et n'introduisent aucune collision. Le terrain reste aligné après
redimensionnement et retour Android.

### GRAPHICS-002 — Plusieurs modèles d'arène

Intégrer les huit profils fournis ci-dessus après qualification du premier dans GRAPHICS-001.
Conserver le terrain actuel comme profil de diagnostic. Vérifier sol, bordures, palette et
éléments périphériques pour chaque illustration, avec une aire centrale lisible et les mêmes
repères logiques. Conserver la lumière commune par défaut ; toute adaptation de l'éclairage
des personnages à un fond est un réglage du profil graphique.

Choix d'arène avant la partie ou dans la galerie ; aucune modification des gambits et aucune
obligation de menu en combat. Le catalogue utilise des identifiants stables, un aperçu et un
profil de repli si une ressource manque. Le remplacement d'arène libère la précédente.

Acceptation : les huit profils fonctionnent sur le Galaxy A16 ; pas de pieds flottants,
d'occultation gênante des personnages, de débordement sur le HUD ou de dérive mémoire lors
de changements répétés. La galerie affiche le repère de surface jouable pour vérifier l'alignement.

### GRAPHICS-003 — Modèles 3D et animation de base

Choisir un premier héros et un ennemi avec un rig documenté et des clips réutilisables.
Préférer une filière glTF/GLB avec sources conservées et provenance explicite. Figer dans la
fiche d'intégration les unités, l'axe avant, le pivot aux pieds, l'échelle et la hiérarchie du rig.
L'acquisition/création des modèles, leur style et les licences sont à décider avant intégration
des assets concernés ; on peut préparer le contrat avec le mannequin disponible.

Terminer l'extraction de `StatsActor` hors de l'héritage graphique ; le mannequin devient une
vue de repli. Ajouter l'enveloppe de modèle, la correspondance des clips et les sockets
facultatifs main/arme/centre/impact. Idle et Move suivent la vitesse et la direction logiques.
Animation en place : aucun root motion ne déplace l'acteur ; une action ou une cible à portée
garde les pieds immobiles. Vérifier toutes les orientations visibles de la caméra.

Acceptation : deux apparences peuvent être permutées par configuration sans changement dans
la simulation ; états de combat identiques avec modèles, mannequins ou vue nulle. Les anciens
tests restent compatibles. Pause, reprise, défaite et Rejouer nettoient correctement les vues.

### GRAPHICS-004 — Attaquer, subir un coup, mourir

Introduire la lecture visuelle des phases réelles : engagement, préparation, résolution,
récupération, fin/annulation. Les clips sont adaptés aux durées de l'action existante
(préparation 0,6 s, récupération 0,4 s), sans faire attendre le jeu après une animation.
Une animation ne rappelle jamais `try_impact()` et ne débite jamais une ressource.

Les événements contiennent des valeurs stables : `run_id`, identités source/cible,
`action_id`, type d'action, résultat et positions utiles. Capturer les transitions pendant
le tick : une simple lecture de l'état en fin d'image peut manquer un impact ou une mort.
Consommation bornée, événement joué une fois ; un événement d'une ancienne partie est ignoré.
Publier la résolution après validation de l'effet, sans callback visuel entre validation et débit.

Une cible retirée à l'impact peut nécessiter une vue de mort temporaire détachée : conserver
seulement son instantané visuel, jamais sa présence en combat. La réaction à un coup ne
bloque pas l'exécuteur. L'effet de frappe s'affiche uniquement pour le résultat correspondant ;
un coup hors portée ne montre pas un impact réussi.

Acceptation : même nombre d'actions, dégâts, coûts et cibles avant/après ; contact lisible,
aucun pas parasite, double impact ou animation ressuscitant un acteur. Mort et reprise restent
correctes à faible cadence d'image, en pause et après dix Rejouer.

### GRAPHICS-005 — Soigner

Associer `heal` au clip `Duck` du Pirate Kit, choisi par le propriétaire comme geste
`cast spell`, et à un effet local lisible (halo/particules légères),
avec origine configurable sur le modèle. La préparation peut commencer à l'engagement ;
le signal visuel de réussite et la valeur de soin suivent la résolution effective.
Le soin conserve la cible offensive, le coût 20, le cooldown 4 s et le soin de 30 PV existants.

Acceptation : soin automatique et manuel ont la même présentation ; refus, interruption,
mort et absence de soin effectif ne produisent pas de réussite visuelle. Aucun effet restant
après Rejouer ; fermeture d'un menu ne reprend pas l'animation sans reprise du jeu.

### GRAPHICS-006 — Lancer Foudre

Utiliser le clip `Duck` du Pirate Kit comme geste de lancement (`cast spell`), commun au
soin selon le choix du propriétaire. Ajouter une préparation discrète, un éclair dirigé sur la cible réelle
puis un impact bref. L'éclair utilise un effet léger compatible Android ; ni lumière dynamique,
ni shader coûteux, ni plein écran clignotant ne sont requis pour la première version.
Le profil visuel de `special` porte les scènes, couleurs, durées et sockets de Foudre.
Le libellé affiché peut évoluer sans migrer les identifiants des gambits.

La préparation suit la source et la cible vivantes ; l'impact utilise la position capturée lors
de la résolution, y compris si la cible meurt ce tick. Une annulation coupe la préparation.
Un résultat hors portée n'affiche aucun éclair d'impact réussi. L'effet se fige en pause,
se nettoie en fin/replay et refuse les identifiants d'une ancienne partie.

Acceptation : Foudre remplace la présentation de la spéciale sans changer dégâts, portée,
coûts, cooldowns ou sélection de cible ; même résultat par manuel/gambits et à faible FPS.
Remplacer la scène d'éclair suffit à changer l'esthétique du sort.

### GRAPHICS-007 — Qualification et facilité de remplacement

Vérifier chaque arène avec les deux personnages et attaque/soin/Foudre sur téléphone.
Reprendre les tests ciblage, immobilité à portée, SkillExecutor, commandes, swipe et cycle
de vie. Ajouter les tests de contrat utiles : vue absente, asset manquant, permutation de
modèle, résolution dans un même tick, annulation et rejet des événements périmés.

Comparer avant/après avec le banc STEP-028 dans les mêmes conditions et les effectifs du jeu
prévu : distinguer coût du décor, modèles et effets. La fixture à 20 reste informative.
Le seuil historique de 30 FPS ne redevient pas une condition par défaut. Examiner les pics,
matériaux/draw calls, transparence, taille APK et dérive mémoire ; fixer les budgets artistiques
avec les premiers assets mesurés avant de multiplier textures et effets.

Démontrer trois modifications uniquement dans la présentation : changer une arène, permuter
un modèle et remplacer l'éclair. Fournir une courte fiche pour chacune et l'inventaire des
sources, auteurs, licences, versions et réglages d'import. Livrer l'APK identifié et les réserves
éventuelles avant de reprendre STEP-029 puis STEP-030.

## Règles communes d'intégration

- Le temps visuel des animations de combat et des effets suit le temps de jeu accepté,
  y compris pause et reprise Android. Aucun rattrapage du temps mural.
- Les pistes d'animation ne modifient pas les états du combat ; pas de méthode gameplay
  appelée depuis `AnimationPlayer`, un squelette, une particule ou une collision de mesh.
- La taille, l'arme et le déplacement d'un os ne changent jamais portée ou rayon logique.
- Le choix d'asset reste hors des profils de statistiques. Un profil visuel absent utilise
  un repli lisible, sans bloquer une action de jeu.
- Les effets sont bornés en nombre et durée. Pas d'accumulation d'événements en arrière-plan ;
  un événement ancien n'est pas rejoué tardivement. Aucun pool complexe avant besoin mesuré.
- La lumière, l'ombre, les textures et les effets sont évalués sur le Galaxy A16 avant
  généralisation. Les assets sources et les métadonnées d'import utiles restent versionnés.

## Décisions à prendre aux revues

La validation de cette roadmap fixe la séparation et l'ordre des étapes, avec Foudre comme
habillage de `special`. Les huit thèmes d'arène sont maintenant fournis ; la première revue
valide leur calage et leur cadrage, en commençant par Colisée solaire. La revue avant
GRAPHICS-003 confirme style, silhouette, équipement, source/licence des modèles et animation
compatible ; elle n'impose pas de choisir ces assets dès aujourd'hui. Chaque revue s'appuie sur
une galerie ou un APK concret. Toute évolution de règle de combat est identifiée séparément.
