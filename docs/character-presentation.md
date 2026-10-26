# Présentation des personnages — GRAPHICS-003

`StatsActor` est un Node3D logique contenant ActorState. Son enfant `Presentation` est
une vue facultative : CharacterView pour un profil valide, ProxyActor comme mannequin
si le profil manque ou est incompatible, aucun enfant si la présentation est désactivée.
Les accesseurs de jambes sont conservés pour les diagnostics historiques du mannequin.
CombatUnit conserve place/pose/present, son mover et son exécuteur.

Les quatre CharacterDefinition dans resources/presentation/characters choisissent un
GLB et ses noms exacts de clips. Elles portent échelle, décalage local, orientation,
vitesse de lecture et hauteur d'ancrage future ; aucune statistique ou compétence.
Les modèles utilisent une enveloppe à l'échelle 0,65, pivot au sol et avant visuel +Z.
Les pieds et orientations ont été examinés en fenêtre, dont un cadrage rapproché.
Les sources ont des transformations internes non unitaires : ne pas modifier le rig importé.
Les sockets d'armes ne sont pas extraits dans cette étape ; les armes embarquées suivent
les ancrages du modèle d'origine.

CharacterView conserve uniquement Idle et Walk dans ses bibliothèques locales. Les clips
sources restent intacts dans le GLB. Les pistes exécutables, les transformations de nœuds
et les pistes du joint Root sont exclues ; les transformations osseuses utiles sont lues
avec AnimationPlayer en mode manuel. Aucun callback d'animation ne pilote le jeu.
Idle tourne à sa durée native de 1 s ; Walk à 1 s par cycle. L'orientation dépend de la
direction logique. Le clip repart à zéro au changement repos/marche. Pas de root motion,
de mélange ou de locomotion procédurale ajoutée au personnage importé.

ArenaApplicationLab compose les profils sur les acteurs existants et futurs via le monde.
Son tick fournit seulement le temps effectivement accepté par l'horloge de simulation ;
la pause, l'arrêt et le premier tick rejeté au retour Android n'avancent pas les animations.
CombatSimulation, les exécuteurs, les profils de statistiques et les règles n'ont pas changé.

## Modifier une apparence

Dans la scène active, changer hero_appearance / enemy_appearance d'ArenaApplicationLab,
ou remplacer les références de modèle/clips de la CharacterDefinition. Appeler
refresh_characters() pour appliquer un changement en cours de session. Un profil nul
sélectionne le mannequin ; characters_enabled=false retire la vue. Rejouer conserve
ces choix dans la session. Anne et la variante squelette avec crâne sont les défauts.

## Recette

F6 : scenes/debug/character_lab.tscn. Anne/Mako et les deux squelettes se permutent avec
les boutons du bas. Le bouton Repos/Marche alterne la locomotion et avance parmi huit
orientations ; Position explore les cinq placements ; Pause fige les clips. Le catalogue
d'arènes et la grille restent accessibles. La marche de galerie est volontairement en place.
F8 entre les bancs, puis F5 pour le combat avec Anne et les ennemis squelettes.

La scène scenes/tests/character_presentation_tests.tscn compare 900 ticks avec les deux
paires de modèles, le mannequin et la vue absente ; elle vérifie aussi le repli, le
remplacement répété, les Rejouer et la pause. Les tests de comptage des anciens labs
comptent désormais StatsActor, car le mannequin n'est plus la classe de l'acteur logique.
Les attaques utilisent encore Idle dans cette étape ; les gestes d'action suivent dans
GRAPHICS-004/005/006. L'équipe de deux héros et ses règles arrivent dans GAMEPLAY-001.
