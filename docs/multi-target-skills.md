# Traits de glace — MULTI-001

Validée sur Galaxy A16 : « Oui, MULTI-001 validée ». Choix Godot/Android :
**B — Givre lumineux**. Base : LOGO-001, commit `2f990b45ae59`.
Clôture documentaire ; aucun changement du code ou de l’APK après validation.

## Contrat

Mako reçoit Traits de glace : 20 PM, 30 PV retirés par cible sans réduction par
la défense, 1,5 s d’incantation, 3 s de recharge à la libération, portée 4.
Maximum de trois victimes distinctes ; secondaires dans un rayon de 2,5 unités
entre centres au sol autour de la cible principale, classées par distance puis ID.
Cette portée multi est indépendante du rayon des AOE et des gabarits physiques.

Les critères fixes « 2 ennemis ou plus », « 3 ennemis ou plus » et
« 4 ennemis ou plus » utilisent les métadonnées de la compétence associée.
Pour une compétence multi : exiger au moins m ennemis vivants, puis k=min(n,m).
Choisir le plus proche ennemi ayant k-1 autres ennemis à portée multi, sans
maximisation. Une paire proche l’emporte donc sur un triplet plus éloigné avec
le seuil 2. Le seuil 4 exige quatre vivants mais seulement trois couvrables.
Pour une AOE, conserver la maximisation géométrique existante et comparer le
nombre couvert au seuil demandé ; aucune confusion entre les deux résolveurs.

Pendant l’approche, tous les gambits sont réévalués à chaque pas, puis avant
engagement : un ordre prioritaire peut interrompre le déplacement. Durant le
cast, la baisse du nombre ou la dispersion des ennemis n’annule pas le sort.
Seule la perte/mort ou sortie de portée de la cible principale annule sans PM,
recharge ni récupération. Mort du lanceur et reset suivent les protections communes.

À la fin du cast, conserver la principale et choisir jusqu’à deux secondaires
actuellement proches. La liste est alors définitive. Débiter une fois 20 PM et
lancer la recharge. Trois cristaux apparaissent et orbitent 0,34 s, puis volent
0,24 s vers les victimes choisies ; un cristal sans victime se dissipe sur place.
Chaque impact retire jusqu’à 30 PV effectifs. Une victime morte n’est jamais
remplacée : le projectile rejoint sa dernière position connue sans dégât.
Les projectiles libérés suivent leur victime mais ne recalculent aucune liste,
aucun voisinage ni aucune condition de portée. Ils survivent à la mort du lanceur,
respectent la pause et sont supprimés au reset ou à la fin du combat.
Booster accélère cast/recharge, pas le temps de vol ni la régénération des PM.

## Séparation logique / présentation

- `scripts/skills/multi_skills.gd` : paramètres et sélection finale déterministe.
- `scripts/gambits/orders.gd` : résolution des seuils et choix de la principale.
- `scripts/party/party_executor.gd` : engagement, annulation, paiement et lancement.
- `scripts/skills/area_projectiles.gd` : file commune des sorts libérés, avec
  victimes multi verrouillées (références faibles + état d’origine). Protection
  contre la réentrance et les callbacks de mort/reset.
- `scripts/presentation/ice_bolts_effect.gd` et `ice_bolts_presenter.gd` : cristaux
  facettés, fines arêtes lumineuses, traînées et éclats, entièrement procéduraux.
  Ils consomment seulement des faits et positions ; aucun pouvoir sur les dégâts.
- Icône fournie copiée sans retouche depuis
  `/home/arkhane/Downloads/Ice_bolts_Icon.png` vers
  `assets/art/skills/ice_bolts.png`, mipmaps pour les petits gabarits.

Fiche de Mako, listes de compétences, gambits, icône d’incantation, barres cyan,
énergie d’incantation, Duck, dégâts flottants, statistiques et journal sont reliés.
Le codec reste en v4 : aucune migration ni réécriture automatique des sauvegardes.
Les nouvelles configurations ont le gambit seuil 2 en première ligne de Mako.
Pour la recette Android du propriétaire, ajout explicite de cette seule ligne,
après sauvegarde de ses fichiers, sans modifier les autres ordres.

## Recette

F6 : `scenes/debug/ice_bolts_lab.tscn` ; fenêtre portrait et colonne de commande.
Profil Berserk Rouge et noir, sauvegardes et réglages uniquement en mémoire.
Trois intensités A/B/C ; B sélectionnée par le propriétaire.
Scénarios : trois victimes, deux victimes, seuil 4 non atteint, seuil 4 avec quatre
présents, principale morte pendant cast, secondaire morte en vol, approche
interrompue par une Foudre prioritaire. Boucle, replay et pause/lecture disponibles.

81 scènes / 6 029 contrôles consolidés réussis, dont 46 pour Traits de glace.
Captures GPU des trois variantes, orbite/vol/impact ; aucune erreur moteur.
Les anciens tests ont été actualisés pour les 14 critères et les trois compétences
de Mako. Tests supplémentaires : sauvegarde v4, frontières, non-maximisation,
coût unique, dégâts fixes, pause, Booster, annulation, absence de remplacement,
réinitialisation pendant un callback létal, nettoyage sans nœuds orphelins.

## Livraison validée

APK `multi-001-debug.apk`, v93 `0.1.0-multi001`.
SHA-256 : `f7b5d310200137b10b17e4d76e14c37f2d937280607f19faa40b47e58e2c51bf`.

Installation sur Galaxy A16 avec conservation des fichiers. Une seule ligne a été
ajoutée en tête des gambits de Mako, comme demandé ; Anne et Nassau inchangés.
Équipe, réglages de combat et style conservés par empreinte avant/après. Une seconde
installation du correctif « −0,0 s » préserve les quatre fichiers à l’identique.
Séquence native enregistrée, aucune erreur moteur ; jeu laissé en pause.
Le propriétaire confirme le rendu et le fonctionnement Android. Pas de mesure FPS.
Commit local puis sauvegarde complète restaurée/vérifiée. Aucun push automatique.
