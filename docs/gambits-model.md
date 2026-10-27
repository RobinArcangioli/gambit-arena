# Extension GAMBITS-003 — Allié et candidats ordonnés

Catalogue de onze critères : ajout ally_roster, libellé Allié, sans seuil. Rang d'équipe
explicite partagé par UI et simulation ; sélection Mako avant Anne parmi les vivants.
Criteria.candidates expose des instantanés détachés ; choose garde le contrat de premier
candidat. Les capacités actuelles utilisent ce premier candidat ; les filtres de buffs
seront branchés dans BUFFS-002. Schéma v3 et anciens critères inchangés.
Voir [GAMBITS-003](steps/GAMBITS-003.md) et la [roadmap Booster](booster-roadmap.md).

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

# Intégration GAMBITS-002

Le modèle décrit ici est maintenant utilisé dans le parcours produit F5 / APK.
OrdersEditor partage l’édition et l’autosauvegarde entre fiche et combat.
Le mode v2 est conservé uniquement dans les laboratoires historiques.
Voir [GAMBITS-002](steps/GAMBITS-002.md) pour la migration, les tests et la recette.

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

# Modèle de gambits v3 et laboratoire — GAMBITS-001

## Contrat livré dans le modèle isolé

scripts/gambits/target_criteria.gd possède les dix identifiants et libellés du catalogue,
avec les cinq seuils stricts fixes. Soi-même n'a aucune condition de PV ; les alliés incluent
le lanceur et sont classés par ratio de PV le plus bas, puis distance, puis identifiant.
Les critères ennemis plus/moins de PV comparent des valeurs actuelles absolues, puis distance
et identifiant ; proche/lointain comparent les distances puis l'identifiant. Les morts sont
exclus, le résultat est une copie de l'instantané. Aucun paramètre éditable de seuil.

orders.gd valide exactement enabled, criterion et skill, les capacités du profil source,
les deux héros et les listes de 0 à 100 éléments. Toutes les associations critère/capacité
sont possibles dans le modèle, sans restriction de camp ni exclusion de soi-même.
create() donne Ennemi proche + Attaque, actif. Évaluation en priorité descendante : mana,
recharge et capacité disponible, cible choisie indépendamment de la capacité, puis soin
inutile sur cible pleine ignoré. Un soin ne choisit pas une autre cible pour contourner
le classement du critère. Aucun ordre exécutable : résultat vide, aucune attaque implicite.

## Format et sauvegarde

configuration_codec.gd écrit un objet version 3 et heroes, avec anne et mako et leurs listes.
Lecture bornée à 256 Kio, validation complète, parseur sans message moteur parasite sur
entrée invalide ; fichier temporaire unique, flush et renommage pour l'écriture.
configuration_store.gd recharge le fichier juste avant chaque save_hero, remplace uniquement
le héros demandé et publie son nouvel état seulement après succès. Toute mutation peut
ainsi être enregistrée immédiatement ; aucun brouillon ni commande Appliquer/Annuler
exposé par ce modèle. Une erreur garde le dernier état connu et retourne un code d'erreur.
L'interface de GAMBITS-002 devra montrer brièvement cet échec et restaurer l'état enregistré.

Lecture v2 : conversion détachée en mémoire, aucune écriture. Seuil inférieur disponible
le plus élevé, dont 80 → 70, 60 → 50, 20 → 10. Ennemis/Toujours deviennent Ennemi proche.
Les règles sans équivalent (allié/Toujours, ennemi/PV sous seuil, seuil allié < 10) sont
signalées dans notes et désactivées ; capacité et position conservées. Le rapport contient
la règle originale, le héros et l'index. À la première mutation d'un fichier v2, copie
originale octet pour octet dans <chemin>.v2.bak avant écriture v3. Une sauvegarde différente
déjà présente bloque l'écrasement. Les écritures ultérieures ne remplacent jamais cet original.
Un fichier existant invalide bloque l'enregistrement, sans retour silencieux aux défauts.

## Isolation de l'application actuelle

Les quatre composants ne sont raccordés à aucune route de l'application normale. Le banc
criteria_lab.gd réutilise seulement la coque visuelle de fiche et le routeur tactile existant.
Ses listes ouvrent explicitement leur popup sur pressed : le routeur synthétise ce signal
pour les boutons des zones défilantes, ce qui ne suffit pas à ouvrir un OptionButton natif.
Cette adaptation est locale au laboratoire ; le routeur et tous les anciens scripts de jeu
restent inchangés. Le banc n'instancie aucune simulation et n'exécute aucun effet.
Il écrit uniquement user://gambits_v3_lab.json à chaque choix de critère ou de capacité.

F5/Android normal restent en UI-004 : trois règles v2, anciennes restrictions et anciennes
commandes Appliquer/Annuler. Ce maintien temporaire est volontaire : GAMBITS-002 fera la
bascule simultanée du moteur, de la persistance et des deux éditeurs. Aucun personnage ne
peut encore infliger réellement Foudre à un allié dans l'application normale de cette étape.

## Vérification exécutée

Godot 4.7.2 Compatibility. 52 scènes / 3 461 contrôles réussis, aucune erreur/warning dans
leurs journaux. Nouveaux bancs target_orders_tests (99), orders_codec_tests (324) et
criteria_lab_tests (10) ; 49 bancs existants inchangés (3 028 contrôles).
Les tests couvrent les dix critères, 40 associations des capacités actuelles, stricte égalité
aux seuils, sélection déterministe, ratio vs PV absolus, source incluse, morts, listes vides,
100e ordre et refus du 101e. Ils couvrent tous les anciens seuils 0 à 100, les conversions
impossibles, les sauvegardes de deux fois 100 ordres, préservation de l'autre héros, relance,
protection des fichiers invalides/originaux, erreurs d'écriture et copies détachées.
Le banc tactile reproduit l'ouverture du popup via doigt + souris émulée, l'écriture isolée,
le blocage en arrière-plan, la reprise et la libération sans orphelin.

Captures GPU PC pilotées par script : Foudre/Anne, Soin/ennemi 120 PV et soi-même ; arrêt
sur perte de focus et zéro orphelin. Le pilote NVIDIA hôte échoue à charger puis AMD Mesa
rend correctement. Rendu piloté, pas recette manuelle PC. Aucun nouveau FPS mesuré.
APK normal 0.1.0-gambits001 (48), SHA-256 `b2a8e4defb65f46d41ebbd4f91cf57dcf85c8d066f58291943cad4d06e1c073e`.
APK laboratoire 0.1.0-gambits001-lab (48), SHA-256 `bfa7b4781efa728a54ebebaf5cefa71facd46a1adc07d8a13e85050bbe4eeb97`.
Le laboratoire est exporté depuis une copie temporaire par tools/export_gambits_lab.py ;
project.godot du projet reste identique au checkpoint UI-004.

Galaxy A16 : catalogue ouvert au doigt, choix Allié/PV < 30 % pour Mako/Foudre puis Ennemi
lointain pour Anne/Soin, vérification du fichier isolé v3, réinstallation de l'APK normal.
Le changement de héros est effectué au clavier ADB dans le popup ; les critères sont choisis
au doigt. Journal du laboratoire final et journal normal joints. Règles de jeu v2 comparées
avant/après et identiques ; téléphone laissé sur l'accueil normal. Aucun transfert de la
configuration du laboratoire vers la partie. Recette utilisateur encore attendue.

## Recette utilisateur

F6 scenes/debug/gambits_criteria_lab.tscn : changer le personnage, le critère et la capacité,
observer la cible et la démonstration 80 → 70. Le tableau est un instantané et aucun effet
n'est exécuté. F6 des trois scènes de tests citées, F8 entre les bancs. F5 conserve le parcours
normal. L'APK labo remplace temporairement l'application normale : réinstaller l'APK normal
joint pour revenir au jeu, sans effacer les données. Ne pas attendre les lignes finales de
100 ordres dans cette étape : elles seront livrées dans GAMBITS-002.
