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

# Deux étapes de déplacement après GRAPHICS-007

Demande du propriétaire du 26 octobre 2026 : tous les participants, héros comme ennemis,
doivent partager un petit pathfinding de contournement ; ensuite seulement ils seront
rendus moins volumineux pour faciliter et accélérer leurs approches.
Ces deux étapes s'intercalent avant STEP-029 et STEP-030, sans changer leurs identifiants.
GAMEPLAY-002 est implémentée et en recette : voir steps/GAMEPLAY-002.md et local-navigation.md.
GAMEPLAY-003 reste planifiée, après sa validation/clôture. Les choix préparatoires suivent.

« Moins volumineux » est traité ici comme une réduction de l'emprise au sol et de la taille
visuelle. Le but est d'ouvrir les passages et de réduire les détours. La simplification du
nombre de polygones ou la compression des fichiers ne constituent pas cette deuxième étape.

## Constat actuel

GroundMover poursuit directement une cible. GroundCrowd applique ensuite une séparation
bornée et un balayage qui refuse les traversées. Ce solveur sait arrêter un déplacement,
mais ne cherche pas d'autre chemin. Dans PartySimulation, héros et ennemis partagent déjà
PartyUnit/Mover ; la correction de séparation est néanmoins différente selon l'équipe.
Un blocage peut donc concerner les alliés comme les ennemis.

Rayon logique commun actuel : 0,35 unité ; diamètre 0,70 ; marge de bord 0,35.
Échelle des quatre modèles : 0,65. La portée d'attaque de base est 1, celle des sorts 4.
Le disque logique, la portée et l'échelle du GLB sont des paramètres distincts.

## Ordre de livraison

| Étape | Objet | Condition pour passer à la suivante |
|---|---|---|
| GAMEPLAY-002 | Navigation locale et contournement partagés | Détours fonctionnels avec rayon 0,35 et échelle 0,65 inchangés |
| GAMEPLAY-003 | Gabarits plus petits | Réduction cohérente de l'emprise et des modèles, parcours plus fluides |
| STEP-029 | Clone/import/export/installation reproductibles | Les deux étapes de gameplay sont validées et clôturées |
| STEP-030 | Recette finale MVP | Version finale issue de ce nouveau périmètre |

Une étape, un APK, une recette et un commit distincts. La diminution des gabarits ne sert
pas à contourner un échec de la navigation. Les tests de blocage difficiles restent conservés.

## GAMEPLAY-002 — navigation locale commune

Ajouter un composant de navigation au sol partagé, composé avec le déplacement de PartyUnit.
Anne, Mako et les deux squelettes utilisent le même mécanisme et les mêmes règles de sécurité.
Le choix de cible reste la responsabilité des gambits/commandes ; le navigateur reçoit la
cible et la portée de l'action voulue. Il choisit comment s'en approcher, sans en choisir une
autre pour résoudre un blocage. Les modèles et animations ne pilotent pas les trajectoires.

La direction directe reste prioritaire lorsque le segment est libre. Lorsqu'elle est
obstruée, une recherche 2D courte et bornée produit quelques points de passage. Un petit A*
local est une option adaptée ; horizon, résolution et budget seront fixés dans l'implémentation
et mesurés sur A16. Le plan doit autoriser un éloignement temporaire de la cible pour contourner
un acteur, garder le côté de détour choisi et éviter les changements gauche/droite à chaque tick.

Les obstacles de jeu sont les empreintes des autres participants vivants et les limites de
l'arène. Un acteur immobile ou en action reste bloquant. La cible reste également un obstacle :
on cherche une position libre à portée, pas son centre. Une interface d'obstacles logiques
explicites permettra les fixtures de passage/couloir ; les murs dessinés dans les PNG ne
deviennent pas automatiquement des collisions. Aucun décor bloquant nouveau n'est livré.

Recalculer avec parcimonie : cible déplacée, chemin invalidé, obstacle déplacé/mort ou absence
de progression réellement constatée après le solveur de collision. Une simple intention
MOVING ne prouve pas que l'acteur avance. Mettre en cache les points de passage, échelonner
les recherches et limiter le travail par acteur et par tick ; ne pas relancer un calcul
complet pour tous les acteurs à chaque image.

GroundCrowd reste l'autorité finale pour les contacts : une route estimée libre ne permet
ni traversée, téléportation, poussée excessive ni sortie des limites. Une voie actuellement
inaccessible conduit à une attente stable, avec reprise quand elle se libère. La navigation
locale ne promet pas de résoudre une cible physiquement enfermée ou une route globale hors
horizon sans passage disponible.

Préserver l'arrêt à portée et pendant une action, la cible verrouillée de l'attaque/du sort,
les vitesses, les durées d'incantation, les coûts à la résolution et les priorités d'animation.
Pause, menus et arrière-plan figent aussi l'état du navigateur ; mort, changement de cible
et Rejouer invalident les anciens chemins. L'ordre stable des décisions doit rester reproductible.
Les déplacements changent la chronologie du combat : l'égalité totale avec les anciennes
trajectoires n'est pas un critère ; les contrats de combat et cas sans obstacle restent testés.

La livraison comprend un laboratoire F6 avec trajectoires/disques/points de passage,
plus la composition réelle Main sur Android. Les laboratoires historiques qui documentent
explicitement un déplacement sans pathfinding restent utilisables sans comportement ajouté
silencieusement ; le composant commun peut y être activé pour le nouveau banc.

Acceptation : détour d'un acteur fixe par chaque héros et chaque squelette ; deux alliés ou
deux ennemis faisant écran ; croisements et groupes mobiles ; bordure ; cible déplacée,
remplacée, morte ; anneau fermé puis ouvert ; attente stable sans passage ; arrivée sans
oscillation ni petits pas à portée ; pause/reprise et dix Rejouer. Les solutions sont vérifiées
à plusieurs pas de temps et sur A16 avec deux héros et jusqu'à six ennemis. Mesurer recalculs,
blocages et CPU, sans réintroduire un seuil FPS arbitraire.

## GAMEPLAY-003 — emprise et apparence réduites

Partir du contournement validé, puis réduire ensemble le rayon logique et l'échelle visuelle
des quatre profils. Point de départ proposé pour la recette : rayon 0,27 au lieu de 0,35,
échelle 0,50 au lieu de 0,65, soit environ 23 % de réduction linéaire. Ces valeurs sont des
candidates à évaluer ; le réglage final sera consigné avec l'APK de cette étape.

Le rayon logique est partagé par navigation, contacts, marges de bord, conditions de spawn
et repères de diagnostic. Éviter plusieurs valeurs indépendantes dans ces systèmes.
L'échelle graphique reste dans CharacterDefinition : changer un modèle ne change jamais
implicitement son rayon. Aucun nouveau maillage ni GLB retouché n'est nécessaire pour cette
réduction. Les éventuelles simplifications géométriques seront un chantier distinct.

Adapter les hauteurs/ancrages des barres et des effets de cast/soin/impact à la nouvelle
silhouette ; garder les barres et zones tactiles lisibles. Vérifier les armes et les poses
au contact. Préserver stats, vitesses, portées et règles de combat : le gain d'approche vient
de passages plus larges et de détours plus courts, sans accélération artificielle.

Rejouer les mêmes fixtures qu'en GAMEPLAY-002, avec un passage choisi pour être praticable
seulement par les nouveaux gabarits. Comparer temps d'arrivée, distance parcourue, durée de
blocage et nombre de recalculs sur des parcours identiques. Ne pas promettre un gain dans
chaque affrontement : la meilleure accessibilité peut aussi changer les engagements.
Vérifier absence de chevauchement/traversée, bornage, spawn, portée, stabilité à l'arrêt,
modèles/ombres/barres/effets et lisibilité des huit arènes sur le Galaxy.

## Limites conservées

Pas de navigation 3D, de navmesh calculé à partir des illustrations, de nouvelle sélection
IA, de déplacement manuel ni de nouveaux pouvoirs. Les deux étapes changent le mouvement
et le gabarit dans leur ordre explicite ; la couche de présentation reste remplaçable.
