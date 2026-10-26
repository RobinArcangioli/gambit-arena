# Présentation de Foudre — GRAPHICS-006

Foudre conserve son geste Duck et son incantation logique de 2 s. Sa présentation ajoute
une lueur de préparation sur le lanceur et un repère discret sous la cible, puis un éclair
qui descend du ciel à la résolution réelle. Le cœur blanc bleuté, trois ramifications cyan,
le glow diffus, un anneau d'impact et neuf étincelles restent locaux à la frappe.
Le trait principal est rapide (0,26 s), avec une seconde impulsion plus faible ; l'ensemble
disparaît en 0,52 s. La frappe apparaît dès son premier échantillon et se révèle du haut
vers le bas en 25 ms. Les dégâts sont déjà appliqués lorsque ce geste visuel commence.

## Ressources remplaçables

`resources/presentation/effects/lightning.tres` porte deux PackedScene (préparation et
frappe), les couleurs, la hauteur du ciel (4,5 unités), la largeur du glow, les durées
visuelles et la hauteur/rayon d'impact. Modifier les scènes change l'esthétique du sort.
Les délais, dégâts, mana, cooldowns et cibles ne sont pas définis dans cette ressource.

La scène de préparation fournit `setup(profile)`, `set_anchors(source, target, progress)`
et `advance_visual(dt)`. La frappe fournit `setup(profile, visual_seed)` et
`advance_visual(dt)`. Toutes deux sont des Node3D passifs ; aucune méthode de combat ni
callback d'animation n'est appelé. Une scène absente ou sans ce contrat est ignorée.
`CharacterDefinition.lightning_cast_origin` place la lueur de préparation dans le repère
orienté du modèle, en unités de monde ; valeur par défaut (0, 0,7, 0).

Le shader spatial local dessine le glow par une chute douce d'opacité autour du cœur.
Il est unshaded avec mélange additif, sans TIME, lumière dynamique, ombre ou post-traitement
global. Il fonctionne avec le renderer Compatibility utilisé par le prototype Android.
Les couleurs et l'opacité sont animées uniquement avec le temps accepté fourni par le jeu.

## Synchronisation et cycle de vie

CombatPresenter transmet à LightningPresenter les événements dédupliqués et des instantanés
artistiques : positions, orientation, profil, vue et valeurs de l'action courante. Aucune
référence à PartyUnit, ActorState ou PartyExecutor n'est conservée dans les effets.
La préparation suit les positions et la progression réelle de l'action ; sortie de cast,
annulation, fin ou mort de l'un des participants la supprime immédiatement.

Seul `resolve`, `skill=lightning`, `damage>0` crée la frappe. Elle utilise la position de
résolution capturée, même si la cible meurt ou est libérée dans ce tick. Une résolution
hors portée ou sans mana ne produit aucun succès. Les commandes manuelles et gambits
passent par ce même contrat. Aucune sélection de cible ou dépense supplémentaire.

Les effets se figent en pause, dans les menus et en arrière-plan. Le premier tick de retour
est rejeté et la reprise reste explicite. La fin visuelle terminale existante termine une
frappe sans avancer l'horloge logique. Rejouer, désactivation et fermeture de scène nettoient
tout ; les événements d'une ancienne partie sont ignorés.

Budget : au maximum quatre préparations (deux quads chacune) et huit frappes. Une frappe
regroupe ses branches en un ArrayMesh, ses étincelles en un second et emploie deux quads
pour l'impact : quatre surfaces, environ 206 sommets, sans textures externes. Les chemins
utilisent un RandomNumberGenerator local, déterministe selon l'action ; le RNG global du
jeu n'est jamais consommé. Le plus ancien effet est retiré si son plafond est atteint.

## Recette

F6 `scenes/debug/lightning_lab.tscn`, « Foudre (demo) » : Mako incante puis la frappe tombe
sur le squelette. « Annuler » retire la préparation et l'effet ; Pause les fige. Les PV et
la mana ne changent pas dans la galerie. F8 puis F5 pour le vrai combat.
Observer Foudre sur une cible vivante puis sur un coup fatal ; vérifier préparation,
frappe rapide et glow, pause/reprise, menus et Rejouer. Les priorités de GRAPHICS-004 et
l'effet de soin de GRAPHICS-005 restent actifs. Foudre coûte toujours 30, avec cooldown
6 s, portée 4 et dégâts max(1, 2*attaque-défense).
