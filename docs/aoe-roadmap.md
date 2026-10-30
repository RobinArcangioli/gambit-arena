# Compétences de zone — roadmap

Base : TEAM-002 clôturée, commit 842124021a8feb3528181d94a22290115d2c9d10.
AOE-001 validée sur Galaxy A16 le 30 octobre 2026. AOE-002 attend le prochain GO.

## AOE-001 — Mécanique et ciblage au sol

Validée : « Oui, AOE-001 validée ». Anne conserve Attaque et Soin, reçoit
Météore : 40 PM à la résolution, 40 PV par ennemi sans défense (perte effective plafonnée
aux PV restants), rayon 1,4, incantation 3 s, recharge 4 s au lancement effectif.
Portée de tous les sorts : 4 unités jusqu’à la cible ou au centre au sol.

Critère « Groupe de 3 ou plus » : maximum exact de points ennemis dans le rayon
fourni par la compétence. Géométrie au sol, sans dépendance à l’image d’arène ou à
la grille. Recentrage par le cercle minimum contenant ; rayon de dégâts inchangé.
Égalité : groupe poursuivi s’il est encore maximal, puis centre proche, puis IDs stables.
Pas d’AOE associée, pas de groupe de trois, PM insuffisants ou recharge : gambit suivant.

Pendant l’approche, réévaluer toute la liste, donc un soin prioritaire interrompt
l’approche de Météore. Revérifier après mouvement avant l’engagement. Au début de
l’incantation, conserver un point fixe indépendant de tout acteur : ni réorientation,
ni annulation parce qu’un membre du groupe meurt. À l’impact, interroger les ennemis
vivants actuellement dans le rayon. Ils peuvent être entrés ou sortis depuis le choix.
Zone vide : lancement, paiement et recharge maintenus. Mort du lanceur, abandon,
reset et pause suivent les protections communes. Booster accélère cast et recharge,
pas la régénération de PM.

Intégration : fiche d’Anne, liste des capacités et critères, icône fonctionnelle,
barres cyan, Duck, énergie bleue, dégâts flottants, statistiques et journal par victime.
Les gambits v4 restent intacts : pas de migration ni d’insertion silencieuse dans une
sauvegarde. Laboratoire sans sauvegarde : Soin allié <50 %, Groupe ≥3 → Météore,
Attaque. Scénarios groupe stable, soin prioritaire et zone vidée. Application Android
de laboratoire séparée du jeu normal. Recette et preuves dans docs/steps/AOE-001.md.

Le cercle or montré dans le laboratoire est conservé en production pendant les
incantations AOE, à la demande du propriétaire. Réglage « Afficher zone AOE »,
activé par défaut et mémorisé avec les préférences de combat. Le masquer ne change
ni le ciblage, ni le rayon, ni les dégâts. Aucune zone pour les sorts monocibles.

## AOE-002 — Présentation finale de Météore

Non commencée. Générer le météore entièrement dans Godot : roche facettée, matière
mate et incandescente, traînée, chute depuis le haut et impact circulaire avec particules.
Ressources et adaptateur de présentation indépendants de la simulation. L’effet reçoit
le point fixe et les événements de cast/résolution/annulation ; il ne calcule ni cibles
ni dégâts et ne décide pas du moment de paiement. Synchroniser l’impact visible avec
l’impact logique, réutiliser le fondu commun, borner les instances et nettoyer aux resets.
Affiner l’icône et conserver l’indicateur de zone optionnel demandé. Proposer le rendu dans Godot,
puis vérifier lisibilité, pause/reprise et charge sur Galaxy A16 avant validation.

Après les deux étapes : UI-005, puis STEP-029 et STEP-030.
