# Emplacements et disponibilité — STEP-022

Six emplacements fixes : 1 Attaque, 2 Soin, 3 Spéciale ; 4/5/6 À venir, désactivés.
Les trois compétences sont consultables, même indisponibles. Appui = sélection du détail,
sans action, dépense, mouvement, journal de combat ou mise en attente.
L'interface l'indique explicitement. L'exécution manuelle sera ajoutée à STEP-023.

| Compétence | Coût | Cooldown nominal | Cible pour la disponibilité |
|---|---:|---:|---|
| Attaque | 0 | 0 s | Ennemi vivant le plus proche |
| Soin | 20 | 4 s | Soi blessé |
| Spéciale | 30 | 6 s | Ennemi vivant le plus proche |

Les constantes proviennent de SkillExecutor. La carte affiche son coût et son délai
restant, arrondi vers le haut au dixième. Le détail affiche le délai nominal et le motif.
Les états sont textuels, la couleur Prêt n'est jamais le seul indicateur.

Priorité du motif : entrée invalide, Mort, Terminé, Pause, Occupé, Délai, PV pleins
(pour le soin), Énergie, Sans cible ou Hors portée, puis Prêt. La portée est inclusive
à 1 unité. L'égalité de distance est départagée par l'ID stable ; les ennemis morts
sont ignorés. Une compétence disponible peut ne pas être choisie par les gambits :
leurs priorités et conditions ne font pas partie de cette disponibilité immédiate.

L'onglet Compétences est ouvert au démarrage. Gambits retrouve les trois règles et le
formulaire validés. Changer d'onglet n'affecte pas le combat. Les onglets et commandes
Rejouer/scénario restent fixes ; liste et grille défilent si nécessaire. Le détail se
trouve sous les six emplacements. Le formulaire bloque les changements d'onglet.
Rejouer conserve l'onglet et la sélection, actualise les délais et garde la pause.

La source de données est une copie scalaire ; aucun bouton ne peut appeler request.
L'état affiché n'est pas une garantie pour un futur engagement : il faudra revalider
cible, portée, coût, cooldown et cycle de vie au moment de la commande STEP-023.

Recette et tests : docs/steps/STEP-022.md. F6, tests manuels et fluidité confirmés OK par l’utilisateur ; commit en attente.
