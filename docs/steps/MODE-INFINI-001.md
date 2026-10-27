# MODE-INFINI-001 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour le premier mode Infini : vagues de six,
attente de trois secondes, compteur, départs sud-ouest/nord-est et nouveau décor aux
vagues 11, 21, 31… avec conservation des héros et de leurs états.
Les 61 bancs / 4 124 contrôles et la recette Godot/Galaxy A16 avaient déjà réussi.
Clôture documentaire uniquement : code, scènes, profils, configuration et les deux APK
restent identiques à la livraison validée. Pas de nouvelle exécution des tests.
APK normal installé : `0.1.0-infinite001` (61), SHA-256
`7b4346c28e9b056f0f3cbaf0e32925e571f8f5ac99fcc964f9ada82071c5afcd`.
Gambits conservés. Clôture par commit et sauvegarde complète restaurée/vérifiée.
Prochain GO : UI-005, qualification intégrée Android incluant le mode Infini, puis
STEP-029/030. Aucun push automatique. Les états précédents ci-dessous sont historiques.

# MODE-INFINI-001 — Premier mode de jeu Infini

Statut : en recette, validation utilisateur attendue. Base : FIX-COMBAT-001 clôturée,
`7d8530d4d1180226fdb4c3b3abd7601572527ed4`. Demande directe du propriétaire.

## Règles et conservation

Le seul bouton de combat de l'accueil s'appelle « Mode Infini ». Le mode commence à
la vague 1, avec six squelettes présents ensemble. Aucun renfort partiel : attendre la
mort des six, puis trois secondes entières de temps de combat avant le lot suivant.
Les vagues continuent sans plafond ; pas de victoire automatique. Défaite quand aucun
héros n'est vivant. Rejouer recommence une partie complète à la vague 1 ; Abandonner
conserve sa confirmation puis revient à l'accueil et détruit la simulation.

Au départ seulement, les héros sont placés au sud-ouest de la caméra isométrique ;
les ennemis apparaissent au nord-est à chaque vague. Seize positions espacées de 0,85
sur la grille offrent six places libres même lorsque les deux héros occupent cette
zone. Sélection de six places avant toute création, rayon de collision respecté,
aucun déplacement forcé d'un héros pour faire apparaître un ennemi.

La simulation, les objets héros et leurs états ne sont jamais reconstruits entre les
vagues. PV, mana, buffs, actions, délais et positions restent ceux du combat. Le temps
continue pendant l'attente : régénération normale, récupération et recharges personnelles,
expiration des buffs et gambits alliés applicables. Un mort n'est pas ressuscité.
Pause et arrière-plan passent par la même horloge : aucune seconde de délai consommée
pendant l'arrêt, aucune avance massive au retour. Le pas accepté reste borné à 1/30 s.
Les historiques d'ennemis terminés sont purgés à la transition pour éviter leur
accumulation indéfinie, sans réinitialiser animations ou effets actifs des héros.

## Présentation séparée

La logique de délai/formation est dans `scripts/waves/infinite_schedule.gd` et son
activation dans `PartySimulation` est explicite. Les anciens bancs restent en mode
historique par défaut ; seule la route produit et le nouveau laboratoire l'activent.
La simulation ne charge ni décor ni contrôles. La page observe le numéro de vague et
pilote le décor séparément. Un tirage visuel privé choisit une des huit arènes éligibles
au départ ; chaque tranche terminée de dix vagues déclenche un autre tirage excluant le
décor courant. Changements aux vagues 11, 21, 31… sans reset de simulation, aucune
consommation du générateur aléatoire de gameplay. La grille/caméra restent calibrées.

Le compteur « Vague N » se place sous les deux rangées de panneaux. En attente, les
chiffres 3, 2, 1 sont centrés sur l'origine visuelle du sol, en or avec contour bleu,
et restent dans l'espace visible sous le compteur aux plus petits formats. Aucun zéro
intermédiaire ; disparition au lancement du nouveau lot. Après défaite, le compteur
l'indique ; le menu Pause propose Rejouer / Abandonner et désactive Reprendre.
Les quatre panneaux, barres et styles précédemment validés sont conservés.

## Vérifications

- 61 bancs / 4 124 contrôles sans erreur ni avertissement moteur, dont 70 nouveaux :
  lot complet, dernier ennemi, délai exact, pause, données invalides, vagues jusqu'à 25,
  identité/PV/mana/buffs/positions/recharges conservés, placements non superposés,
  défaite en attente, aucun redémarrage après défaite, rejouer, abandon et mémoire bornée.
- Route produit et dispositions testées en 540×960 et 360×640 ; tirages privés,
  non-répétition du décor, transitions 10/11 et 20/21 et absence de tirages en trop.
- GPU Godot : départ, 3/2 et vague 11, acteurs et états identiques, zéro nœud orphelin.
- Galaxy A16 : placement six ennemis / deux héros, attente or/bleu, pause avec captures
  identiques, retour d'arrière-plan encore en pause, reprise et passage à la vague 11
  dans un décor différent. APK laboratoire puis normal installés et SHA vérifiés.
  Configuration joueur inchangée octet pour octet. Aucune erreur native ni nouvelle
  mesure de performances. Le laboratoire accélère uniquement la recette par ses
  commandes explicites, jamais le mode normal.

## Recette et livraison

F6 : `scenes/waves/infinite_lab.tscn`. Départ figé pour inspecter les formations.
« Jouer / figer » lance/arrête le laboratoire. « Fin de vague » tue le lot courant.
« 10 → 11 » prépare le changement de décor. Lancer le temps pour voir 3/2/1 puis le
nouveau lot. F8 avant F5. F5 garde l'accueil produit et le bouton « Mode Infini ».
Banc automatisé : `scenes/tests/infinite_mode_tests.tscn` → 70 contrôles, 0 échec.

APK normal `0.1.0-infinite001` (61), installé :
`7b4346c28e9b056f0f3cbaf0e32925e571f8f5ac99fcc964f9ada82071c5afcd`.
APK laboratoire `0.1.0-infinite001-lab` (61) :
`386efa539b014466eb5ae9e756ff5c97376a5231b6c56bcfb3223d27490b5d1e`.
Export laboratoire isolé sans modifier Main :
`python3 tools/export_infinite_lab.py --godot /chemin/godot --output /chemin/lab.apk`.

Archive complète sans `.git/.godot`, historique séparé à la base `7d8530d`, deux APK,
manifestes et preuves restaurés/vérifiés. Les changements du mode ne sont pas encore
commités dans le bundle de base. Validation utilisateur avant commit et sauvegarde
complète de clôture ; aucun push automatique. Ensuite UI-005, puis STEP-029/030.
