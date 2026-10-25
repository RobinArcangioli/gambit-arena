# Commande manuelle — STEP-023

Les trois premières cartes commandent Attaque, Soin et Spéciale. Les trois dernières
restent réservées et désactivées. Une commande accepte de patienter trois secondes de
jeu, au plus : un nouvel appui accepté remplace l'ancienne et renouvelle son échéance.
Les appuis refusés (pause, fin, compétence inconnue, attaque sans cible) ne la remplacent pas.
L'action déjà engagée ne change ni d'identité, ni de cible, ni de coût à cause d'un appui.

Une commande attend tant que le héros est occupé, le cooldown positif, l'énergie
insuffisante, le soin inutile ou la cible hors portée. Pendant cette attente, les gambits
ne démarrent pas d'action. Soin vise le héros ; les attaques verrouillent l'ennemi vivant
le plus proche au moment de l'appui, égalité départagée par ID. Le héros approche cette
cible automatiquement, sans modification de l'arrêt à portée. Une autre cible devenue
plus proche ne détourne pas la commande. Si la cible initiale disparaît, la commande
est annulée et les gambits reprennent ; ils peuvent alors choisir une autre cible.

L'appui ne lance rien directement. Au prochain tick de jeu et après les actions déjà
engagées, la commande est revalidée puis transmise à SkillExecutor.request. Les coûts
restent Attaque 0, Soin 20, Spéciale 30 ; cooldowns 0, 4 et 6 s, énergie maximale 60.
Aucun paiement ou cooldown pendant la seule attente. L'exécution ne survient qu'une
fois. Une action engagée reste soumise au cycle de vie et à la portée à l'impact existants.

L'expiration arrive à elapsed >= échéance (tolérance numérique 1e-6), avant toute
exécution à cette échéance. Pause, arrière-plan et verrouillage figent elapsed et
l'attente. Les nouveaux appuis en pause sont refusés, avec un message. Reprendre est
explicite. Rejouer/scénario efface toute attente ; il conserve les gambits et la pause.
Modifier les gambits pendant le formulaire ne remplace pas la commande manuelle.
La mort ou la sortie d'arbre de la source/cible efface immédiatement l'attente, même
pendant la pause ; les changements d'état et de liste sont revalidés à la reprise.

L'en-tête montre la compétence en attente et le temps restant. Sous les six cartes,
le détail précise le motif, la dernière issue et le dernier retour d'appui. Faire défiler
si nécessaire. Le nombre sur chaque carte est son cooldown, pas le délai de la commande.
La disponibilité des cartes est une lecture immédiate ; l'attente a sa propre cible.
Une absence de commande laisse intégralement fonctionner les gambits.

Le laboratoire historique skill_slots_lab reste consultatif. Main ouvre le nouveau
manual_command_lab. Recette : docs/steps/STEP-023.md. Validation utilisateur reçue ; anomalie de swipe reportée à STEP-024.
