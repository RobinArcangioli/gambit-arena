# Vague unique — STEP-024

Une partie contient une seule vague. Scénarios : Vague 12 (12 arrivées, 6 simultanés),
Soin 12 (même plan, héros blessé) et Charge 24 (24 arrivées, plafond global 20).
Les profils de héros restent ceux des trois laboratoires antérieurs ; les ennemis sont
inchangés. Ces paramètres servent à la recette et ne constituent pas un équilibrage final.

| Moment | Intervalle avant la prochaine arrivée |
|---|---:|
| Aucune apparition | 1 s |
| Moins du premier tiers apparu | 2 s |
| Premier tiers atteint, moins des deux tiers | 1,5 s |
| Deux tiers atteints | 1 s |

Sans saturation ni obstacle à l'apparition, les douze arrivées surviennent à 1, 3, 5, 7,
8,5, 10, 11,5, 13, 14, 15, 16 et 17 secondes de jeu. Le plan ne réduit ni les PV ni les
cooldowns et ne change pas les dégâts. Les commandes manuelles restent prioritaires.

Un ennemi apparaît à une position de bord libre, à distance suffisante du héros et des
autres ennemis. Au plus 20 positions candidates et une apparition par tick. En cas de
plafond atteint ou d'espace occupé, l'arrivée attend sans consommer le quota. Le crédit
reste borné à un intervalle : un espace libéré ne provoque pas de rafale de rattrapage.
Le nouvel acteur ne reçoit aucun temps de mouvement/action pendant son tick de création.

Une arène temporairement vide avant la fin du quota n'est pas une victoire. La victoire
exige toutes les apparitions et aucun ennemi restant ; la mort du héros termine aussitôt
la partie. Un ennemi supprimé extérieurement est compté séparément et interdit une fausse
victoire. Une fin arrête toute apparition/action/commande. Rejouer repart avec un héros
neuf, zéro apparition et une horloge remise à zéro, tout en conservant pause et gambits.

Le HUD affiche les présents/plafond et apparus/total. Vaincus et restant à venir sont dans
le détail sous les compétences. L'enchaînement de trois vagues sera STEP-025.
Recette : docs/steps/STEP-024.md. F6, tests manuels et fluidité confirmés OK par l’utilisateur ; commit en attente.

## STEP-025 — Livraison en attente de validation

Base clôturée 89ae0f6. Main ouvre maintenant trois vagues ; le laboratoire STEP-024
reste disponible. Version 0.1.0-step025, code 24, export step-025-debug.apk.
Recette et commandes : docs/steps/STEP-025.md. Aucun SHA d’APK STEP-025 reçu.
Les sections STEP-024 ci-dessus décrivent la livraison précédente.
