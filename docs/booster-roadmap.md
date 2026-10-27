# Roadmap validée — GAMBITS-003 en recette

Le GO du 27 octobre 2026 valide ce plan et autorise GAMBITS-003, maintenant implémentée.
Le critère Allié et le classement des candidats sont en recette. Après validation/clôture,
le GO suivant lancera BUFFS-001. BUFFS-002, GRAPHICS-010 et UI-005 suivent dans cet ordre.
Les décisions de coût, durée, mana, non-cumul et comportement des buffs ci-dessous restent
les références des prochaines étapes. Seule GAMBITS-003 est implémentée à ce stade.

# Ciblage Allié, temps personnel et Booster — roadmap validée

Date : 27 octobre 2026. Plan approuvé ; GAMBITS-003 est implémentée et en recette, les étapes suivantes restent planifiées.
Base : ARENA-001 validée et clôturée, commit `15bf1f5cc21c1334491f3fa43e2cc04edd9f30bc`.
Cette évolution s'intercale avant UI-005, puis STEP-029 et STEP-030.

## Décisions confirmées

- Nouveau critère « Allié », sans condition ; il inclut le lanceur et suit l'ordre de l'équipe :
  Mako, Anne, puis les futurs emplacements occupés. Les places vides et personnages morts
  sont ignorés. L'ordre d'équipe prime sur la distance, les PV et l'ordre interne des ticks.
- Toute capacité reste associable à tout critère. « Allié » seul classe les candidats ;
  pour un buff, les cibles portant déjà CE buff sont exclues avant le choix final.
- Si la mana est insuffisante, le gambit est ignoré : règle générale pour toutes les capacités.
  Les contraintes de disponibilité/recharge et d'action déjà engagée restent applicables.
- Booster est ajouté au catalogue de Mako, avec Attaque et Foudre ; Anne conserve ses capacités.
- Booster : 20 mana, incantation de référence 1,5 s, facteur de temps personnel ×1,30 pendant
  60 secondes de combat normal. Aucun délai de recharge dédié. La récupération habituelle
  des actions reste applicable entre deux lancers et suit le temps personnel du lanceur.
- Non cumulable, non renouvelable tant qu'actif. Le coût est prélevé à la résolution réussie.
  Cible perdue, morte, remplacée, hors portée ou déjà buffée à la résolution : aucun débit.
- Les recharges sont accélérées ; la régénération de mana ne l'est PAS. Les 60 s du buff
  sont mesurées par l'horloge du combat, gelée en pause et en arrière-plan.
- Effet visuel : montre dorée simple, sobre, translucide ; aiguilles accélérant rapidement ;
  durée visuelle de 2 s et même enveloppe de fondu que le soin, généralisée et réutilisable.

## Sémantique du ciblage

Le critère fournit une liste ordonnée ; la capacité décide de l'éligibilité. Pour Booster,
retirer les morts, places vides et cibles ayant déjà Booster, puis retenir le premier
candidat restant. Ce filtrage de buff vaut aussi pour Soi-même, les critères de PV ou un
critère ennemi : les associations libres restent possibles, y compris Booster sur un ennemi.
Le classement propre au critère est conservé pour les candidats restants.

Avec « Allié → Booster » en premier chez Mako : Mako se buffe, puis Anne, puis le gambit ne
trouve plus de cible et l'ordre suivant est évalué. Un buff qui expire rend sa cible de
nouveau éligible. Aucun curseur tournant persistant n'est nécessaire : l'état des buffs et
l'ordre d'équipe suffisent. Si Mako manque de mana, il exécute temporairement l'ordre
suivant ; ce n'est pas une attente bloquante jusqu'à ce que toute l'équipe soit buffée.

L'exclusion des cibles déjà buffées est une règle des buffs. Ne pas généraliser aux soins
un nouveau choix automatique d'une autre cible : leur comportement actuel de ciblage est
conservé. Par exemple Allié sans condition vise d'abord Mako ; les critères de PV restent
le moyen de choisir un allié blessé selon leurs seuils et leur classement existants.

## Deux temps distincts

| Élément | Horloge | Effet de Booster |
| --- | --- | --- |
| Préparation/impact/récupération d'attaque | Personnage | ×1,30 |
| Incantations et recharges | Personnage | ×1,30 |
| Déplacement volontaire et contournement | Personnage | ×1,30 |
| Animations du modèle : idle, marche, attaque, cast, hit, mort | Personnage | ×1,30 |
| Régénération de mana | Combat | Inchangée |
| Durée du buff : 60 s | Combat | Inchangée |
| Vagues, apparitions, autres participants non buffés | Combat | Inchangés |
| Effets visuels autonomes : soin, foudre, montre de 2 s | Présentation du combat | Durée de référence conservée |

« 30 % plus rapide » signifie durée de base / 1,30 : Booster et Soin de 1,5 s passent à
≈1,154 s si le lanceur est buffé ; Foudre de 2 s à ≈1,538 s ; déplacement de 1,2 à 1,56
unité/s. Il ne s'agit pas de multiplier les durées par 0,70. Les dégâts, soins, coûts,
portées, rayons et paramètres de référence ne sont pas modifiés.

Le temps personnel est appliqué une seule fois : ne pas cumuler un delta accéléré ET une
réduction des durées ou un second multiplicateur d'AnimationPlayer. La barre d'incantation
lit toujours l'exécuteur réel ; le modèle suit la même progression. Un buff reçu ou expirant
pendant une action change la vitesse restante sans réinitialiser l'action ni ses barres.
L'expiration au milieu d'un pas sépare la portion accélérée et la portion normale.
La vitesse graphique de mort peut être conservée dans l'instantané de présentation quand
l'acteur logique est retiré ; aucun état de buff ne survit à une nouvelle partie.

Les effets autonomes ne pilotent pas la logique : la montre dure 2 s même lorsqu'elle apparaît
sur Mako déjà accéléré. Ils sont gelés en pause. La mana reste régénérée au rythme normal,
y compris pendant une incantation accélérée ; seul son paiement dépend de la résolution.

## Ordre des étapes

| Étape | Résultat livrable | Condition pour passer à la suivante |
| --- | --- | --- |
| GAMBITS-003 | Critère Allié, classement explicite par équipe et candidats ordonnés | Ciblage et sauvegardes validés |
| BUFFS-001 | États de buffs et temps personnel, testables en laboratoire | Indépendance des horloges et déplacement validés |
| BUFFS-002 | Booster jouable via les gambits de Mako | Séquence Mako → Anne et règles de buff validées |
| GRAPHICS-010 | Fondu partagé et montre procédurale de 2 s | Rendu Godot puis Android validé |
| UI-005 | Recette intégrée des parcours, buffs et combat sobre | Qualification avant livraison finale |
| STEP-029 puis STEP-030 | Livraison reproductible et clôture finale du prototype | Recette des étapes précédentes acquise |

### GAMBITS-003 — Critère Allié et ordre d'équipe

1. Ajouter `ally_roster`, libellé « Allié », au catalogue, sans valeur éditable. Conserver
   les IDs existants et le défaut Ennemi proche à l'ajout d'un ordre.
2. Donner aux instantanés un rang d'équipe explicite. Le moteur crée et traite actuellement
   Anne avant Mako : ne pas changer cet ordre de simulation pour corriger l'ordre de ciblage.
3. Faire produire au ciblage des candidats ordonnés ; conserver un adaptateur du choix
   unique actuel et le classement des dix critères existants. Préparer le point de filtrage
   d'éligibilité de capacité, sans embarquer de règles de buff dans la présentation.
4. Ajouter Allié dans la liste de l'éditeur de fiche, conserver autosauvegarde, priorités,
   limite de 100, indépendance des héros et format des ordres. Relire les anciennes sauvegardes
   sans changement de leurs critères ; protéger la configuration avant les fixtures de test.
5. Tests : Mako sélectionné avant Anne même si Anne est le lanceur, positions/PV inversés,
   ordre de création inversé, Mako mort, places vides, zéro candidat et absence de régression
   sur les autres critères. Utiliser les IDs dans les tests plutôt que les index de menus.

Acceptation : Allié est utilisable avec les capacités actuelles ; il suit strictement
l'ordre d'équipe. Le nouveau filtrage des buffs devient actif lors de BUFFS-002.

### BUFFS-001 — États de buffs et horloge personnelle

1. Créer une définition de buff indépendante (ID, durée, multiplicateur, règle de cumul)
   et un état par participant. Les ressources de référence restent partagées et immuables ;
   seuls les états de combat sont instanciés et expirent sur l'horloge du combat.
2. Calculer les pas personnels des unités (normal ×1,00, Booster ×1,30) à partir du temps
   de combat accepté. Prévoir les limites d'application/expiration et un ordre déterministe
   des changements, sans accélérer rétroactivement une portion de tick déjà exécutée.
3. Brancher attaques, récupération, incantations, recharges, déplacements et animations.
   Garder la régénération de mana explicitement sur le delta de combat normal.
4. Lever proprement la limite fixe du solveur de foule : il plafonne actuellement chaque
   déplacement à `1.2 * dt`. Donner une limite par participant adaptée à sa vitesse effective,
   garder collisions, rayons, limites de terrain et budget de recherche de chemin cohérents.
   Ne pas laisser un second clamp de delta annuler l'accélération. Les participants non
   buffés gardent leur comportement de référence.
5. Fournir à la présentation les valeurs de temps acceptées et des instantanés passifs,
   y compris pour les fins d'animation après décès ; aucune action logique dans les VFX.
6. Bancs à différents pas/fréquences, expiration au milieu d'une attaque/incantation,
   buff reçu en cours d'action, pause/reprise, mort, nouvelle vague, abandon et Rejouer.

Acceptation : sur un intervalle donné, l'acteur buffé progresse de 1,30× pour ses actions
et ses recharges, mais régénère autant de mana qu'un acteur normal. Le buff dure 60 s de
combat, les autres unités et les vagues gardent leur rythme. Pas de Engine.time_scale global.

### BUFFS-002 — Booster dans le combat et les gambits

1. Ajouter Booster à Mako : 20 mana, 1,5 s de cast de référence, portée de sort existante
   de 4 unités, récupération habituelle, aucune recharge dédiée. Duck sert à l'incantation,
   comme pour les autres sorts ; les priorités d'animation acquises sont préservées.
2. Centraliser l'éligibilité d'une cible pour un buff. Le critère classe les candidats,
   Booster ignore ceux qui l'ont déjà ; si aucun ne convient, évaluer l'ordre suivant.
   Mana insuffisante → skip, comme pour tous les gambits.
3. Revalider à l'engagement ET à la résolution (cible vivante/état identique, portée, buff
   absent, mana suffisante). Appliquer buff et débit de 20 une seule fois au succès.
   Une application concurrente par un autre lanceur annule le doublon sans débit ni renouvellement.
4. Émettre un événement de présentation uniquement après application réussie ; il contient
   des valeurs et des identifiants, sans accès permettant aux visuels de modifier le combat.
5. Afficher la compétence et ses caractéristiques dans la fiche, la proposer dans les
   listes de capacités de Mako, et conserver les règles sauvegardées. Un préréglage de
   recette place Allié → Booster en tête en conservant les autres ordres de Mako.
6. Tester la séquence initiale : Mako se buffe après 1,5 s, récupère à vitesse accélérée,
   puis caste sur Anne en ≈1,154 s. Quand les deux sont buffés, Foudre/Attaque deviennent
   à nouveau éligibles selon leurs propres règles. À expiration, le premier allié redevenu
   éligible est de nouveau pris en charge.
7. Couvrir cible morte, buff en cours, zéro/19/20 mana, allié absent, cible remplacée,
   critère ennemi, buff déjà acquis pendant le cast, sauvegarde et 100 ordres.

Acceptation : pas de spam de Booster sur Mako, pas de cumul/rafraîchissement, pas de paiement
sur annulation, aucune attente bloquante par manque de mana. Anne reste sans Booster dans
son catalogue initial ; tous les participants peuvent recevoir et exécuter l'effet temporel.

### GRAPHICS-010 — Montre procédurale et fondu commun

1. Extraire l'enveloppe actuelle du soin dans un composant passif commun : apparition
   smoothstep sur les premiers 6 % et disparition smoothstep de 36 à 100 % de la durée.
   Les valeurs de profil sont ajustables ; le soin conserve son rendu et sa durée de 1 s.
2. Construire une montre géométrique simple : cercle doré, graduations légères et deux
   aiguilles de longueurs différentes. Orientation lisible face caméra et ancrage à la
   cible en mouvement. Aucun modèle ou sprite externe nécessaire.
3. Accélérer rapidement les aiguilles au début de l'effet puis maintenir leur rotation ;
   calculer l'angle par intégration de la vitesse pour éviter tout saut. L'effet complet
   dure 2 s, utilise le fondu commun et reste translucide, avec contraste sobre sur les arènes.
4. Exposer taille, or, opacité, vitesses et accélération dans une définition visuelle séparée.
   Proposer des essais Godot comparables si un réglage de rendu est nécessaire, avant l'APK.
5. Déclencher une montre par application réussie, suivre le point d'effet du personnage,
   gérer disparition de la cible, pause, reset et destruction. Borner le nombre d'effets
   simultanés et garder les matériaux indépendants entre instances.
6. Tester le soin avant/après extraction du fondu, plusieurs montres en parallèle, zéro
   VFX en cas d'annulation, durée de 2 s, arrêt en pause et absence d'effet tardif après abandon.

Acceptation : la montre est lisible, accélère visiblement et disparaît dans le fondu du soin.
Les VFX et leur enveloppe n'appliquent ni le buff ni sa durée ; le combat reste leur source.

## UI-005 — Qualification enrichie

Recetter ensemble fiche Mako, Allié → Booster, sauvegarde immédiate, combat automatique,
panneaux et barres d'incantation, horloges à ×1,30, mana à vitesse normale, expiration à 60 s,
pause/reprise Android, abandon confirmé et Rejouer. Conserver l'arène sobre actuelle.
Faire une campagne couvrant l'expiration réelle des 60 s, l'application de nouveau, les
anciens gambits et les cycles de navigation ; relever seulement les performances mesurées.
Vérifier que la durée et la logique du buff restent identiques avec VFX désactivés.

## Cycle de travail

Chaque étape est livrable et recettable séparément, puis validée, commitée et sauvegardée
avec restauration/vérification avant le GO suivant. Les archives conservent sources,
historique, APK et preuves. Les tests protègent les règles précédentes ; les laboratoires
historiques gardent des contrats identifiés. Les statuts de combat ne sont pas sérialisés
dans la programmation des gambits et ne persistent pas entre deux combats.

Prochain GO après validation et clôture de GAMBITS-003 : BUFFS-001 uniquement.
