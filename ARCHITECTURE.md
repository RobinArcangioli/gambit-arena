# Architecture réelle — STEP-027

Main conserve son UID et ouvre scenes/platform/application_lab.tscn.
ApplicationLab étend RunLifecycleLab et porte la politique de retour au premier plan.
RunLifecycleLab étend WaveSequenceLab et ajoute la présentation du bilan terminal.
WaveSequenceLab étend WaveLab, lui-même dérivé de ManualCommandLab. Le nouveau lab active
sequence_enabled ; WaveLab active wave_enabled et conserve seul une vague historique.

CombatSimulation reste le seul coordinateur : prune/fin-transition, horloge, intentions,
mouvement/séparation, actions engagées, prune/fin-transition, engagements puis apparitions.
Le plan WaveSchedule conserve ses bornes, ses cadences 1 puis 2/1,5/1 secondes et son crédit
limité à une arrivée. Les nouvelles vagues ne recréent ni héros ni exécuteur.
Les compteurs globaux persistent ; les compteurs locaux se calculent à partir de bases
mémorisées à la transition. Les serials sont uniques dans une partie. Aucune interface
ne déclenche directement une action ; l’arbitrage manuel/gambits reste inchangé.

Voir docs/wave-sequence.md pour les conditions de transition, invariants et cas terminaux.
La défaite précède la transition, une suppression externe interdit la victoire, et seule
la troisième fin réussie arrête la partie gagnée. Rejouer seul réinitialise tout le combat.
Le nouveau banc couvre le coordinateur réel ; les bancs historiques restent inchangés.

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
Le routeur tactile reste identique à la STEP-024 v2 validée. Exécution des actions,
animation et immobilité à portée inchangées.

## STEP-025-fix1 — Mémoire de cible indépendante des intentions

CombatUnit conserve une référence de cible offensive et les identités ActorState
du héros et de la cible. focused_enemy invalide une cible morte, supprimée, absente
du combat, dont l’état a changé ou à une distance strictement supérieure à REACH (1).
La borne exacte de portée reste verrouillée. Une nouvelle instance au replay repart sans cible.
Controller.plan limite les ennemis du snapshot à cette cible tant qu’elle est valide.
L’évaluateur pur et sa priorité des règles restent inchangés : un soin peut viser le héros,
et une règle devenue inapplicable ne permet pas de contourner le verrou sur un autre ennemi.
Le contrôleur mémorise la cible offensive choisie, indépendamment de _forget/stop et
de la fin d’une action. ManualCommands.submit réutilise ce même verrou avant nearest,
et mémorise la cible d’une commande offensive acceptée. Un clic rejeté ne la remplace pas.
Une action engagée conserve toujours son propre verrou d’exécution. Aucun cooldown, coût,
animation, déplacement ni seuil de portée n’est modifié. La disparition/réinitialisation
d’un acteur invalide les références pour éviter de conserver une ancienne identité.

STEP-025 avec fix1 validée le 25 octobre 2026 : F6, tests manuels et fluidité OK.
APK fix1 : a05863ca35183215d53c270652a0a1927da4e74c8547fcf32112f6a42e97544a. Commit et sauvegarde en attente.

## Fin unique et cycle de partie — STEP-026

CombatSimulation._finish_if_needed garde les conditions existantes et délègue la fin
à _end_run. Cette méthode est idempotente : résultat terminal, horloge arrêtée, actions
retirées, mouvements et cibles oubliés, commande annulée, puis bilan scalaire figé.
final_report renvoie une copie profonde, jamais un dictionnaire mutable partagé.
Le dernier impact létal est compté avant le bilan. Aucune notification de mort ne
réinitialise la simulation au milieu du calcul d’un impact.

advance observe aussi une mort déjà survenue avant le filtre de pause : la défaite
est consignée au prochain appel, sans avancer le temps. Le jeu ne peut pas produire
de nouveaux dégâts en pause ; ce chemin couvre les modifications externes de cycle de vie.
clear arrête l’horloge et retire chaque exécuteur, mouvement et cible avant queue_free.
_exit_tree appelle clear, même si le monde des acteurs appartient à une autre branche.
reset crée un nouvel acteur et état, réinitialise les compteurs, traces, commande, vagues
et bilan, conserve les règles et la pause. run_id est un compteur de diagnostic monotone ;
terminal_count vaut zéro puis un par partie. Aucun de ces champs ne pilote les actions.

RunLifecycleLab réutilise le panneau de statut et les détails existants. Le résultat
terminal a priorité visuelle sur PAUSE. Aucun modal ne bloque Rejouer ou l’éditeur.
Le bilan est effacé par reset ; le bandeau normal reprend alors son affichage habituel.

STEP-026 validée le 25 octobre 2026 : F6, tests manuels et fluidité OK.
Retour global sans mesure chiffrée ; commit et sauvegarde en attente.
APK : 1c6e699d3acf44a6f3e5ce6e85d333ac9bb60c14e946a548992bd5eb099a47a2.

## ApplicationGuard — STEP-027

Le nouveau Node est ajouté en dernier enfant après la construction du HUD : son _input
précède le routeur tactile selon le parcours inverse en profondeur de Godot. Il ne
déclenche aucune action. Il consomme les entrées pendant suspended ou !focused et les
relâchements/drags sans nouvel appui correspondant. Les pressions souris physiques et
émulées sont distinguées par device ; la molette n’est pas filtrée au premier plan.

ApplicationLab reçoit les notifications avec observe ; _notification ne rappelle pas
super, puisque Godot distribue cette méthode à chaque classe de la chaîne. Le parent
Arena garde son comportement historique. À la perte, le nouveau lab impose la pause,
oublie les gestes du routeur, et bloque Reprendre/Rejouer. Deux indicateurs distincts
attendent leurs notifications de retour respectives, dans n’importe quel ordre.

Le retour conserve paused et recalcule le layout. Un nouveau clic Reprendre peut lever
la pause seulement au premier plan et hors formulaire. Le prochain _physics_process
actif ignore son delta une seule fois. Aucun temps système, timer séparé ou rattrapage
n’est introduit. La simulation, les exécuteurs et tous les laboratoires historiques
restent inchangés. Détails, tests et limites : docs/application-lifecycle.md.

STEP-027 validée le 26 octobre 2026 : F6, tests manuels et fluidité OK.
Retour global sans mesure chiffrée ; commit et sauvegarde en attente.
APK : 07467efcfb7e663e363e6f6fc61644fd2bf2889e7ee3a3001d42589e0c6cf611.
