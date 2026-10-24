# Éditeur de gambits — STEP-019

Trois règles de session : Soin sur soi si PV strictement inférieurs à 50 %,
Spéciale sur ennemi toujours, Attaque sur ennemi toujours. La première disponible
selon coût, cooldown et cible gagne ; Haut/Bas change la priorité et Oui/Non l'activation.
Les lignes désactivées sont grisées et marquées Non. Toutes peuvent être désactivées.
Les limites haute/basse sont désactivées, sans retour circulaire ni duplication.

Chaque déplacement transporte toute la règle. Aucun changement de cible, condition,
seuil ou action à cette étape. Ni glisser-déposer, ni suppression, ni ajout de ligne.
Les boutons sont utilisables à la souris et au toucher via l'émulation déjà configurée.
Les raccordements utilisent pressed une seule fois, sans voie tactile parallèle.

Une modification invalide toute intention en attente, y compris celle d'une ligne
restée inchangée quand une priorité supérieure devient disponible. Elle ne lance
aucune compétence. À la prochaine planification autorisée, le héros relit ses règles.
L'action déjà engagée poursuit son exécution normale, sous les protections existantes
(mort, cible perdue, portée), sans remboursement ou coût supplémentaire.
L'indication « engagee » décrit l'action en cours, indépendamment du nouvel ordre.

La pause autorise la configuration mais pas le temps de jeu. Une invalidation explicite
peut être tracée à temps constant. Rejouer garde pause, ordre et activation ; changer
Combat/Soin/Groupe 20 conserve les règles et réinitialise le combat. Soin commence à
40/100 PV. Aucun bouton ne restaure implicitement les règles par défaut ; relancer F5
crée une nouvelle session et retrouve les trois règles initiales.

Le modèle possède des Resources indépendantes et renvoie des copies. Le laboratoire
est responsable de publier ces copies au contrôleur et d'invalider l'intention.
Les six emplacements futurs sont masqués pour réserver le bas aux trois règles.
Ils ne sont pas supprimés des laboratoires précédents. G affiche encore les repères.

Recette et tests : docs/steps/STEP-019.md. Validation utilisateur globale reçue sur la v2.

Retour v1 F6/manuels/fluidité OK ; réserve de déplacement traitée par FIX-STEP-019-001.
V2 validée : voir docs/steps/FIX-STEP-019-001.md.
