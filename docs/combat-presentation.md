# Extension GRAPHICS-006 — Foudre

CombatPresenter compose désormais un adaptateur de Foudre pour ses préparations et ses
frappes, à partir de faits dédupliqués et d'instantanés artistiques. Voir lightning-presentation.md.
Les priorités, le soin et la séparation du gameplay restent ceux décrits ci-dessous.

# Extension GRAPHICS-005 — soin

CombatPresenter présente désormais les résolutions heal positives avec un effet local,
un montant réel, une scène remplaçable et une origine par modèle. Aucun changement des
priorités ci-dessous. Voir heal-presentation.md pour ce contrat et son cycle de vie.

# Présentation des actions — GRAPHICS-004, fix1 inclus

Les modèles lisent des valeurs de combat et des événements ; ils ne décident jamais d'un
impact, d'un coût, d'une portée ou de la durée logique d'une action. Les GLB restent intacts.
CharacterDefinition porte les noms de clips et leurs paramètres visuels remplaçables.

## Priorités demandées par le propriétaire

1. Mort : interrompt tout et ne peut pas être remplacée par un autre état.
2. Action active : Sword pour Attaque, Duck pour Soin/Foudre, récupération comprise.
3. Déplacement : Walk, qui interrompt immédiatement une réaction de bas niveau.
4. HitReact uniquement à l'arrêt, sans autre action.
5. Idle uniquement lorsque rien d'autre n'est actif.

Le contrat d'action courant est appliqué avant les coups reçus du tick. HitReact ne peut
alors modifier ni le lecteur ni le squelette d'une attaque, d'un sort ou d'un déplacement.
Un flash bref sur le modèle marque néanmoins un dégât réel. Une réaction interrompue est
abandonnée : elle ne reprend pas après l'action prioritaire.

| Présentation | Réglage actuel |
|---|---|
| Attaque | Sword natif ~0,833 s, contact du clip à 0,5 s calé sur l'impact logique à 0,6 s, fin sur les 0,4 s de récupération |
| Soin d'Anne | Duck, préparation 1,5 s puis récupération 0,4 s |
| Foudre de Mako | Duck, préparation 2 s puis récupération 0,4 s |
| Réaction libre | HitReact sur 0,26 s ; flash local de 0,10 s |
| Mort | Death sur 0,75 s, dernière pose maintenue 0,25 s, puis suppression |

Duck est raccordé dès GRAPHICS-004 sur demande explicite de priorité des sorts. Les étapes
GRAPHICS-005/006 ajouteront les effets de soin/Foudre. Le point de libération du clip Duck
(1,25 s dans le clip natif) est adapté aux durées logiques reçues ; il ne déclenche rien.
La mana reste débitée à l'effet réel selon GAMEPLAY-001-fix1, pas au début du geste.

Le sampler est manuel. Il ne conserve que les transformations osseuses ; pistes de méthodes,
de nœuds et de Root exclues. Les os non animés sont remis à leur pose de repos avant lecture.
Une marge visuelle de 100 microsecondes avant la fin évite l'arrêt automatique du lecteur
au seuil flottant de Godot ; si le lecteur s'est arrêté, il est réarmé même lorsque le nom
du clip en cache n'a pas changé. La dernière pose reste visuellement identique. Aucun de
ces réglages ne modifie le temps d'exécution du combat.

## Événements et nettoyage

PartyExecutor collecte start/resolve/end/cancel sous forme de valeurs, avec séquence par
acteur. La résolution est publiée après l'effet validé. PartySimulation ajoute run_id,
collecte les morts et publie un instantané copié à la lecture, sans référence d'acteur ou
d'exécuteur. Files bornées : 16 événements par exécuteur, 384 par frame de simulation.
Le nombre d'impacts de jeu conserve son calcul antérieur.

CombatPresenter consomme chaque tick : run_id obsolète ignoré, séquence déjà consommée
ignorée, réaction uniquement pour damage > 0. La vue reçoit aussi l'instantané exact de
l'action, ce qui empêche de la recaler sur une horloge d'animation indépendante.

Une mort libère l'enfant visuel de StatsActor. La vue est transférée sous CombatPresenter,
avec sa transformation, son profil visuel et un délai borné ; elle ne garde ni ActorState
ni unité logique. L'ennemi est retiré immédiatement de la simulation et de ses barres,
puis libéré même si l'animation graphique continue. Les héros KO gardent leur identité
logique pour le HUD, comme auparavant, et ne sont plus des cibles vivantes.
Maximum 12 vues de mort simultanées : les plus anciennes sont supprimées au-delà.

Une courte fin visuelle permet aux morts et à la dernière frappe de finir après victoire
ou défaite. Elle est bornée par les mêmes pas de 1/30 s maximum, respecte pause/focus et
rejette le premier tick revenu ; elle n'avance jamais l'horloge du combat arrêté.
Rejouer supprime immédiatement les anciens corps et les tables de déduplication.
characters_enabled=false garde la présentation nulle ; action_animations_enabled=false
permet de revenir aux poses de base sans changer la simulation.

## Recette et modification

F6 scenes/debug/action_lab.tscn : Attaque, Coup reçu et Mort ; C prévisualise Duck.
Anne/Mako et Squelette A/B changent les modèles. Repos/Marche change mouvement et
orientation ; Position vérifie cinq ancrages ; Pause fige la prévisualisation.
Le banc est purement visuel et n'exécute aucune action de combat.

F8 puis F5 pour le vrai combat. Les profils dans resources/presentation/characters
permettent de changer les clips, contacts, durées de réaction/mort et hauteur des barres.
Les durées du soin/Foudre viennent du jeu. Un profil absent conserve le mannequin ou
la présentation nulle ; aucune animation n'est nécessaire pour appliquer le gameplay.
