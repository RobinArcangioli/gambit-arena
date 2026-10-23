# Architecture réelle — STEP-016 validée, commit en attente

Main conserve son UID et ouvre scenes/gambits/gambit_lab.tscn.
GambitRule est une Resource de configuration : activation, cible, condition,
seuil entier et compétence. GambitSnapshot contient uniquement des valeurs copiées,
sans références vers les acteurs, leurs états, exécuteurs ou horloges.
GambitEvaluator.evaluate parcourt au maximum trois règles dans l'ordre et retourne
un dictionnaire neuf de scalaires. Aucun signal, timer, RNG ni appel d'exécution.

Les candidats vivants sont filtrés par condition avant la sélection du plus proche.
À distance carrée exactement égale, l'ID positif le plus petit gagne. L'ordre des
ennemis n'intervient pas ; l'ordre des règles est la priorité. Seuil PV strict,
comparaison entière sans arrondir les pourcentages. Vie, pause, arrêt, occupation,
coût et cooldowns du snapshot sont consultés sans mutation.

L'intention indique règle, source, cible, compétence et besoin d'approche.
Elle ne réserve rien, n'alloue pas d'ID d'action et n'autorise pas un effet ultérieur.
STEP-017 devra capturer un état frais, conserver les IDs pendant le combat,
résoudre les acteurs et revalider via SkillExecutor avant engagement.
Une cible hors portée reste admissible pour permettre l'approche future.

GambitLab dérive du laboratoire historique pour réutiliser disposition et acteurs.
L'exécuteur hérité est immédiatement retiré et jamais avancé. Les boutons changent
seulement les données de test : PV du héros, énergie et cooldown simulés.
GameClock fournit un pas borné ; accumulation locale pour lecture à 10 Hz.
La pause et l'arrière-plan figent les lectures ; reprise explicite. Reset garde
la pause et remet données, règles de démonstration et compteurs à zéro.
Ce reset de laboratoire ne définit pas la conservation des gambits du futur jeu.

CombatSimulation, SkillExecutor, AttackAction, GameClock et les profils historiques
restent identiques à STEP-015. Les valeurs de coût/portée sont lues depuis les
constantes de SkillExecutor. Le combat autonome utilise encore son pilote basic.
Pas d'éditeur tactile, d'intégration des intentions au combat ni d'animations finales.
Version 0.1.0-step016, code 15. F6 et tests manuels confirmés OK par l’utilisateur.
