# Compétences de zone — roadmap

Base : TEAM-002 clôturée, commit 842124021a8feb3528181d94a22290115d2c9d10.
AOE-001 validée sur Galaxy A16 le 30 octobre 2026. AOE-002 validée sur Galaxy A16 : profil C Intense.

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

Validée. Icône PNG fournie intégrée. Après les 3 s d’incantation, paiement et
recharge au lancement, chute rouge/rose profond pendant 1 s, puis explosion de 1 s.
Les victimes sont calculées et les dégâts appliqués au début de l’explosion.
La file logique de projectiles est détenue par le combat, indépendante du lanceur
et des vues. Centre figé dès l’incantation ; aucun nouveau ciblage pendant la chute.
Chute en temps normal de combat, pause respectée ; reset/fin du combat annulent
les projectiles restants. Une fois lancé, le météore survit à la mort de son lanceur.
L’explosion reçoit un fait d’impact, jamais l’autorité d’appliquer des dégâts.
Roche, traînée, halo, anneaux et fragments entièrement procéduraux ; fondu commun.
C Intense retenu dans Godot après correction du choix initial B. Android v86 validé :
« Oui, AOE-002 validée ». Clôture documentaire sans modification de code ou APK.

Après les deux étapes : UI-005, puis STEP-029 et STEP-030.

## AOE-002-FIX1 — Refonte et annulation de zone vide

Validée sur Galaxy A16 : « Oui, AOE-002-FIX1 validée ».
Choix Godot : Flash compact, Rouge accentué puis C Avec braises.
Roche et flammes rouges avec fins filets rose profond ; impact blanc en demi-sphère,
volutes rouges, onde enflammée et braises. Chute 0,77 s (vitesse +30 %), explosion 1 s.
Contrôle toutes les 0,5 s de temps de combat pendant le cast uniquement : zéro ennemi
vivant dans le disque fixe → annulation sans PM ni recharge, puis gambits réévalués.
Après lancement, aucun contrôle d’annulation pour zone vide. Le ciblage et les dégâts
restent indépendants de l’art. Deux APK v87 installés et validés ; préférences conservées.
Clôture documentaire sans changement de code ni d’APK, commit local et sauvegarde vérifiée.
UI-005 reste l’étape suivante après clôture de ce correctif.
