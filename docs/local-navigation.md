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

# Navigation locale partagée — GAMEPLAY-002

Anne, Mako et les deux squelettes utilisent le même LocalNavigator dans PartyUnit.
Les dimensions sont conservées : rayon 0,35, diamètre 0,70, échelle des modèles 0,65.
Le navigateur reçoit une intention cible/portée et ne sélectionne jamais la cible.
La réduction des gabarits reste GAMEPLAY-003, après validation de cette étape.

## Fonctionnement

La direction directe est prioritaire lorsqu'elle est libre. Sinon AStarGrid2D cherche
un détour sur une petite grille 2D de 27 x 27 points, maille 0,20 unité, couvrant la petite
arène. Les autres corps vivants sont bloquants quelle que soit leur équipe. La cible
reste un obstacle ; les points d'arrivée sont des positions libres à portée, pas son centre.
Les disques sont légèrement élargis pour sécuriser les segments entre points de grille.
La marge des segments est 0,006, celle de la grille 0,025, en plus du diamètre de contact.

Les points de passage restent en cache. Chaque pas revalide et lisse les segments visibles,
avec préférence de côté et ordre stable, sans RNG. Le chemin est invalidé si la cible change,
se déplace de plus de 0,25, si la prochaine section est bloquée ou si le déplacement réellement
réalisé ne progresse pas. Le navigateur peut d'abord s'éloigner un peu pour sortir d'un contact.
Une voie fermée donne une attente stable et des essais espacés, puis reprend quand elle s'ouvre.

Budget : une recherche au maximum par pas de simulation, distribuée en rotation entre les
acteurs ; délai minimal de 0,35 s entre recherches d'un même acteur. Une recherche emploie
au maximum deux ancrages de départ et huit candidats d'arrivée (16 requêtes A* natives sur
une grille bornée à 729 points). Les déplacements directs et chemins conservés ne reconstruisent
pas la grille. Compteurs de recherches, échecs, durée et attente disponibles par acteur.

GroundCrowd reste l'autorité finale : ni traversée, téléportation ni poussée nouvelle.
L'observation de progression et l'état du mover utilisent le mouvement effectué après ce
solveur, pas la seule intention. L'ordre du solveur et ses règles de correction existantes
restent inchangés. L'arrêt à portée et pendant toute action reste prioritaire.

## Composition et temps

PartySimulation effectue les intentions, le routage, le contrôle de contact, puis engage
les actions à portée. Les règles, cibles offensives, coûts à la résolution, vitesses et
délais de compétence ne sont pas modifiés. Les trajectoires et la chronologie d'engagement
peuvent naturellement changer ; l'identité complète des anciens affrontements n'est pas
attendue. La couche graphique n'intervient dans aucune décision de trajet.

Le navigateur n'a pas de traitement indépendant : son temps suit les pas acceptés de jeu.
Pause, menus et arrière-plan le figent ; le premier tick de retour reste rejeté. Mort,
fin/replay et perte de cible éliminent les anciennes routes. Les nouveaux acteurs et les
nouvelles vagues héritent du composant commun. Aucun Node ni modèle n'est retenu par le
navigateur, seulement des positions, identifiants et points de passage.

`navigation_enabled=false` reste une option de comparaison de diagnostic. Les anciens
laboratoires Crowd/GroundMover gardent leur comportement historique sans pathfinding.
`navigation_obstacles` permet des disques statiques explicites dans les fixtures ; cette
liste est remise à zéro au Rejouer. Aucun obstacle n'est déduit des pixels du décor et
aucun décor bloquant n'est ajouté à Main par cette étape.

## Laboratoire et recette

F6 `scenes/debug/local_navigation_lab.tscn` : scénario suivant, choix Anne/Mako/Squelette A/B,
Rejouer et ouverture du passage. Les traces vertes montrent le trajet réellement parcouru,
les points bleus les étapes restantes ; les disques gris sont des obstacles de fixture.
Sept cas : un obstacle, écran de deux corps, croisement, anneau fermé puis ouvert, bordure,
cible mobile et contact contre un corps à la bordure. Le laboratoire utilise le vrai PartyUnit/PartySimulation._move ; il ne lance
pas de combat ni n'applique de dégâts. La sélection d'arène et la pause restent utilisables.

« Campagne » lance les 28 cas, puis un relevé du vrai Main avec ses deux héros et jusqu'à
six ennemis (5 s de chauffe, 20 s mesurées). Rapports et PNG : `user://gameplay002`.
L'export optionnel `python3 tools/export_navigation_lab.py --godot /chemin/godot --output /tmp/gameplay-002-lab-debug.apk`
utilise une copie temporaire, sans changer le point d'entrée du projet. Le laboratoire
porte le code Android 40 ; après installation d'une version plus récente, sa réinstallation
Debug exige `adb install -r -d`. Réinstaller ensuite l'APK normal code 41 sur Main.
Les règles sauvegardées du propriétaire ne sont pas écrites par le laboratoire.

F8 puis F5 pour observer les contournements en combat, sans modifier les gambits.
Vérifier des alliés/ennemis faisant écran, la cible mobile, l'arrêt au début d'attaque ou
incantation, la mort d'un bloqueur/cible, pause/menus/reprise et Rejouer. Un cercle réellement
fermé doit attendre : ne pas interpréter cette attente comme un échec quand aucune voie n'existe.

Les raccords de départ sont recherchés dans un rayon de 0,6 unité : segment direct, ou
au plus deux segments orthogonaux contrôlés séparément. Cela permet notamment de glisser
le long de la bordure lorsque le départ est déjà au contact d'un autre corps, avant de
rejoindre la grille en retrait. Deux départs restent retenus au maximum.

## Limites

La grille et les candidats sont volontairement bornés. Un passage très étroit, mal aligné
avec la maille, peut être considéré inaccessible par le détour alors que la voie directe
reste traitée géométriquement. Il n'y a pas de garantie de navigation globale sur des labyrinthes
arbitraires ni de résolution d'une cible physiquement enfermée. Cette limite ne permet jamais
une traversée : le solveur conserve son dernier contrôle. Les fixtures de cette livraison
réussissent avec les gabarits actuels ; GAMEPLAY-003 ne sert pas à masquer un échec de ces cas.
