# GRAPHICS-004 — transitions et vues d'action

PartyExecutor publie des faits de transition, PartySimulation les copie avec run_id et
collecte les morts. CombatPresenter applique l'instantané d'action avant les réactions,
consomme une seule fois les faits et transfère uniquement la vue graphique lors d'une mort.
CharacterView échantillonne les clips manuellement avec priorité explicite ; aucune piste
ne rappelle le jeu. La fin visuelle terminale respecte pause/focus sans avancer le combat.
Voir docs/combat-presentation.md. Les paragraphes suivants sont historiques.

# GAMEPLAY-001-fix1

PartyRules inclut la source dans les candidats du soin et partage prefer_heal avec les
commandes manuelles (ratio de PV, puis distance et identité). PartyExecutor ne débite plus
à request : le débit est dans _apply_effect après les gardes d'AttackAction, avant les
signaux de santé. La résolution est déjà verrouillée, ce qui interdit un double débit.
Voir docs/steps/GAMEPLAY-001-fix1.md ; les conventions antérieures ci-dessous sont historiques.

# GAMEPLAY-001 — équipe, exécuteurs et HUD composés

Main instancie PartyApplication, qui compose PartySimulation, PartyUnit, PartyExecutor,
PartyRules et OverheadBars. Les profils de combat sont séparés des CharacterDefinition.
La simulation détient incantation, mana, effets et cibles ; les barres ne lisent que des
valeurs. AttackAction expose portée/préparation/récupération surchargeables, avec ses
valeurs historiques par défaut. Voir [l'architecture d'équipe](docs/party-gameplay.md).
L'ancienne composition ArenaApplicationLab reste dans graphics003_reference.tscn pour
les régressions et le banc de mesure historique. Les sections suivantes sont historiques.

# Actualisation — GRAPHICS-003 en recette

StatsActor est désormais Node3D avec une vue enfant facultative. CharacterDefinition décrit
l'art ; CharacterView lit Idle/Walk en mode manuel. ArenaApplicationLab compose les profils
et transmet le temps de simulation accepté. Le mannequin reste un repli et la vue nulle
est testée. Voir [la présentation des personnages](docs/character-presentation.md).
Les paragraphes suivants décrivent les étapes précédentes ; la mention d'un héritage
StatsActor/ProxyActor à extraire est remplacée par cette implémentation.

# Architecture actuelle — GRAPHICS-002 validée

ArenaApplicationLab → PerformanceLab → ApplicationLab est maintenant le sommet de la chaîne
de Main. La couche de composition connaît ArenaCatalog et ArenaPicker ; la simulation ne
connaît ni le catalogue ni les fichiers artistiques. Le sélecteur modal réutilise le routeur
tactile et le garde Android, remet le jeu en pause et remplace seulement la vue ArenaFloor.
Les grandes textures se chargent à la sélection ; le menu utilise huit vignettes distinctes.
La galerie sans combat partage le même catalogue et le même composant de sélection.

Depuis la base STEP-028 / 580ce64, ArenaFloor est une façade de présentation possédant une
ArenaView interchangeable. La Resource exportée `Arena.arena_definition` choisit la scène
de fond : Main utilise Colisée solaire, les anciens labs gardent la référence procédurale.
La vue reçoit seulement caméra et taille de viewport ; elle ne possède aucune référence à la
simulation. Le dessin des repères/pieds reste dans ArenaFloor, au-dessus de la vue et sous
le rendu 3D. La caméra, les dimensions jouables et les exécuteurs sont inchangés.
Voir docs/arena-presentation.md. La séparation des modèles de personnages est prévue dans
GRAPHICS-003 ; leur héritage actuel n'est pas encore refactorisé.

Référence : `665c0c8d86a6400f88c77773295ed06b1a518206`. Cette synthèse de passation remplace
les formulations de livraison des étapes précédentes. STEP-028 ajoute la couche de mesure
décrite ci-dessous, sur la base documentaire cc91c79.

## Scène d’entrée et héritage UI

project.godot lance scenes/main.tscn (UID conservé), qui instancie
scenes/performance/performance_lab.tscn. Chaîne des scripts :

PerformanceLab → ApplicationLab → RunLifecycleLab → WaveSequenceLab → WaveLab → ManualCommandLab →
SkillSlotsLab → PortraitHudLab → GambitFieldsLab → GambitEditorLab → BattleLab → Arena.

Les couches parent construisent l’arène et le HUD, les couches dérivées ajoutent leurs
fonctions. Beaucoup de méthodes sont virtuelles et appelées pendant le _ready parent :
respecter setup_complete/editor_ready/hud_ready/slots_ready/manual_ready et les contrôles
is_node_ready. Les laboratoires historiques peuvent être lancés seuls par F6.

Arena possède le SubViewport 3D, caméra, mannequins initiaux, lumières et HUD. BattleLab
remplace les mannequins par la simulation. Le parent graphique du monde n’est pas forcément
le coordinateur ; ce dernier nettoie donc les acteurs dans _exit_tree.
Les constantes de modes des anciens labs ne doivent pas être confondues avec les libellés
actuels des trois vagues.

## Simulation et données

| Composant | Responsabilité / fichier |
|---|---|
| CombatSimulation | Seul coordinateur des ticks, acteurs, arrivées, transitions et fins ; scripts/combat/combat_simulation.gd |
| GameClock | Temps de jeu, pause/stopped, dt borné ; scripts/core/game_clock.gd |
| ActorProfile / ActorState | Resource de configuration puis état indépendant d’acteur ; scripts/combat/ |
| CombatUnit | Mover, exécuteur, identité, mémoire de cible offensive, présentation |
| GroundMover / GroundCrowd | Approche de la cible fournie et séparation déterministe bornée ; scripts/movement/ et scripts/crowd/ |
| AttackAction | Identité, préparation/récupération, latch d’impact, portée et annulations |
| SkillExecutor | Coûts, cooldowns, ressource et effets uniques ; scripts/skills/skill_executor.gd |
| GambitSnapshot / Evaluator | Valeurs capturées et évaluation pure sans effet ; scripts/gambits/ |
| GambitController | Intentions 10 Hz, revalidation et engagement via exécuteur |
| ManualCommands | Une attente de 3 s, remplacement/revalidation/priorité ; scripts/manual/manual_commands.gd |
| WaveSchedule | Calendrier d’arrivées borné sans acteurs ; scripts/waves/wave_schedule.gd |

Ordre du tick : observer une éventuelle mort préalable ; filtres pause/temps ; prune et
fin/transition ; horloge ; intention manuelle sinon gambits ; cibles ennemies ; mouvement
et séparation ; actions engagées (héros puis ennemis stables) ; prune et fin/transition ;
engagement manuel sinon automatique ; nouveaux engagements ennemis ; arrivées ; présentation.
Un nouvel acteur ou une action nouvellement engagée ne reçoit pas rétroactivement le dt.
Le héros ne marche pas si son action est active ou si sa cible sélectionnée vit à portée.

La cible offensive de CombatUnit est indépendante du mouvement et de l’intention du moment.
focused_enemy valide source/état, cible/état, appartenance au combat et portée. Le contrôleur
restreint le snapshot à cette cible ; ManualCommands la préfère à nearest. Un soin ne l’efface
pas. La mémoire est nettoyée à la fin/replay, sans changer le comportement en combat.

## Coûts et annulations

SkillExecutor est le seul point d’engagement. Le débit précède l’exécution et n’est pas
répété à l’impact. AttackAction ne peut appliquer son effet qu’une fois pour action_id.
Les signaux de mort/sortie et identités ActorState invalident les participants périmés.
retire annule définitivement un ancien exécuteur ; il ne peut pas affecter une nouvelle partie.
Une action payée annulée ne récupère pas automatiquement son coût. Pas de résurrection par soin.

ManualCommands.submit mémorise source/cible/états et deadline GameClock. Une commande
invalide n’écrase pas une attente valide. Busy/cooldown/énergie/soin inutile/approche peuvent
attendre jusqu’à expiration. La mort/sortie invalide les références et les connexions sont
nettoyées. Une file prioritaire n’interrompt jamais l’action engagée.

## Vagues et fins

wave_enabled préserve les anciens laboratoires ; sequence_enabled active trois vagues.
Normal/Soin : quota 12 par vague, cap 6 ; Charge : quota 24, cap 20.
WaveSchedule ne confirme issued qu’après une création réussie. Saturation/bord occupé ne
consomment pas le budget et ne stockent qu’une arrivée due, jamais une rafale.

spawned, defeated et removed sont cumulés sur la partie ; wave.issued est local à la vague.
Après prune : spawned = defeated + removed + vivants. Des bases mémorisées calculent les
vaincus/retirés locaux. Serial d’ennemi est global à la partie. completed_waves contient au
plus trois instantanés scalaires. La transition remet seulement le calendrier local à zéro,
conserve le héros et réapplique le délai initial d’une seconde.

La défaite précède la transition/victoire. Une suppression externe entraîne INTERROMPU
à la fin de vague, pas une victoire. _end_run est unique : horloge arrêtée, actions retirées,
cibles/commandes annulées puis bilan figé. final_report renvoie une copie de valeurs.
run_id et terminal_count servent aux diagnostics. Rejouer recrée acteurs/états, efface
compteurs, vagues, traces et bilan ; garde règles et pause. clear/_exit_tree assurent le nettoyage.

## Interface, scroll et application

PortraitHudLab calcule les zones sûres via HudLayout, réorganise status/arène/footer/modal
et utilise des ScrollContainer dont la hauteur de contenu est explicite. Les hauteurs
minimales réelles des contrôles doivent être respectées. L’éditeur ouvre la pause et ne
reprend pas automatiquement en fermant ; son brouillon n’est appliqué qu’explicitement.
SkillAvailability décrit la disponibilité sans effet ; ManualCommandLab active les commandes.

TouchScrollRouter possède les séquences tactiles commençant dans une liste active.
Au-delà de 12 pixels logiques, le geste reste un swipe. Appui court valide : une émission
pressed au relâchement. La copie souris device -1 est consommée ; souris physique/molette
restent natives. Multi-touch, annulation, zone invalide, replay et arrière-plan annulent l’appui.

ApplicationGuard est ajouté en dernier pour recevoir _input avant le routeur/GUI. Il suit
focus et suspension séparément, bloque les entrées pendant l’absence, et refuse les drags/
relâchements/répétitions sans nouvel appui. ApplicationLab force la pause, annule les gestes,
recalcule le layout au retour et attend Reprendre. Le premier pas actif après cette reprise
est écarté ; ensuite GameClock reprend sans temps mural. Un formulaire et un bilan terminal
conservent leurs garanties. _notification est distribué par Godot aux classes de l’héritage :
ne pas rajouter super._notification, qui dupliquerait le traitement.

## Documentation détaillée et points d’entrée

PerformanceLab délègue le jeu ordinaire à ApplicationLab. Une capture explicite utilise
PerformanceCapture, RefCounted à valeurs scalaires, horloge monotone indépendante de GameClock,
buffers bornés et export JSON après arrêt. BattleLab possède un chronométrage optionnel autour
de simulation.advance ; aucune règle de simulation n'y est modifiée. Le tick complet est mesuré
par la couche dérivée. Les coûts incluent respectivement la présentation des acteurs et le HUD.
Les temps GPU et la présentation physique de l'écran ne sont pas mesurés.

Le menu de diagnostic utilise les zones sûres, un ScrollContainer et TouchScrollRouter ;
ApplicationGuard est remis en dernier enfant pour conserver son ordre de réception des entrées.
Le banc contrôle UI/règles, invalide les captures interrompues et laisse la pause à la fin.
La fixture saturated20 utilise seulement des profils locaux durables et des positions initiales
espacées ; Rejouer retrouve les trois vagues. Le gameplay des laboratoires historiques reste inchangé.
Voir docs/performance.md et scenes/tests/performance_tests.tscn.

Lire docs/actions.md, docs/skill-executor.md, docs/skills.md, docs/gambit-controller.md,
docs/manual-commands.md, docs/wave-sequence.md, docs/run-lifecycle.md et
docs/application-lifecycle.md. Les règles fix1 priment sur les anciennes descriptions
« choisir le plus proche » sans mémoire entre actions. Pour les tests : docs/handoff/TESTING.md.
