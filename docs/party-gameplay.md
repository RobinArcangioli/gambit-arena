# Équipe et compétences — GAMEPLAY-001

Main compose maintenant PartyApplication à partir du terrain commun. Le dernier écran
hérité est conservé dans scenes/debug/graphics003_reference.tscn : ses laboratoires et
mesures restent disponibles avec leur comportement historique. La nouvelle équipe a son
propre coordinateur, ses profils, ses règles et son HUD ; les modèles restent des vues.

## Choix de cette première version

| Paramètre | Anne | Mako | Squelettes |
|---|---|---|---|
| PV maximum | 140 | 180 | 60 |
| Attaque / défense | 12 / 3 | 18 / 4 | 8 / 1 |
| Vitesse au sol | 1,2 | 1,2 | 0,9 |
| Compétences | Attaque, Soin | Attaque, Foudre | Attaque |
| Mana maximum / régénération | 60 / 5 par seconde | 60 / 5 par seconde | 60 / 5 par seconde |

Les valeurs sont provisoires, sans nouvelle validation d'équilibrage. Le soin rend 30 PV,
coûte 20 mana et a un délai de 4 s ; Foudre coûte 30 mana, a un délai de 6 s et inflige
max(1, 2 × attaque − défense). Les deux sorts ont une portée de 4 unités au sol. L'attaque
reste à portée 1 avec préparation 0,6 s, récupération 0,4 s et dégâts attaque − défense
(minimum 1). Les sorts récupèrent pendant 0,4 s après leur résolution.

Le soin incante pendant 1,5 s, Foudre pendant 2 s. La mana est débitée une seule fois à la résolution réussie, après revalidation de la cible,
de la portée et de la réserve disponible. Une annulation avant l'effet ne coûte rien ;
un soin devenu inutile (PV pleins) ne coûte rien non plus. Le cooldown commence à
l'engagement accepté. La mana se
régénère aussi pendant une action, jamais pendant pause/arrêt. Une incantation ne déplace
pas le lanceur ; si la cible meurt, son état change ou elle sort de portée, l'effet ne se
produit pas. Le soin ne ressuscite pas et ne peut pas dépasser les PV maximum.

Anne soigne un membre vivant de son équipe, elle-même comprise. Son gambit initial priorise Allié PV <
50 % → Soin, puis Ennemi → Attaque. À 50 % exactement il ne déclenche pas. Mako priorise
Foudre sur un ennemi, puis Attaque. La troisième règle est disponible mais désactivée.
Une règle de soin garde la cible offensive en mémoire ; les deux intentions sont distinctes.
Le soin choisit le pourcentage de PV le plus bas parmi les membres satisfaisant la règle,
Anne comprise ; égalité départagée par distance puis identité stable. Le ciblage offensif
conserve la sélection du plus proche, puis l'identité stable en cas d'égalité.

Les ennemis acquièrent le héros vivant le plus proche et conservent une cible offensive
vivante à portée ; ils réévaluent après sa perte ou hors portée. Une mort alliée laisse
l'autre héros continuer ; la défaite est déclarée quand les deux sont morts. Trois vagues
de 12 ennemis, maximum 6 simultanés, gardent la structure du prototype. Le preset par défaut
n'est pas une démonstration de victoire garantie ; l'équilibrage de l'équipe reste à
ajuster avec le propriétaire. Le relevé de 35,08 s de la première livraison précède fix1
et ne décrit pas le correctif.

## Interface et commandes

Les onglets Anne/Mako sélectionnent le héros dont on consulte les PV, la mana, les
compétences et les trois gambits. Un appui de compétence crée une commande pour ce héros,
traitée au prochain tick : elle attend au maximum 3 s de jeu, peut remplacer sa commande
précédente, et ne coupe pas une action déjà engagée. Le soin manuel choisit aussi le plus faible pourcentage de PV parmi les membres blessés,
Anne comprise, sans imposer le seuil du gambit ; Attaque/Foudre visent un ennemi proche, avec conservation
du focus offensif à portée. Refus et expiration ne paient aucun nouveau coût.

Les listes défilent au doigt ou à la souris ; un swipe depuis une carte ne l'active pas.
L'édition de règles, l'import du preset historique et le choix d'arène mettent en pause.
Fermer leur fenêtre laisse la reprise explicite. Rejouer conserve les règles et l'arène.
Une perte de focus Android impose une reprise explicite et rejette le premier pas revenu.

Les barres au-dessus de chaque héros et ennemi sont rouges pour la vie, bleues pour la
mana, puis jaune or uniquement pendant l'incantation. La dernière se remplit selon le
même temps de jeu que l'exécuteur et disparaît à la résolution/annulation. Les dimensions,
les couleurs et l'espacement sont dans OverheadBars ; la hauteur d'ancrage dans le profil
visuel. Aucun contrôle de barre ne capture le toucher. Le petit point or indique le héros
sélectionné. La lecture numérique détaillée est disponible dans le HUD du héros sélectionné.

## Architecture et sauvegarde

- data/party : profils logiques, sans références artistiques.
- PartyUnit : état individuel, mover et exécuteur ; hérite de StatsActor, pas d'un modèle.
- PartyExecutor : propriétaire des coûts, délais, incantation et résolution unique.
- PartyRules : évaluation de valeurs détachées et validation propre à chaque personnage.
- PartySimulation : une horloge commune, ordre Anne/Mako/ennemis, séparation, vagues et fin.
- PartyApplication : composition des modèles, barres, entrées, catalogue et écran portrait.

AttackAction expose trois méthodes surchargeables de portée/préparation/récupération ;
leurs valeurs par défaut conservent les anciens tests. Aucun clip ne déclenche un impact.
Les événements de résolution sont des valeurs bornées au tick (run/action/source/cible,
résultat, positions, soin/dégâts), préparées pour les étapes graphiques suivantes.

Les règles sont sauvegardées dans user://party_rules_v2.json avec schéma version 2.
Fix1 conserve le même fichier et les personnalisations existantes : la cible `ally` inclut
maintenant le lanceur. Le chargement ne nécessite ni réinitialisation ni réimport du preset.
Les données invalides ou d'une autre version ne sont pas chargées. Le bouton « Importer
le preset historique » présente les conversions, puis exige un appui explicite : Speciale
→ Foudre pour Mako, soin personnel → soin d'équipe (soi inclus) pour Anne ; les règles incompatibles sont
désactivées. Il importe le preset de l'ancien laboratoire, qui ne possédait pas de sauvegarde
persistante ; il ne prétend pas récupérer une ancienne configuration personnelle.

Les modèles ne déterminent jamais les compétences. Une comparaison de 900 ticks de Main
avec modèles, mannequins et sans vue donne les mêmes états et couvre réellement Soin/Foudre.
Les gestes Duck et les effets de soin/Foudre restent GRAPHICS-005/006 ; les gestes de frappe,
réaction et mort restent GRAPHICS-004. Cette étape affiche encore Idle/Walk pendant le combat.
