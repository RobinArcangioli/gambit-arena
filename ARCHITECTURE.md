# Architecture réelle — STEP-024 v2 validée, commit en attente

Main conserve son UID et ouvre scenes/waves/wave_lab.tscn.
WaveLab étend ManualCommandLab et active simulation.wave_enabled avant le reset initial.
Les anciens laboratoires restent sur leur mode historique (wave_enabled false).
Aucun appel direct d'action n'est ajouté à l'interface ; la commande manuelle et les
règles continuent d'emprunter leur arbitrage et leur exécuteur partagés existants.

WaveSchedule est un RefCounted sans acteurs, Timer ou dépendance visuelle. reset borne
le total entre 1 et 100, et le plafond simultané entre 1 et 20. Par défaut : 12/6 ; mode
Charge : 24/20. issued compte uniquement les apparitions réellement réussies.
Le premier délai est 1 s ; après les apparitions du premier tiers, l'intervalle passe
de 2 à 1,5 s, puis à 1 s au dernier tiers. L'arène commence vide, sans victoire prématurée.
Le crédit n'avance qu'avec le dt borné de GameClock ; aucun temps système indépendant.
Il ne dépasse jamais un intervalle, même si la limite d'acteurs ou les bords sont occupés.

CombatSimulation.reset conserve le profil de chaque scénario, nettoie acteurs/actions/
commandes puis réinitialise le plan. En mode vague, budget vient du plan et aucune
apparition immédiate n'est effectuée. add_enemy applique la limite du plan et le contrôle
historique de distance/limites ; il confirme le plan seulement après création de l'acteur.
Le compteur spawned et wave.issued avancent ainsi ensemble. Les refus ne consomment rien.

Le coordinateur reste déterministe : prune/fin, horloge, intentions manuelles/gambits,
mouvement/séparation, actions engagées, prune/fin, nouveaux engagements, puis apparitions.
_advance_spawning choisit le plan de vague ou la branche historique inchangée.
Une échéance teste au plus 20 positions de bord existantes et crée au plus un ennemi.
Un échec conserve seulement une arrivée due ; un succès remet le crédit à zéro.
Les nouveaux acteurs ne bougent et n'attaquent pas avant le tick suivant.
Le plafond porte sur les acteurs présents ; les morts sont retirés avant l'admission.

Le résultat existant est réutilisé : aucune victoire tant que spawned < budget ; ensuite
VICTOIRE seulement si la liste est vide et removed == 0. Une suppression externe aboutit
à INTERROMPU, jamais à une fausse victoire. La mort du héros donne DEFAITE en priorité.
La fin arrête l'horloge, les actions et la commande manuelle. Pause et resets conservent
leurs garanties. Il s'agit d'une seule vague ; l'enchaînement appartient à STEP-025.
L'UI distingue vivants/plafond et arrivés/total ; vaincus et restant à venir sont dans
le détail défilable. Les valeurs de cadence sont des choix initiaux, non un équilibrage validé.

## FIX-STEP-023-001 / FIX-STEP-024-001 : routeur tactile v2

La v1 utilisait la propagation PASS et le scroll natif. Le retour F6 utilisateur montre
que cela ne suffit pas : les gestes injectés n'ont pas défilé et ont déclenché des erreurs.
La v2 ne déduit aucune réussite matérielle de cette première approche.

PortraitHudLab possède un TouchScrollRouter (Node). Son Callable fournit uniquement
les ScrollContainer actifs : formulaire si modal, sinon liste visible. SkillSlotsLab
ajoute la liste des compétences quand elle est visible. Aucun bouton extérieur à ces
zones n'est géré par le routeur. Les anciens laboratoires HUD bénéficient du même correctif.

_input prend possession des InputEventScreenTouch/ScreenDrag commençant dans une zone.
Le routeur garde un seul doigt, la zone, le bouton de départ, la position initiale dans
le repère local et la valeur de scroll. Au-delà de 12 pixels, le geste reste un swipe,
même s'il revient au point de départ. La valeur verticale est calculée depuis l'origine
et bornée au scrollbar, sans inertie. Un relâchement court n'active que le bouton de
départ encore visible, activable, sous le doigt et dans la même zone. L'état de geste
est libéré avant l'unique émission pressed, car ce callback peut ouvrir un formulaire.

Les événements tactiles capturés sont consommés avant le GUI natif. Leur copie souris
(device -1) est également consommée, y compris après un changement de modal au relâchement.
La souris physique et sa molette ne passent pas par ce chemin. Un second doigt annule
l'appui. Rejouer annule un geste en cours ; une notification d'arrière-plan oublie le
capture pour qu'un nouveau geste fonctionne au retour. Une annulation système, une zone
masquée/redimensionnée ou un bouton désactivé ne peut pas valider un appui.

Les filtres PASS de v1 restent compatibles avec le GUI souris. Aucun gestionnaire global
de déplacement, ni connexion pressed supplémentaire, ni changement de project.godot.
chosen est explicitement initialisé à null dans ManualCommands.nearest : seul changement
au ciblage, qui conserve la sélection du plus proche et le départage par identité.

Le banc tactile continue d'injecter les événements au viewport réel, sans appeler les
callbacks. Il ajoute annulation sans déplacement, second doigt, swipe inverse, reset
pendant un appui et retour d'arrière-plan. Les tests ne sont pas exécutés ici (Godot absent).
La vague, ses profils, son calendrier, son coordinateur et son banc restent identiques
à STEP-024 v1. Exécution des actions, animation et immobilité à portée inchangées.
