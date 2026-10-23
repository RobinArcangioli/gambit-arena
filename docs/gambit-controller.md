# Pilotage du héros — STEP-017

GambitController relie les intentions pures au monde vivant. Il est détenu par
CombatSimulation ; aucun acteur ne s'avance seul. L'ancien sélecteur de cible du
héros et son lancement basic inconditionnel sont retirés. Le même contrôleur est
utilisé dans le nouveau laboratoire et les diagnostics de combat historiques.

## Identités et snapshot

CombatUnit attribue un combat_id monotone à chaque instance, indépendant du serial
ennemi, qui repart à 1 dans les scénarios. Un reset crée de nouveaux IDs.
Les IDs sont des identités de session, pas des identifiants persistants sur disque.
La décision reste déterministe à snapshot égal ; les nombres affichés peuvent donc
changer au reset. En cas d'égalité de distance, l'acteur créé le premier gagne.

capture copie PV, maximum, position au sol, énergie, cooldowns, activité et pause.
Les acteurs morts, sortis de l'arbre ou en suppression sont exclus des candidats.
Le snapshot et l'intention ne donnent pas accès aux objets vivants. La propriété
decision renvoie une copie ; modifier cet affichage ne redirige pas le plan interne.

## Planifier et engager

Première décision au premier tick valide. Ensuite période 0,1 s lorsque le héros
est libre. Une cible supprimée ou une règle modifiée invalide le plan au prochain
tick ; une nouvelle décision peut alors avoir lieu avant la fin de la période.
Le pas fourni par le coordinateur est borné à 1/30 s, sans rattrapage en arrière-plan.
Pendant préparation et récupération, l'exécuteur garde sa cible ; aucun nouveau plan.

Une intention offensive fournit la cible au mouvement, sans dépense pendant
l'approche. Soin personnel : mouvement arrêté. Aucune règle applicable : mouvement
arrêté et aucune attaque implicite. Les ennemis continuent leurs propres actions.

Avant engagement, vérifier de nouveau la vie, les instances et identités d'état,
l'appartenance de la cible au combat et la signature de la règle choisie. Puis
réévaluer cette règle seule contre les valeurs actuelles de sa cible : condition,
énergie, cooldown, utilité du soin et portée. Cette revalidation peut se produire
entre deux décisions ; elle ne choisit pas une autre cible ou une autre priorité.
Une nouvelle priorité est examinée à la prochaine planification.

Si la cible reste distante, poursuivre l'approche sans payer. Sinon appeler
SkillExecutor.request, seule porte de validation/engagement. Le contrôleur ne touche
pas aux PV, énergie ou cooldowns. Après acceptation, l'intention est consommée :
aucun second engagement possible, même si execute est rappelé plusieurs fois.
Le verrou d'impact, les annulations et coûts non remboursés restent ceux de STEP-015.

Une modification des règles pendant une action n'annule pas l'action engagée.
La mort de sa cible peut toujours l'annuler via l'exécuteur. La prochaine action
utilisera une nouvelle intention. Une référence à une ancienne intention n'autorise
jamais l'application d'un effet ni une action sur les acteurs d'un reset ultérieur.

## Pause, fin et redémarrage

GameClock bloque planification, engagement, mouvement, actions, ressource, CD et
apparitions. Après retour Android, reprise explicite. La fin du combat invalide
l'intention, arrête l'horloge et retire les exécuteurs. Clear invalide aussi le plan.
Reset conserve la configuration des règles et la pause, mais efface compteurs,
intention et références aux anciens acteurs. Aucun ID d'acteur n'est réutilisé.

## Laboratoires

Le nouveau laboratoire charge trois règles indépendantes : soin personnel sous
50 % de PV, spéciale sur ennemi vivant, attaque normale sur ennemi vivant.
Les coûts/effets restent ceux de STEP-014. Le groupe 20 conserve son budget total
de 20 apparitions progressives ; ce n'est pas encore le système de vagues du MVP.

Scénarios Combat (héros 250 PV, attaque 30), Soin (40/100 au départ, attaque 12),
Groupe 20 (2500 PV, attaque 12), Sans règle (profil Combat, toutes désactivées).
Dans Sans règle, le héros reste immobile et n'attaque pas, puis perd sous les coups
ennemis. Rejouer conserve les règles désactivées ; changer de scénario charge un
nouveau préréglage. Le scénario Soin n'impose pas une victoire, seulement la priorité
initiale au soin et une suite de combat cohérente.

Les bancs et le laboratoire STEP-012 gardent une règle basic unique par défaut.
Il s'agit d'une configuration du même contrôleur, pas d'un second pilote.
L'ancien laboratoire STEP-016 reste un diagnostic de décisions sans exécution.

Affichage courant et compteurs scalaires seulement, aucune liste de logs non bornée.
La prochaine étape développera les diagnostics ; éditeur et boutons manuels suivent.

## Validation

F6, tests manuels et fluidité confirmés OK par l’utilisateur.
STEP-017 validée, commit en attente. Voir docs/steps/STEP-017.md.
