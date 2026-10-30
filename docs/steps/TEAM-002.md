# TEAM-002 — Échanges de cartes et incantations cyan

Statut : validée sur Galaxy A16 le 30 octobre 2026 : « Oui, étape validée ».
Base : TEAM-001, 89c6543f31dfe7a39cd71f3ea0d42d0e1273bf05.
GO du 30 octobre 2026 : réorganisation et changement du seul coloris des sorts.

## Geste et sauvegarde

Maintenir 450 ms puis déplacer vers une autre carte pour échanger les emplacements,
y compris depuis ou vers Vide. Un clic bref ouvre toujours la fiche par identifiant.
Un mouvement de plus de 12 px avant le maintien annule le clic. Relâcher hors d’une
carte ou sur la source après maintien ne déclenche rien. Un deuxième doigt, une
annulation système, un changement de dimensions, une perte de focus ou une mise en
veille annulent aussi. Retour Android annule d’abord le geste ; un retour ultérieur
quitte la page. Les copies souris des événements tactiles sont absorbées, sans
changer l’émulation configurée dans project.godot.

team_drag.gd contient uniquement l’état d’un pointeur et le seuil du geste.
TeamPage capture les événements réels du viewport, présente une illustration 2D
translucide et un contour or sur la destination, sans nouveau viewport 3D. Les cartes
et les miniatures conservent leurs dimensions, cadrages et styles approuvés. La case
vide est activée pour le geste ; son clic reste sans effet. Aucun surlignage durable.

AppRoot traite la demande d’échange. Il écrit les quatre identifiants avec
TeamComposition.save_slots avant de publier la composition et de reconstruire les
cartes. Si l’écriture échoue, ancien ordre conservé et message « Échange non enregistré.
Réessaie. ». Aucun Appliquer/Annuler. Les gambits ne sont pas déplacés ni réinitialisés.
La sauvegarde est relue aux lancements suivants. Au prochain combat : panneaux,
formation à quatre places fixes avec trous et critère Allié utilisent l’ordre sauvegardé.
Les positions et états restent inchangés entre les vagues.

## Barres

Le style partagé d’incantation utilise #8befff, cyan clair. Il s’applique aux sorts
dans les panneaux et au-dessus des personnages, avec les mêmes épaisseurs, longueurs,
glows et réglages de visibilité. Les textes restent blancs. Le shader distingue
maintenant explicitement le doré de préparation de l’attaque du cyan des sorts.
Argenté de récupération, séparation par l’épée et chronologie de l’attaque inchangés.
Ni durées ni actions de la simulation modifiées.

## Contrôles exécutés

73 scènes / 5 444 contrôles réussis, dont 97 dédiés à TEAM-002 à 540×960, 540×1170
et 360×640. Le premier passage du nouveau banc contrôlait la formation après deux
frames de combat : six assertions de position échouaient parce que les héros avaient
déjà avancé. Le banc fige désormais la simulation avant sa première frame ; ses
94 contrôles ont réussi. Trois contrôles supplémentaires vérifient le premier delta
de reprise : un appui frais ne doit pas devenir instantanément un maintien. La protection
est renforcée et les 73 scènes ont été relancées : 97 contrôles TEAM-002 réussis.
Tests de gestes injectés au viewport avec leur copie souris, souris physique simulée,
seuil, annulations, échec d’écriture, clic après déplacement, sauvegarde immédiate,
relance d’application, absence d’orphelins, panneaux/formation/ciblage Allié et cyan.
Les anciens bancs de page Équipe, palette et attaque sont adaptés au périmètre demandé.

Captures Godot GPU : cartes, aperçu de déplacement et sorts/attaque côte à côte.
Laboratoire scenes/debug/team_reorder_lab.tscn, mémoire uniquement : Équipe,
Formation, Combat et Sorts / Attaque. Aucune sauvegarde joueur lue ou écrite.
Aucune nouvelle mesure FPS.

Android : APK 0.1.0-team002 (84), team-002-debug.apk.
SHA-256 : 1f9990a5fac1666785df617c42a3b8729187f81a5e16a6a6ff05797fb7ddfcc3.
Installation avec conservation des données ; cyan et attaque dorée/argentée constatés
en combat sur Galaxy A16. Maintien explicite, aperçu, contour or et échange Mako/Anne
vérifiés sur l’appareil, avec écriture immédiate du nouvel ordre. Les essais natifs de
case vide et de relance n’ont pas été confirmés dans une séquence sans interruption :
changements de page et de composition pendant la recette. L’ordre final est conservé,
sans rétablissement forcé. Les gambits et réglages sont identiques aux octets initiaux.
La case vide et la relance passent dans les bancs moteur. Le propriétaire a ensuite
validé globalement la version Android, sans compte rendu détaillé par scénario.
Clôture documentaire uniquement : code, ressources et APK identiques à la livraison
validée. Aucun nouveau test ni relevé FPS. Commit local et sauvegarde complète restaurée
et vérifiée ; aucun push automatique. Prochain GO : UI-005, puis STEP-029/030.

## Recette propriétaire

Équipe : maintenir Mako, déposer sur Anne ; vérifier l’échange et le clic bref vers
la bonne fiche. Échanger avec Vide. Relancer et vérifier la persistance. Mode Infini :
vérifier les places, les panneaux et l’ordre des buffs de Nassau. Comparer le cyan du
Soin/Foudre/Booster aux attaques toujours dorées et argentées. Tester retour Android
pendant le maintien, annulation hors des cartes et reprise après mise en veille.
