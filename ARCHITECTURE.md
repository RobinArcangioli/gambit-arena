# Architecture réelle — STEP-022 validée, commit en attente

Main conserve son UID et ouvre scenes/ui/skill_slots_lab.tscn.
SkillSlotsLab étend PortraitHudLab sans modifier ses fichiers. Deux onglets partagent
le pied de page : règles et compétences. Les six contrôles réservés historiques sont
réutilisés, déplacés dans un contenu défilable ; aucun deuxième jeu de six boutons créé.
Les trois premières cartes ont un seul callback de consultation ; les trois dernières
sont désactivées et n'ont aucun callback. Le bouton ne demande jamais d'action.

SkillAvailability décrit six entrées à partir d'un GambitSnapshot, sans référence
persistante à des acteurs. Trois compétences fixes utilisent les constantes de coût,
cooldown et portée de SkillExecutor. Les trois entrées réservées restent inactives.
La validation du snapshot précède toute lecture. Les sorties sont nouvelles à chaque
appel ; aucun snapshot, acteur, état, journal ou exécuteur n'est modifié.

Priorité d'affichage : entrée invalide, héros mort, combat terminé, pause, action occupée,
cooldown, soin inutile, énergie insuffisante, cible absente/hors portée, prêt.
Pour les attaques, l'ennemi vivant le plus proche est utilisé ; égalité départagée par
ID stable. Le soin vise soi-même. Cela décrit la disponibilité immédiate indépendamment
des conditions et priorités des gambits ; cela ne réserve aucune cible pour STEP-023.
L'exécuteur reste la seule autorité d'exécution. Les futurs clics devront revalider.

L'adaptation utilise Capture.capture. Comme celui-ci omet les sources mortes pour la
planification, la vue de présentation fournit leurs valeurs scalaires pour afficher
Mort au lieu d'une erreur générique. La copie ne conserve aucune référence d'acteur.
Les délais restants sont arrondis vers le haut au dixième pour éviter un 0.0 prématuré.
Le coût et le cooldown nominal sont disponibles dans le détail de la carte sélectionnée.
La consultation fonctionne en pause et après fin ; elle ne reprend pas le combat.

Les onglets restent hors défilement et sont bloqués par le formulaire modal. Les hauteurs
de cartes et de contenu tiennent compte des minimums réels ; le bas est accessible par
scroll. La vue et la sélection survivent à Rejouer/scénario, comme la configuration.
Aucun état de consultation n'est sauvegardé sur disque. Les anciennes scènes restent intactes.

Tous les fichiers de combat, compétences, actions, animation, mouvement, horloge,
évaluation, contrôle, édition et HUD STEP-021 sont identiques à la base vérifiée.
Le banc teste les états, seuils de coût/portée, pureté, lecture, pause, défilement et un
combat identique à STEP-021 malgré les consultations répétées. Godot non exécuté ici.
Version 0.1.0-step022, code 21. Pas de commande manuelle ni de file d'attente ajoutée.
