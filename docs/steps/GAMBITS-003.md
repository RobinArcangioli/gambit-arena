# GAMBITS-003 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » : critère Allié sans condition, ordre
Mako puis Anne parmi les vivants, lanceur compris, et candidats classés préparés
pour les buffs. Catalogue de onze critères, sauvegarde v3 immédiate conservée.
Résultats de la recette précédente : 55 bancs / 3 644 contrôles réussis et recette
tactile Android ; réglages d'origine restaurés. Aucun nouveau test moteur pour
cette clôture documentaire, aucune modification du code ou de la configuration.
APK validé : 0.1.0-gambits003 (54), SHA-256
`cbe4b7c0b65b9f305aab866c1d563b40f900b1a3902088d24294e3cfa5a086a5`.
Les fichiers temporaires de livraison et l'APK local de la recette précédente ne
sont plus disponibles ; leur empreinte ci-dessus est celle consignée à la livraison.
La clôture sauvegarde les sources et l'historique Git, sans recréer cet APK.
Prochain GO : BUFFS-001 (états de buffs et horloge personnelle), puis BUFFS-002,
GRAPHICS-010 et UI-005. Les descriptions antérieures ci-dessous sont historiques.

# GAMBITS-003 — Critère Allié et ordre d'équipe — en recette

Roadmap Allié / Booster validée par le GO du propriétaire. Première étape implémentée :
critère « Allié » sans condition, candidats ordonnés et rang d'équipe explicite. Mako précède
Anne, y compris si Anne est le lanceur. L'ordre de traitement Anne puis Mako ne change pas.
Catalogue de onze critères ; sauvegarde immédiate v3 et défaut Ennemi proche conservés.
55 bancs / 3 644 contrôles réussis sans erreur ni avertissement moteur ; captures GPU PC
et recette Android dans la livraison. Aucun nouveau benchmark FPS.
APK 0.1.0-gambits003 (54), SHA-256 `cbe4b7c0b65b9f305aab866c1d563b40f900b1a3902088d24294e3cfa5a086a5`.
Base clôturée : ARENA-001 `15bf1f5cc21c1334491f3fa43e2cc04edd9f30bc` (706 fichiers vérifiés).
Le plan préparé après cette clôture est inclus dans la livraison de GAMBITS-003.
Étape en attente de validation, commit et sauvegarde vérifiée. Prochain GO : BUFFS-001,
puis BUFFS-002, GRAPHICS-010, UI-005 et STEP-029/030. Booster et l'horloge personnelle
ne sont pas encore implémentés. Les états précédents ci-dessous sont historiques.

## Comportement livré

Le critère `ally_roster` porte exactement le libellé « Allié », sans seuil. Il figure après
Soi-même dans les menus. Il inclut le lanceur, ignore les morts et classe les participants
par leur emplacement d'équipe : Mako 0, Anne 1. Distance, PV, ordre de création et ordre
interne de traitement du moteur ne modifient pas ce classement. Les places vides n'ont
pas d'acteur et n'entrent pas dans les candidats ; une ligne non classée est ignorée.
Les rangs identiques, en fixture, sont départagés par l'identifiant stable de combat.

Le critère peut être associé à toute capacité disponible pour le héros, comme les autres.
Avec Allié → Soin, Anne cible Mako en premier ; si ce premier candidat a ses PV pleins,
le soin est indisponible et le gambit suivant est évalué. Anne n'est pas choisie à sa place.
Les critères Allié — PV < … conservent leur classement par pourcentage de PV. Ce comportement
préserve la séparation critère/capacité actuelle. L'exclusion des cibles portant déjà un
buff sera introduite avec BUFFS-002, quand Booster sera disponible.

## Modèle et architecture

PartyRoster est un module logique sans ressource graphique. Il définit les quatre slots
partagés avec TeamRoster, l'adaptateur d'affichage existant. PartyUnit porte un team_slot
de combat ; PartySimulation le renseigne depuis le roster et le copie dans les instantanés.
Les ennemis reçoivent un rang stable de création dans leur propre équipe. Aucun ordre de
boucle de combat ni placement initial n'est changé.

Criteria.candidates fournit la liste complète de valeurs détachées, classée selon le critère.
Criteria.choose reste compatible et renvoie le premier candidat. Orders utilise cette liste
et son premier élément : BUFFS-002 pourra y filtrer l'éligibilité du buff avant de sélectionner
la cible, sans mêler buffs ou présentation au classement. Les dix classements précédents
sont conservés, notamment PV ennemis absolus et départages par distance puis identifiant.

Les rangs d'équipe ne sont pas des paramètres de gambits et ne sont pas sérialisés dans
les ordres. Le format reste version 3, avec enabled / criterion / skill. Les critères sont
stockés par ID stable, pas par index de menu ; les anciens critères et sauvegardes gardent
leurs valeurs. La migration v2 reste identique et ne réactive pas d'anciens ordres désactivés.
Les limites de 0–100 ordres et l'autosauvegarde, y compris restauration après échec, demeurent.

Le laboratoire F6 scenes/debug/gambits_criteria_lab.tscn affiche maintenant la liste ordonnée
des candidats et la cible choisie. Ses fixtures ont un rang logique Mako puis Anne ; elles
écrivent toujours dans le fichier isolé gambits_v3_lab.json. Il n'exécute aucun sort réel.

## Vérifications

55 scènes / 3 644 contrôles, zéro erreur/avertissement moteur. Nouveau banc
scenes/tests/roster_targeting_tests.tscn : 46 contrôles (classement, source incluse, rangs
manquants/invalides, alliés morts, futurs slots occupés, valeurs détachées, anciens classements,
ordre réel de création Anne/Mako, replay, persistance v3, 100 ordres et vrai tactile).
Les tests de catalogue couvrent les onze critères et les combinaisons de capacités ; les
sélections du laboratoire utilisent les IDs pour ne pas dépendre des indices du menu.

Les captures GPU PC montrent Mako puis Anne dans les candidats, quel que soit le lanceur,
et Allié dans l'éditeur produit. Ce sont des contrôles pilotés, pas une validation manuelle
PC du propriétaire. Rapport natif et images Android dans verification/ de la livraison ;
la configuration privée du téléphone est restaurée après les essais réversibles et exclue
des archives. L'APK livré est celui installé et son empreinte est vérifiée sur l'appareil.

## Recette propriétaire

F5 : Équipe → Anne ou Mako → Gambits → choisir Allié dans la liste ; revenir et rouvrir.
Vérifier le choix sur le téléphone et le chargement au prochain combat. Pour inspecter le
classement sans modifier la partie : F6 scenes/debug/gambits_criteria_lab.tscn, choisir Allié
puis Mako ou Anne ; dans les deux cas, candidats Mako → Anne. F8 entre les bancs.
Booster arrivera après BUFFS-001 puis BUFFS-002 ; seules les capacités actuelles sont proposées.
