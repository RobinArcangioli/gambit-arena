# ARENA-001 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour l'arène épurée : Pause, quatre panneaux
passifs Mako / Anne / Vide / Vide, portraits et barres, suppression des anciennes commandes
et de la sélection. Menu Reprendre / Rejouer / Abandonner, confirmation avant l'accueil.
APK 0.1.0-arena001 (53), SHA-256
`08b675affdafd61effb941737381e0458792705796807bf64978b1f921651293`.
Seuls les documents sont actualisés ; code, scènes, assets, configuration et APK restent
identiques à la livraison validée. Les 54 bancs / 3 592 contrôles déjà réussis ne sont pas
relancés. Recette tactile Android réussie, pause visuellement figée et gambits inchangés.
Clôture par commit unique et sauvegarde restaurée/vérifiée. Prochain GO : UI-005,
qualification intégrée prolongée Android, puis STEP-029/030. GAMEPLAY-003 reste annulée.
Les états précédents ci-dessous sont historiques.

# Ajustement ARENA-001 — parcours produit actuel

L'arène est désormais sobre : Pause, quatre panneaux passifs et barres au-dessus des acteurs.
Retour Android passe par Pause ; l'abandon exige une confirmation. La programmation des
gambits se fait depuis la fiche hors combat. UI-005 doit recetter ce nouveau parcours ;
les anciennes mentions d'édition en arène ci-dessous sont historiques. Les laboratoires
historiques gardent leurs commandes. Voir [ARENA-001](steps/ARENA-001.md).

# GAMBITS-002 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour la refonte intégrée et sa passe stylistique.
APK 0.1.0-gambits002 (49), SHA-256
`8ca94f2f17f5624e9724f5225d3774932933d312d4ff22efb878c32a19e5a95f`.
Seuls les documents sont actualisés ; code, scènes, assets, configuration et APK restent
identiques à la livraison validée. Les 53 bancs / 3 497 contrôles réussis ne sont pas
relancés. Les essais Android couvrent les listes, l'autosauvegarde, 100 ordres et la reprise.
Téléphone rendu à l'accueil avec les ordres d'origine migrés, dont Anne 80 % → 70 % ;
copie v2 protégée conservée. Aucun nouveau benchmark FPS.
Clôture par commit unique et sauvegarde restaurée/vérifiée. Prochain GO : UI-005,
qualification intégrée prolongée Android, puis STEP-029/030. GAMEPLAY-003 reste annulée.
Les états précédents ci-dessous sont historiques.

# GAMBITS-002 — en recette — 27 octobre 2026

Le jeu F5 utilise désormais le catalogue de dix critères de ciblage fixes et les capacités
indépendantes. Éditeur partagé entre fiche et combat, 0–100 ordres par héros, sauvegarde
immédiate de chaque changement, sans Appliquer/Annuler. Ligne unique : activation verte /
croix rouge, chevrons, critère, capacité, corbeille. Ajouter et compteur sous la liste.
Passe stylistique réalisée : bleu nuit, bordures or, menus ivoire/orange, sur le fond fourni.

53 bancs / 3 497 contrôles réussis sans erreur ni avertissement moteur. Recette visuelle GPU
PC et gestes Android documentés dans la livraison. Aucun nouveau benchmark FPS.
APK 0.1.0-gambits002 (49), SHA-256 `8ca94f2f17f5624e9724f5225d3774932933d312d4ff22efb878c32a19e5a95f`.
Base clôturée : GAMBITS-001 `307030fc500dbdf076adaee95b984edfbf3b6d16`, sauvegarde
`gambit-arena-20261027-081032-307030fc500d.tar.gz`, restaurée et vérifiée (678 fichiers).
Cette étape attend la validation utilisateur avant commit et sauvegarde de clôture.
Ensuite : UI-005, qualification intégrée prolongée Android, puis STEP-029/030.
GAMEPLAY-003 reste annulée. Les états précédents ci-dessous sont historiques.

# GAMBITS-001 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour le nouveau modèle et son laboratoire
isolé. Validation globale, sans précisions supplémentaires. APK normal 0.1.0-gambits001 (48),
SHA-256 `b2a8e4defb65f46d41ebbd4f91cf57dcf85c8d066f58291943cad4d06e1c073e`.
APK laboratoire 0.1.0-gambits001-lab (48), SHA-256
`bfa7b4781efa728a54ebebaf5cefa71facd46a1adc07d8a13e85050bbe4eeb97`.
Seuls les documents sont actualisés ; code, scènes, assets, configuration et les deux APK
restent identiques à la livraison validée. Les 52 bancs / 3 461 contrôles déjà réussis ne
sont pas relancés. Aucune nouvelle mesure FPS. Règles de jeu Android v2 conservées.
Clôture par commit unique et sauvegarde restaurée/vérifiée. Prochain GO : GAMBITS-002,
bascule du combat et des éditeurs, sauvegarde immédiate sans Appliquer/Annuler, 100 ordres.
Le jeu normal conserve UI-004 en v2 jusqu'à cette bascule. Puis UI-005 et STEP-029/030.
GAMEPLAY-003 reste annulée. Les mentions de recette ci-dessous sont historiques.

# GAMBITS-001 — Modèle et laboratoire en recette — 27 octobre 2026

GO reçu pour la première étape de refonte. Catalogue des dix critères fixes, ordres à
critère/capacité indépendants, listes de 0 à 100 par héros, résolution déterministe et
codec v3 avec migration v2 et sauvegarde protégée. Écriture immédiate par héros, sans
workflow Appliquer/Annuler dans le nouveau modèle. Anne 80 % devient 70 % en migration.
F6 : scenes/debug/gambits_criteria_lab.tscn. Ce banc isolé résout des instantanés et écrit
uniquement user://gambits_v3_lab.json ; il ne lance aucun soin/attaque/sort réel.
F5 et l'APK normal conservent intégralement le jeu et l'éditeur UI-004 en v2, y compris leurs
anciennes commandes : la bascule du combat et de l'interface est GAMBITS-002, pas cette étape.
52 bancs / 3 461 contrôles réussis ; captures GPU PC et laboratoire Android vérifiés.
APK normal 0.1.0-gambits001 (48), SHA-256 `b2a8e4defb65f46d41ebbd4f91cf57dcf85c8d066f58291943cad4d06e1c073e`.
Téléphone remis sur l'accueil de l'APK normal ; règles de jeu Android identiques à l'origine.
Voir docs/gambits-model.md et docs/steps/GAMBITS-001.md. En recette, non commitée.
Après validation : clôture et sauvegarde vérifiée, puis GO pour GAMBITS-002 et UI-005.
GAMEPLAY-003 reste annulée. Les états précédents ci-dessous sont historiques.

# Refonte des gambits — plan proposé, 27 octobre 2026

Base fonctionnelle validée et clôturée : UI-004, commit 2f1e9b9603d75b8acc2c3a920036254398461233.
Cette préparation est documentaire : aucun changement au code, à l'APK ou aux sauvegardes.
Le plan s'intercale avant UI-005 ; attendre validation du découpage et GO avant GAMBITS-001.

## Contrat fonctionnel confirmé

Nom d'interface proposé pour target_cond : **Critère de ciblage**. Un ordre contient un
critère et une capacité, avec activation et position de priorité comme commandes d'édition.
Le critère possède un identifiant stable ; seuils et pourcentages appartiennent au catalogue,
jamais à un paramètre éditable de l'ordre. La liste des capacités reste celle du personnage.
Toute capacité disponible peut être associée à tout critère, y compris soin d'un ennemi,
foudre sur un allié et capacité offensive sur soi-même. Aucun couplage automatique
cible/capacité ne doit subsister dans l'éditeur, la validation ou l'exécuteur.

| Critère | Résolution |
| --- | --- |
| Soi-même | Le personnage vivant qui exécute l'ordre, sans condition de PV |
| Allié — PV < 90 % | Allié vivant, personnage inclus, strictement sous 90 % |
| Allié — PV < 70 % | Idem, seuil fixe 70 % |
| Allié — PV < 50 % | Idem, seuil fixe 50 % |
| Allié — PV < 30 % | Idem, seuil fixe 30 % |
| Allié — PV < 10 % | Idem, seuil fixe 10 % |
| Ennemi — le plus de PV | Plus grande quantité de PV actuels en valeur absolue |
| Ennemi — le moins de PV | Plus petite quantité de PV actuels en valeur absolue |
| Ennemi proche | Ennemi vivant le plus proche ; critère d'un nouvel ordre |
| Ennemi lointain | Ennemi vivant le plus éloigné |

Décisions complémentaires confirmées : les alliés incluent toujours le lanceur ; plusieurs
alliés admissibles sont départagés par leur plus faible pourcentage de PV, indépendamment
de la capacité associée. Les classements ennemis par PV n'utilisent jamais les pourcentages.
Départages proposés : distance la plus courte puis identifiant de combat stable ; pour les
critères de distance, égalité départagée par identifiant. La même situation doit produire
la même cible, sans dépendre de l'ordre d'itération des acteurs.

La capacité ne doit pas modifier le classement du critère. Ensuite seulement, les règles
habituelles de disponibilité/utilité s'appliquent : vivant, mana, recharge, action en cours,
soin inutile sur PV pleins, etc. En l'absence de cible ou d'action possible, passer à l'ordre
suivant. La portée continue à guider l'approche de la cible choisie : elle ne transforme pas
« ennemi lointain » en « ennemi proche ». Ne pas conserver une ancienne cible offensive si
elle contredit le nouveau critère. Une action engagée conserve ses protections habituelles.
Mana payée à la résolution, annulation si cible perdue, incantations/animations inchangées.

## Liste et ergonomie proposées

0 à 100 ordres par héros, indépendamment de l'autre héros. Évaluation de haut en bas,
premier ordre exécutable. Liste vide ou entièrement inactive : aucune action automatique
issue des gambits, sans attaque de remplacement cachée. Commandes manuelles conservées.

Chaque ordre occupe **une seule ligne** : case ✓ verte / ✕ rouge, deux boutons à chevrons
haut/bas, liste déroulante du critère, liste déroulante de la capacité, puis corbeille.
Les flèches et les anciens boutons de seuil disparaissent. Les couleurs ne sont pas les
seuls indices d'activation : ✓/✕ et libellés accessibles les complètent.
Les deux listes sont indépendantes. Libellés longs abrégés si nécessaire sur la ligne,
mais complets dans les listes ouvertes ; aucune rangée qui se transforme en formulaire
vertical. Les menus doivent rester lisibles et utilisables au doigt sur Galaxy A16.

« Ajouter un gambit » est placé juste sous la liste, avec compteur n/100 ; désactivé à 100.
Le nouvel ordre est ajouté en fin de liste : Ennemi proche + Attaque, actif, proposition
cohérente avec les capacités actuelles. Le bouton reste accessible dans l'état vide.
La corbeille supprime sa ligne. Toute modification est sauvegardée immédiatement :
activation, choix dans une liste, déplacement par chevron, ajout et suppression. Aucun bouton
Appliquer ou Annuler, aucun brouillon utilisateur ni confirmation de sauvegarde. Retour
revient à la fiche en conservant les changements. Pas de notification de réussite à chaque
action : garder une interface sobre. En cas d’échec d’écriture, rétablir le dernier état
enregistré et afficher un bref message d’erreur, sans prétendre que le changement est sauvé.
Une ligne conserve son identité pendant les éditions et réordonnancements pour éviter
qu'un geste, un menu ou un index périmé ne modifie un autre ordre.

Fonds fournis et thème bleu nuit/or-orange conservés, avec rouge/vert réservés aux états
actif/inactif. Pas de sélection persistante de héros au retour Équipe. L'éditeur en combat
et celui hors combat doivent utiliser le même modèle et les mêmes règles d'édition.

## Sauvegardes et migration

Prévoir une version de schéma dédiée aux ordres à critère fixe et aux listes de taille
variable. Conserver l'original v2 avant bascule, valider complètement avant écriture atomique,
et préserver la configuration de l'autre héros. La migration est résolue en mémoire au chargement, sans modifier le fichier
courant à la simple consultation. La première modification valide sauvegarde automatiquement
le nouveau format après protection de l’original, sans bouton de validation supplémentaire. Une sauvegarde existante invalide n'est pas écrasée.

Décision utilisateur : les anciens seuils libres sont convertis vers le **plus grand seuil
disponible inférieur ou égal**. Un seuil déjà présent reste identique ; exemples : 80 → 70,
60 → 50, 40 → 30, 20 → 10, 100 → 90. Le soin d'Anne actuellement à 80 % devient Allié — PV < 70 %.
L'activation, la capacité et la priorité sont préservées quand la conversion est possible.

Certaines anciennes règles n'ont pas d'équivalent : seuil inférieur à 10 %, Allié/Toujours,
ou Ennemi/PV < seuil. Proposition : conserver l'original en sauvegarde, signaler la règle
à revoir et la laisser désactivée dans le résultat de migration, sans inventer de critère
ni déclencher un soin offensif involontaire. Une conversion impossible ne doit jamais être
présentée comme équivalente. Le bilan de migration doit permettre d'identifier ces cas.

## Découpage proposé

| Étape | Livrable | Validation attendue |
| --- | --- | --- |
| GAMBITS-001 | Catalogue, modèle 0–100 ordres, résolution des critères, schéma et migration testable dans un banc isolé | Dix critères, seuils statiques, choix indépendant de la capacité, déterminisme et cas de migration ; application courante encore compatible avec sa sauvegarde v2 |
| GAMBITS-002 | Bascule de l'application : moteur/exécuteur, éditeurs en ligne, listes déroulantes, ajout/suppression et migration | Toutes les associations fonctionnent réellement en combat, même fichier pour les deux éditeurs, sauvegarde immédiate à chaque changement et 0/1/100 ordres ; PC et A16 |
| UI-005 | Recette intégrée du parcours complet, étendue à la refonte | Menus et gestes au doigt, 100 ordres par héros, coûts/temps de lancement, retour/pause/reprise, cycles sans fuite, sauvegarde et arènes aléatoires |

GAMBITS-001 produit des composants et un laboratoire isolés ; elle ne livre pas une
application intermédiaire avec un éditeur incapable de représenter sa nouvelle sauvegarde.
La bascule des consommateurs intervient ensemble dans GAMBITS-002. L'exécuteur doit alors
accepter le camp choisi par le critère, y compris soi-même, au lieu de l'imposer selon la
capacité. Le maintien de focus offensif doit respecter le résultat de ciblage. Les anciens
laboratoires conservent leurs contrats ou une adaptation explicitement testée.

La recette de capacité doit couvrir soin sur ennemi blessé, foudre/attaque sur allié et
sur soi-même, soin sur soi, cibles mortes/perdues et mana non débitée en cas d'annulation.
La recette de charge doit vérifier 100 ordres actifs, inactifs, inapplicables et modifiés,
les deux héros simultanément, déroulement/reclassement/suppression à différents endroits,
sauvegarde/relecture, échec d’écriture sans faux état enregistré, retour et relance après
chaque type de modification, et limites de fichier cohérentes avec le maximum réel. Mesurer sur A16
avant de décider si la liste nécessite une réutilisation des lignes visibles.

Après chaque étape fonctionnelle : recette, validation propriétaire, commit unique,
sauvegarde restaurée/vérifiée puis prochain GO. STEP-029 et STEP-030 suivent UI-005.
