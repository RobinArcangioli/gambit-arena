# Pause, arrière-plan et retour — STEP-027

## État de l’application

ApplicationGuard distingue focus et suspension : FOCUS_OUT rend focused faux, PAUSED rend
suspended vrai. FOCUS_IN et RESUMED rétablissent chacun leur indicateur. Les notifications
répétées sont idempotentes. Si les deux pertes ont été reçues, les deux retours sont requis
avant de débloquer l’interface. Un cycle focus seul fonctionne sur PC ; un cycle de
suspension seul fonctionne aussi. Le comportement réel du téléphone reste à vérifier.

Toute perte impose paused et marque resume_required ; le retour ne les enlève pas.
Reprendre est une action explicite, refusée tant que l’application est bloquée ou que le
formulaire est ouvert. Rejouer est également refusé pendant l’arrière-plan ; son appel
initial reste autorisé à la construction de la scène, même si une perte précède _ready.
Après retour, Rejouer conserve la pause et la configuration de gambits comme auparavant.

## Temps et actions

L’application n’avance ni combat, ni vagues, ni cooldowns, ni énergie, ni échéance manuelle
pendant la pause. Actions engagées et coûts restent en place ; pas de remboursement ou
nouvel engagement au retour. Le premier pas actif après Reprendre est ignoré, puis les
pas suivants passent par GameClock et son bornage existant. La durée passée en arrière-plan
n’est jamais injectée dans l’horloge. Une fin de partie reste terminale, même après Reprendre.

## Entrées

Le Node ajouté en dernier reçoit _input avant le routeur des listes et le GUI. Il bloque
les événements pendant l’absence de focus/suspension. À chaque perte, il oublie les appuis
suivis. Au retour, un relâchement sans appui neuf, un drag sans nouveau doigt ou une répétition
clavier sans nouvelle pression sont consommés. Un appui frais suit les chemins habituels.
Les souris physique et émulée ont des suivis séparés ; la molette reste native au premier plan.
Le routeur tactile est réinitialisé à la perte, sans modifier son seuil de swipe ou ses règles.
Aucun clic, compétence, Rejouer ou Reprendre n’est généré par le garde lui-même.

Le formulaire garde le brouillon non appliqué et reste en pause. Le layout/zones sûres est
recalculé à RESUMED et FOCUS_IN. Le bilan DEFAITE/VICTOIRE garde la priorité sur PAUSE / retour.

## Validation et limites

Le banc application_lifecycle_tests envoie notification() à la scène réelle et injecte
les gestes dans son viewport. Il couvre dix cycles, ordres de notifications inversés,
doublons, blocage des commandes, action payée et attente manuelle figées, reprise sans
rattrapage, ancien relâchement, nouveau tap/swipe, brouillon, zone sûre, replay et défaite.
Il ne démontre pas que le système Android transmet tel ordre d’événements sur le téléphone.
La recette physique Accueil, applications récentes et verrouillage complète ce banc.
Godot n’est pas disponible chez l’assistant : tests livrés, non exécutés ici.

L’arrêt forcé ou la destruction du processus par Android démarre une nouvelle session au
relancement. Aucun état n’est sauvegardé sur disque ; la continuité après destruction du
processus n’appartient pas au MVP actuel. Pas de mesure de performance dans cette étape.

## Références moteur consultées

- Notifications : https://docs.godotengine.org/en/stable/classes/class_mainloop.html
- Distribution de _notification : https://docs.godotengine.org/en/4.6/classes/class_object.html
- Ordre de propagation des entrées : https://docs.godotengine.org/en/4.2/tutorials/inputs/inputevent.html

Ces références documentent les API ; elles ne constituent pas un test de la version
installée chez l’utilisateur ou une preuve du comportement du téléphone.

STEP-027 validée le 26 octobre 2026 : F6, tests manuels et fluidité OK.
Retour global sans mesure chiffrée ; commit et sauvegarde en attente.
APK : 07467efcfb7e663e363e6f6fc61644fd2bf2889e7ee3a3001d42589e0c6cf611.
