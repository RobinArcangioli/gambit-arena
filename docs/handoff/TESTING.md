# ARENA-003 validée — 29 octobre 2026

Le propriétaire confirme sur Galaxy A16 : « Oui, step validée » pour les statistiques,
le MVP et le journal. Deux boutons indépendants sans chevron ; menus pleine largeur,
statistiques en colonnes Héros / Ennemis. Bordures alignées sur les panneaux héros,
espace inférieur de 12 px. MVP magenta, score dégâts effectifs + soins effectifs.
Journal continu des 1 000 dernières entrées en RAM, Direct et pause/lecture intégrée.
Horodatages mm:ss.mmm, mentions de non-paiement retirées et récupération d’Attaque omise.
Les 65 scènes / 4 451 contrôles et la recette Android avaient déjà réussi.
Clôture documentaire seule : code, ressources, configuration et APK identiques à
la livraison validée ; aucune nouvelle exécution des tests ni mesure de performances.
APK installé : `0.1.0-arena003-journal` (70), SHA-256
`0d33882137b374f25164d328a33f5642b28e6b66510982666002221af2e225dc`.
Gambits conservés octet pour octet ; pause et scroll du journal vérifiés sur Galaxy.
Clôture par commit et sauvegarde complète restaurée/vérifiée. Aucun push automatique.
Prochain GO : UI-005, qualification intégrée Android, puis STEP-029/030.
Les états précédents ci-dessous sont historiques.

## ARENA-003 — Banc supplémentaire

`scenes/tests/combat_statistics_tests.tscn` : 130 contrôles sur statistiques effectives,
MVP, cache RAM 1 000 entrées, reset vague/combat, journal continu, deux boutons sans
chevron et menus pleine largeur, colonnes indépendantes, pause/lecture et scroll tactile
540×960 / 360×640. Suite totale exécutée : 65 scènes / 4 451 contrôles, zéro échec.
Rendu GPU et recette Galaxy séparés des tests headless : voir docs/steps/ARENA-003.md.
Validation propriétaire attendue. Aucun journal joueur sur disque.

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

# UI-004 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour les gambits hors combat et le correctif
Équipe : cartes en accès direct, sans sélection persistante. Validation globale sans
précisions supplémentaires. APK normal 0.1.0-ui004 (47), SHA-256
`527b5cb468049fef6bd421ec4b756d85edc0c6cf950278085f957024b13f74b7`.
Seuls les documents sont actualisés ; code, scènes, assets, configuration et APK restent
identiques à la livraison validée. Les 49 bancs / 3 028 contrôles déjà réussis ne sont pas
relancés. Aucune nouvelle mesure FPS. Les réglages Android initiaux restent conservés.
Clôture par commit unique et sauvegarde restaurée/vérifiée. UI-005, recette intégrée du
parcours complet PC/Android, attend le prochain GO ; puis STEP-029 et STEP-030.
GAMEPLAY-003 reste annulée. Les mentions de recette ci-dessous sont historiques.

# UI-004 — Gambits hors combat et correctif Équipe en recette — 27 octobre 2026

GO reçu après UI-003 clôturée au commit `c8497aac5760bc4672c80cdff7f80745749e3a49`.
F5 → Équipe → héros → Gambits : trois règles éditables, activation, ordre, compétence,
condition et seuil. Appliquer enregistre et revient à la même fiche ; Annuler/Retour
abandonnent le brouillon. Même fichier party_rules_v2.json et validation que le combat.
L'arène recharge ces règles ; les modifications d'un héros préservent celles de l'autre.
Correctif demandé : plus de texte, surlignage ou état de sélection persistant dans Équipe.
Les cartes ouvrent directement leur fiche ; le retour libère leur focus. Identité conservée
uniquement pour router la bonne fiche et les gambits. Fonds et thème nuit/or conservés.
49 bancs / 3 028 contrôles réussis ; captures GPU PC et recette native Galaxy A16.
APK 0.1.0-ui004 (47), SHA-256 `527b5cb468049fef6bd421ec4b756d85edc0c6cf950278085f957024b13f74b7`.
Téléphone laissé sur les gambits d'Anne ; réglages Android initiaux rétablis à l'identique
après essais de sauvegarde/annulation/relance. Aucun changement de logique de combat.
Voir docs/gambits-page.md et docs/steps/UI-004.md. Validation attendue, aucun commit UI-004.
Après validation : commit et sauvegarde vérifiée ; GO suivant pour UI-005, puis STEP-029/030.
GAMEPLAY-003 reste annulée. Les états précédents ci-dessous sont historiques.

# UI-003 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour les fiches de personnage, avec un correctif
UX demandé pour la prochaine étape UI-004 : supprimer le surlignage et le texte de sélection
sur Équipe, ainsi que leur persistance au retour. Les cartes deviennent de simples accès
aux fiches ; l'identifiant du héros reste transmis pour ouvrir la bonne fiche et ses gambits.
Ce correctif est planifié, pas appliqué dans la clôture de UI-003.
APK normal 0.1.0-ui003 (46), SHA-256
`2d10e45f9d5622a479def8ad64e4f2e38083527c3613ea010bcb5052b364d6f0`.
Seuls les documents sont actualisés ; code, scènes, assets, configuration et APK restent
identiques à la livraison validée. Les 47 bancs / 2 920 contrôles déjà réussis ne sont pas
relancés. Aucune nouvelle mesure FPS. Clôture par commit unique et sauvegarde vérifiée.
UI-004 attend le prochain GO : gambits hors combat et correctif Équipe ci-dessus.
GAMEPLAY-003 reste annulée. Les mentions de recette ci-dessous sont historiques.

# UI-003 — Fiches de personnage en recette — 27 octobre 2026

GO reçu après UI-002 clôturée au commit `2d3787fc1aeb50a69a6dfb77ae7744cce723573d`.
F5 → Équipe → Mako/Anne : fiche du bon héros, PV/mana maximums, attaque, défense, vitesse,
régénération et compétences de référence. Fond fourni et thème bleu nuit/or conservés.
Défilement tactile, retour Équipe par bouton/Échap/Android, sélection retenue. Les aperçus
Idle restent arrêtés derrière la fiche ; aucune simulation n'est créée pour sa lecture.
Le bouton Gambits en bas est désactivé jusqu'à UI-004. Aucun éditeur hors combat livré ici.
47 bancs / 2 920 contrôles réussis ; captures GPU PC et recette tactile native Galaxy A16.
APK normal 0.1.0-ui003 (46), SHA-256 `2d10e45f9d5622a479def8ad64e4f2e38083527c3613ea010bcb5052b364d6f0`.
Installé sans effacement des données ; téléphone laissé sur la fiche d'Anne.
Voir docs/hero-page.md et docs/steps/UI-003.md. Étape non commitée, validation attendue.
Après validation : commit et sauvegarde vérifiée ; prochain GO pour UI-004, puis UI-005,
STEP-029 et STEP-030. GAMEPLAY-003 reste annulée. Les états suivants sont historiques.

# UI-002 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour la page Équipe : Mako/Anne en Idle,
deux places vides, sélection et retours. Validation globale sans détail supplémentaire.
APK normal 0.1.0-ui002 (45), SHA-256
`88d5de3adf6e6cdf4b686548418d14f4cd30047f0dbd15b8d51a38c11943ab04`.
Seuls les documents sont actualisés ; code, scènes, assets, configuration et APK restent
identiques à la livraison validée. Les 45 bancs / 2 816 contrôles déjà réussis ne sont pas
relancés. Aucune nouvelle mesure de performance. Clôture par commit unique et sauvegarde
restaurée/vérifiée ; prochain GO : UI-003, fiches de personnage en valeurs de référence.
Les fiches et les gambits hors combat ne sont pas encore implémentés. GAMEPLAY-003 reste
annulée. Les mentions de recette ci-dessous décrivent les états historiques.

# UI-002 — Équipe en recette — 27 octobre 2026

GO reçu après clôture de UI-001 au commit `01481bad6e02514c2edc3758838a7b0ee81e8365`.
F5 → Équipe : grille 2 × 2, Mako puis Anne animés en Idle et deux places « Vide ».
Fond fourni et cartes/bouton Accueil en surimpression bleu nuit/or. Un appui sur le modèle
ou sa carte sélectionne son identifiant stable et affiche son nom ; les fiches attendent UI-003.
Deux aperçus passifs au plus, arrêtés en arrière-plan et libérés au retour. Aucune simulation
sur Équipe ; ordre logique du combat et sauvegardes conservés. GAMEPLAY-003 reste annulée.
45 bancs / 2 816 contrôles réussis ; captures PC et recette tactile native sur Galaxy A16.
APK normal 0.1.0-ui002 (45), SHA-256 `88d5de3adf6e6cdf4b686548418d14f4cd30047f0dbd15b8d51a38c11943ab04`.
Installation avec conservation des données ; téléphone laissé sur Équipe, Anne sélectionnée.
Voir docs/team-page.md et docs/steps/UI-002.md. Étape non commitée, en attente de validation.
Après validation : clôture et sauvegarde vérifiée, puis nouveau GO pour UI-003, UI-004,
UI-005, STEP-029 et STEP-030. Les états précédents ci-dessous sont historiques.

# UI-001 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour l'accueil, le thème, les retours et les
arènes aléatoires. APK normal 0.1.0-ui001 (44), SHA-256
`0c18f5936ca60e5bda292f364501a5a765c834f9827ff07b9b560cb33ee615fa`.
Validation globale, sans détail supplémentaire ni nouvelle mesure de performance.
Code, scènes, assets, configuration et APK identiques à la livraison validée ; seuls les
documents sont actualisés. Les 43 bancs / 2 718 contrôles déjà réussis ne sont pas relancés.
Clôture par un commit unique puis sauvegarde restaurée/vérifiée. Prochaine étape UI-002 :
page Équipe avec Mako, Anne et deux places vides ; attendre un nouveau GO.
GAMEPLAY-003 reste annulée. Les mentions de recette suivantes sont historiques.

# UI-001 — accueil et arène en recette

F5 ouvre l'accueil sur le fond fourni. Boutons bleu nuit/or sur les fonds, retour avec
abandon du combat, nouveau tirage parmi huit arènes à l'entrée et Rejouer. Le bouton Équipe
est visible mais désactivé jusqu'à UI-002 ; aucune fiche ou nouvelle page Gambits livrée ici.
Combat, sauvegarde des gambits, modèles, gabarits et navigation conservés.
43 bancs / 2 718 contrôles passent ; recette native des retours et du Rejouer effectuée.
APK 0.1.0-ui001 (44) installé sur Galaxy A16, laissé sur l'accueil. Voir docs/steps/UI-001.md
et docs/app-navigation.md. F6 scenes/app/app_root.tscn pour la nouvelle application ;
F6 scenes/main.tscn pour le combat historique. Étape non commitée, attendre validation.
Ensuite UI-002, UI-003, UI-004, UI-005, STEP-029 et STEP-030. Les sections suivantes sont historiques.

# GRAPHICS-009 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour le soin vert fluo à deux anneaux tournants.
APK normal 0.1.0-graphics009 (43), SHA-256
`fc84f63d53b40a9246b3d7466a32833026545ef8c4968b668fbe16881be16fc9`.
Validation globale, sans détail supplémentaire ni nouvelle mesure de performance.
Code, scènes, assets, configuration et APK identiques à la livraison validée ; seuls les
documents sont actualisés. Les 41 bancs / 2 574 contrôles déjà réussis ne sont pas relancés.
Clôture par un commit unique puis sauvegarde restaurée/vérifiée. GAMEPLAY-003 reste annulée :
tailles et contournements conservés. STEP-029 attend un nouveau GO, puis viendra STEP-030.
Les mentions de recette suivantes retracent les états historiques.

# GRAPHICS-009 — soin à deux anneaux en recette

Glow vert fluo et deux anneaux blanc/vert clair translucides, concentriques et tournant
sur deux axes distincts. Effet de réussite de 1,0 s avec fondu complet ; incantation 1,5 s,
règles et cibles inchangées. Voir docs/heal-presentation.md et docs/steps/GRAPHICS-009.md.
APK normal 0.1.0-graphics009 (43), installé sur Galaxy A16 et laissé en pause.
41 bancs / 2 574 contrôles passent. F6 : scenes/debug/heal_lab.tscn, « Soin (demo) ».
GAMEPLAY-003 reste annulée ; tailles, navigation et disques d'ombre conservés.
Étape non commitée ; attendre validation puis clôture avant STEP-029 et STEP-030.
Les états et durées visuelles suivants retracent les étapes historiques.

# GRAPHICS-008 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour les disques d'ombre indiquant le gabarit.
APK 0.1.0-graphics008 (42), SHA-256
`3cb968ff960280aece6b1636edd06f34fd33120eb7c429a89f5806011f11d8cc`.
Validation globale, sans détail supplémentaire ni nouvelle mesure de performance.
Code, scènes, assets, configuration et APK identiques à la livraison validée ; seuls les
documents sont actualisés. Les 40 bancs / 2 541 contrôles déjà réussis ne sont pas relancés.
Clôture par un commit unique puis sauvegarde restaurée/vérifiée. GAMEPLAY-003 reste annulée :
tailles et contournements conservés. STEP-029 attend un nouveau GO, puis viendra STEP-030.
Les mentions de recette et de réduction des gabarits suivantes sont historiques.

# GRAPHICS-008 — disques d'ombre en recette

GAMEPLAY-003 est complètement annulée à la demande du propriétaire : tailles et
contournements sont conservés (rayon 0,35, diamètre 0,70, échelle artistique 0,65).
Chaque personnage possède désormais un disque sombre translucide dimensionné selon
son corps de collision. Le style est réglable dans la présentation. Voir docs/ground-shadows.md
et docs/steps/GRAPHICS-008.md. 40 bancs / 2 541 contrôles passent ; 18 captures PC inspectées.
F6 : scenes/debug/footprint_shadow_lab.tscn ; F8/F5 : Main. APK 0.1.0-graphics008 (42), installé sur Galaxy A16 et laissé en pause.
Étape non commitée ; attendre validation avant clôture, puis STEP-029 et STEP-030.
Les mentions de réduction des tailles et de recette ci-dessous sont historiques.

# GAMEPLAY-002 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour la livraison du contournement local partagé.
APK normal 0.1.0-gameplay002 (41), installé sur Galaxy A16 et laissé en pause.
SHA-256 APK : `105021ffe77922674c6a9c90be8cd60a79f5a8cbd748776ff76bcf1e1e6d0505`.
Validation globale, sans détail supplémentaire ni nouvelle mesure de performance.
Code, scènes, assets et configuration identiques à la livraison validée ; seuls les documents
sont actualisés. Les 39 bancs / 2 481 contrôles et 28 cas Android déjà réussis ne sont pas
relancés pour cette clôture documentaire. Clôture par un commit unique puis sauvegarde
restaurée/vérifiée. GAMEPLAY-003 (gabarits plus fins) attend un nouveau GO.
Les mentions de recette et de préparation suivantes décrivent les états historiques.

# GAMEPLAY-002 — contournement local en recette

Anne, Mako et les squelettes partagent un navigateur local : détour, cache de chemin,
recalculs bornés et attente stable sans passage. GroundCrowd garde le contrôle de contact.
Rayon 0,35 et échelle 0,65 conservés. 39 bancs / 2 481 contrôles passent ; 28 scénarios
Android réussis et relevé de coût en combat réel. Voir docs/steps/GAMEPLAY-002.md et
docs/local-navigation.md. F6 : scenes/debug/local_navigation_lab.tscn ; F8/F5 : Main.
APK normal 0.1.0-gameplay002 (41), installé/lancé sur Galaxy A16.
Étape non commitée ; attendre validation avant clôture et GAMEPLAY-003.
Les sections suivantes décrivent les préparations et états historiques.

# GRAPHICS-007 validée — 26 octobre 2026

Le propriétaire confirme « Step validée. » pour la livraison GRAPHICS-007,
APK normal 0.1.0-graphics007 (39), installé sur Galaxy A16.
SHA-256 APK : `adbbffbf33239c05622e83059827f45f32f263742631509d878617eca71b7231`.
Validation globale, sans détail supplémentaire ni nouvelle mesure FPS.
Les fichiers non documentaires sont identiques à la livraison validée ; les 37 bancs /
2 374 contrôles déjà réussis ne sont pas relancés pour cette clôture documentaire.
Clôture par un commit unique, puis sauvegarde et restauration vérifiées.
Le chantier GRAPHICS-001 à GRAPHICS-007 est validé. Prochaine étape : STEP-029,
clone/import/export/installation reproductibles ; attendre GO avant de la démarrer.
Les mentions de recette ci-dessous décrivent les états antérieurs.

# GRAPHICS-007 — qualification graphique en recette

GRAPHICS-006 clôturée au commit local 834f532, sauvegarde restaurée/vérifiée.
48 cas visuels inspectés sur Galaxy, 10 captures de coût graphique complètes et trois
remplacements artistiques démontrés. 37 bancs / 2 374 contrôles passent ; inventaire et
budgets documentés. Réserve : pointes lors des reconstructions du laboratoire.
Voir docs/steps/GRAPHICS-007.md et docs/graphics-qualification.md.
F6 : scenes/debug/graphics_qualification_lab.tscn ; F8/F5 retrouve Main.
APK normal 0.1.0-graphics007 (39), installé sur Galaxy A16 après la qualification code 38.
Étape non commitée ; attendre validation avant clôture et STEP-029.
Les sections suivantes décrivent les états historiques.

# GRAPHICS-006 validée — 26 octobre 2026

Le propriétaire confirme « Step validée. » pour la livraison GRAPHICS-006,
APK 0.1.0-graphics006 (37), installé sur Galaxy A16.
SHA-256 APK : `fa3303a96264d5d5e4d847854f1fe6ad7c1cfa9adad54d6227677d285a6c9910`.
Validation globale, sans détail supplémentaire ni nouvelle mesure FPS.
Les fichiers non documentaires sont identiques à la livraison validée ; les 36 bancs /
2 320 contrôles déjà réussis ne sont pas relancés pour cette clôture documentaire.
Clôture par un commit unique, puis sauvegarde et restauration vérifiées.
Prochaine étape : GRAPHICS-007, qualification graphique et remplacement des assets ;
attendre GO avant de la démarrer. Les mentions de recette ci-dessous sont historiques.

# GRAPHICS-006 — Foudre avec glow en recette

GRAPHICS-005 clôturée au commit local bf4904d, sauvegarde restaurée/vérifiée.
Éclair descendant rapide, cœur blanc bleuté, branches cyan et glow diffus, impact local.
Préparation liée à Duck et à la cible réelle ; succès uniquement après dégâts effectifs.
Scènes/profil/origine remplaçables ; pause et nettoyage, sans modification du gameplay.
36 bancs / 2 320 contrôles passent. Voir docs/steps/GRAPHICS-006.md et docs/lightning-presentation.md.
F6 : scenes/debug/lightning_lab.tscn, Foudre (demo), puis F8/F5 pour le vrai combat.
APK 0.1.0-graphics006 (37), installé et lancé sur Galaxy A16, version vérifiée par ADB.
Étape non commitée ; attendre validation avant clôture et GRAPHICS-007.
Les sections suivantes décrivent les états historiques.

# GRAPHICS-005 validée — 26 octobre 2026

Le propriétaire confirme « Step validée. » pour la livraison GRAPHICS-005,
APK 0.1.0-graphics005 (36), installé sur Galaxy A16.
SHA-256 APK : `060c79e8cedc6236d7d4ea33a7df8ec7245b9c938b94976fc9362f01251cc8da`.
Validation globale, sans détail supplémentaire ni nouvelle mesure FPS.
Les fichiers non documentaires sont identiques à la livraison validée ; les 35 bancs /
2 243 contrôles déjà réussis ne sont pas relancés pour cette clôture documentaire.
Clôture par un commit unique, puis sauvegarde et restauration vérifiées.
Prochaine étape : GRAPHICS-006, effet Foudre de Mako ; attendre GO avant de la démarrer.
Les mentions de recette ci-dessous décrivent les états antérieurs.

# GRAPHICS-005 — effet de soin en recette

GRAPHICS-004/fix1 clôturée au commit local 074f971, sauvegarde restaurée/vérifiée.
Halo de soin, signes + et valeur réellement rendue, uniquement après résolution positive.
Apparence remplaçable, origine par modèle et suivi de cible ; pause/reprise et nettoyage.
35 bancs / 2 243 contrôles passent. Voir docs/steps/GRAPHICS-005.md et docs/heal-presentation.md.
F6 : scenes/debug/heal_lab.tscn, bouton Soin (demo), puis F8/F5 pour le vrai combat.
APK 0.1.0-graphics005 (36), installé et lancé sur Galaxy A16, version vérifiée par ADB.
Étape non commitée ; attendre validation avant clôture et GRAPHICS-006.
Les sections suivantes décrivent les états historiques.

# GRAPHICS-004 et fix1 validés — 26 octobre 2026

Le propriétaire confirme « Tout est OK. Step validée. » pour la livraison fix1,
APK 0.1.0-graphics004-fix1 (35), installé sur Galaxy A16.
SHA-256 APK : `242961171f11a2f9e0ae1dbd9efad59af43df5b02e8e745261ca24c9bd805959`.
Les fichiers non documentaires restent identiques à la livraison validée ; les 34 bancs /
2 154 contrôles déjà réussis ne sont pas relancés pour cette clôture documentaire.
Clôture par un commit unique, fix1 inclus, puis sauvegarde et restauration vérifiées.
Prochaine étape : GRAPHICS-005, effet de soin ; attendre GO avant de la démarrer.
Les mentions de recette ci-dessous décrivent les états antérieurs.

# Actualisation GRAPHICS-004/fix1

Lire docs/steps/GRAPHICS-004.md et docs/combat-presentation.md : priorité stricte,
Sword/HitReact/Death/Duck, 34 bancs / 2 154 contrôles, APK actif code 35 installé et lancé
sur Galaxy A16, version vérifiée par ADB. Attendre validation
avant clôture et GRAPHICS-005. Dernier commit b1dfb33, sauvegarde vérifiée.
Les sections suivantes décrivent les états antérieurs.

# GAMEPLAY-001 et fix1 validés

Le propriétaire confirme « Steps validée. ». La livraison fix1, APK 0.1.0-gameplay001-fix1
(code 33), est validée. Les sources non documentaires sont identiques à la livraison.
Clôture par un commit unique, fix1 inclus, puis sauvegarde vérifiée. GRAPHICS-004 est la
prochaine étape ; attendre GO. Les statuts de recette antérieurs ci-dessous sont historiques.

# GAMEPLAY-001-fix1 — correctif en recette

Le soin inclut Anne et privilégie le plus bas pourcentage de PV. La mana est débitée
uniquement à l'effet réussi ; une annulation pendant l'incantation ne coûte rien.
32 bancs / 1 959 contrôles passent. APK 0.1.0-gameplay001-fix1 (33) installé sur A16.
Voir docs/steps/GAMEPLAY-001-fix1.md et docs/party-gameplay.md. Les états de livraison
précédents ci-dessous sont historiques. Validation de GAMEPLAY-001 toujours attendue.

# Actualisation GAMEPLAY-001

Lire docs/steps/GAMEPLAY-001.md et docs/party-gameplay.md : étape en recette, 31 bancs /
1 921 contrôles, APK 0.1.0-gameplay001 (32) installé sur A16. Dernier commit GRAPHICS-003
7956cfce2efcdaf4b95fd3f0631193cb9d442589, sauvegarde restaurée et vérifiée.
Attendre validation, puis clôturer GAMEPLAY-001 avant GRAPHICS-004. Les paragraphes suivants
sont historiques lorsqu'ils décrivent une ancienne composition ou un ancien statut.

# GRAPHICS-003 — recette actuelle

28 bancs, 1 803 contrôles, zéro échec. Nouveau banc character_presentation_tests.tscn.
F6 character_lab.tscn puis F8/F5 ; Android installé, contrôle visuel effectué, recette
utilisateur attendue. Voir docs/steps/GRAPHICS-003.md pour APK et limites.

# Tests, environnement et preuves de validation

## Actualisation GRAPHICS-002

Validation globale explicite reçue du propriétaire le 26 octobre 2026 ; commit demandé.
Ce retour n'ajoute pas de mesure ni de détail par banc aux preuves suivantes.

27 bancs headless : 1 728 contrôles, zéro échec, aucun warning/erreur Godot dans cette campagne.
Le nouveau `arena_catalog_tests.tscn` ajoute 79 contrôles, dont gestes tactiles réels au
viewport, sélection des neuf profils, calage, états conservés, cycle de vie et nettoyage.
14 contrôles supplémentaires passent en fenêtre, avec captures des huit fonds et du sélecteur.
Preset actuel : `graphics-002-debug.apk`, version `0.1.0-graphics002`, code 30.
Recette et empreinte : [GRAPHICS-002](../steps/GRAPHICS-002.md).
Les actualisations suivantes décrivent les versions précédentes.

## Actualisation GRAPHICS-001

26 bancs headless : 1 649 contrôles, zéro échec, aucun warning/erreur Godot dans cette campagne.
Le nouveau `arena_presentation_tests.tscn` couvre les vues, replis, calage et équivalence du jeu
sur 900 ticks avec trois présentations de terrain. Sept contrôles supplémentaires en fenêtre
X11 passent via le viewport réel. Contrôle d'affichage réalisé sur Galaxy A16 après installation.
Recette utilisateur et APK identifié : [GRAPHICS-001](../steps/GRAPHICS-001.md).
F6 sur `scenes/debug/graphics_lab.tscn` ouvre la galerie sans combat. Le preset actuel est
`graphics-001-debug.apk`, version `0.1.0-graphics001`, code 29 ; les sections STEP-028 suivantes
décrivent la base précédente.

## Actualisation STEP-028 — 26 octobre 2026

Environnement effectif vérifié : Ubuntu 24.04.5, Godot 4.7.2.stable.official.ed1daf0bf,
templates 4.7.2.stable, OpenJDK 21.0.12.1, SDK Android et ADB 37.0.1 présents.
Galaxy A16 SM-A165F Android 16 connecté ; les anciennes limites « Godot absent » ci-dessous
décrivent la passation historique. STEP-028 dispose maintenant de 25 scènes, avec
`performance_tests.tscn` en plus des 24 bancs de base.

Les 24 bancs historiques ont été réellement exécutés en headless dans une copie isolée :
1 594 contrôles, zéro échec, aucune erreur/avertissement Godot relevé. Un harnais temporaire
arrête chaque scène après son bilan ; ce n'est pas un runner global versionné ni une équivalence
aux recettes manuelles F6/tactile. Le nouveau banc passe 32 contrôles en headless et en fenêtre
X11/Compatibility. Il valide horloges, buffers, quantiles, profils de fixture, interruptions,
export, retour au jeu ordinaire et dix resets synthétiques. Aucun de ces tests accélérés
n'est un benchmark. Résultats matériels et SHA : ../steps/STEP-028.md.

Commande autonome du nouveau banc, avec dossier de données de test isolé :

```bash
XDG_DATA_HOME=/tmp/gambit-performance-tests Godot_v4.7.2-stable_linux.x86_64 \
  --headless --path . scenes/tests/performance_tests.tscn -- --test-exit
```

Adapter le chemin du binaire. En F6 le banc reste affiché jusqu'à F8.
Le 26 octobre 2026, le propriétaire a validé STEP-028 avec le retour global : F6, F5,
tactile Android et pause/reprise OK. Aucun détail par banc, durée ou FPS n'est ajouté à ce retour.

## Environnement rapporté par l’utilisateur

Poste Ubuntu 24.04.5 LTS x86_64 ; Godot 4.7.2 standard, templates installés ; OpenJDK
21.0.12.1 ; SDK ~/Android/Sdk ; téléphone Samsung Galaxy A16 SM-A165F, Android 16.
Détails historiques dans ../android.md. Ces versions sont celles consignées par le projet,
pas un inventaire refait sur le poste pendant HANDOFF-001. Sur une nouvelle machine,
vérifier la version réellement installée et utiliser les templates correspondants.
Le projet déclare 4.7 et GL Compatibility ; référence 540 × 960, portrait, arm64-v8a.

Godot 4.7.2 et le Galaxy A16 ont été disponibles pour STEP-028 : les exécutions et mesures
effectivement réalisées sont consignées en tête de ce fichier et dans ../steps/STEP-028.md.
Les restrictions mentionnées dans les textes historiques de HANDOFF-001 ne décrivent plus
l'environnement de cette étape.

## Procédure

Ouvrir project.godot, laisser terminer l’import. F5 lance Main/PerformanceLab, qui délègue
le jeu courant à ApplicationLab hors capture. Pour chaque
banc ci-dessous, ouvrir sa scène sous scenes/tests, F6, attendre le bilan, consulter Sortie/
Débogueur puis F8 avant la scène suivante. Attendu : OK, zéro échec, aucun nouvel avertissement.
Les longues boucles de simulation peuvent nécessiter quelques frames avant le bilan.
Les tests UI interagissent avec le viewport réel ; ne pas présumer qu’un lancement headless
constitue une recette équivalente. Aucun lanceur global headless fiable n’est livré.

## Bancs disponibles

| Scène sous scenes/tests | Couverture principale |
|---|---|
| application_lifecycle_tests.tscn | Dix cycles de notifications, temps figé, reprise explicite, anciens gestes, modal et défaite |
| run_lifecycle_tests.tscn | Dix resets + dix clics Rejouer, anciens acteurs/actions, bilan, signaux et compteurs |
| target_lock_tests.tscn | Cible vivante à portée conservée, soin, manuel, sortie de portée, mort et identité |
| wave_sequence_tests.tscn | Trois vagues, transitions et comptes globaux/locaux, pas de quatrième vague |
| wave_schedule_tests.tscn | Cadence, quota, saturation, apparition bloquée, plafond et fins |
| touch_scroll_tests.tscn | Vrais événements tactiles/souris, swipe depuis carte/espace, annulation et clic unique |
| attack_stationary_tests.tscn | Position/vitesse/jambes stables à portée, approche hors portée |
| manual_commands_tests.tscn | Attente unique/remplacement, priorité, échéance, revalidation et coûts |
| lifecycle_tests.tscn | Pause, mort, actions anciennes et absence d’effet tardif |
| gambit_controller_tests.tscn | Plan/engagement, règles, revalidation et combat automatique |
| gambit_diagnostics_tests.tscn | Journal borné, scénarios et nettoyage |
| gambit_tests.tscn | Évaluateur pur, priorités, conditions et déterminisme |
| gambit_editor_tests.tscn | Activation, réordre et conservation des règles |
| gambit_fields_tests.tscn | Cible/condition/seuil/action, validation atomique et modal |
| portrait_hud_tests.tscn | Zones sûres, géométrie et dernière règle atteignable |
| skill_slots_tests.tscn | Six emplacements et états de disponibilité sans effet |
| skills_tests.tscn | Soin/spéciale/récupération |
| skill_executor_tests.tscn | Exécuteur commun, coût et cooldown uniques |
| combat_simulation_tests.tscn | Ordonnancement, résultats et interactions de combat |
| attack_action_tests.tscn | Identité d’action, impact unique, portée et annulation |
| actor_state_tests.tscn | États indépendants, PV et statistiques |
| ground_crowd_tests.tscn | Séparation, limites et mouvements bornés |
| enemy_director_tests.tscn | Apparitions et poursuite des premiers laboratoires |
| ground_mover_tests.tscn | Approche, cible invalide, vitesse et limites |

La recette de chaque étape précise ses régressions prioritaires. Avant une modification
transversale du coordinateur, des entrées ou des exécuteurs, choisir les bancs couvrant les
comportements affectés, sans supprimer les assertions pour obtenir un résultat vert.

## Recette manuelle actuelle

Observer plusieurs attaques sur une même cible : aucun changement tant qu’elle vit et reste
à portée, aucun petit pas parasite. Vérifier soin/spéciale et commandes en attente, trois
vagues et compteurs, défaite, dix Rejouer (règles/pause conservées), swipe et appuis courts.
Sur Android : au moins dix allers-retours combinant Accueil, applications récentes et
verrouillage, pendant action, commande, geste et formulaire. Retour toujours en pause,
nouveau geste fonctionnel, pas de coût/effet doublé ou rattrapage. Le processus tué relance
une session neuve : pas de sauvegarde persistante revendiquée.
Voir ../steps/STEP-025-fix1.md, ../steps/STEP-026.md et ../steps/STEP-027.md.

## Export et identité APK

Le preset actuel Android Debug utilise ../gambit-arena-builds/step-028-debug.apk,
version 0.1.0-step028, code 28, paquet org.gambitarena.prototype. L'APK de référence
mesuré porte le SHA-256 `d2c710ef6fb1c935eb6afecbfe54e98b1a03d0a03266753c5c8b537cce1a23b9`.
Exporter en mode Debug explicitement ; le nom du preset ne suffit pas à prouver le mode utilisé.

```bash
~/Android/Sdk/platform-tools/adb devices -l &&
~/Android/Sdk/platform-tools/adb -d install -r ~/gambit-arena-builds/step-028-debug.apk &&
sha256sum ~/gambit-arena-builds/step-028-debug.apk
```

Le SHA réellement installé/testé doit être communiqué, pas une ancienne empreinte copiée.
STEP-028 modifie le code, les scènes et le preset ; HANDOFF-001 seul était documentaire.

## Dernières preuves reçues

| Étape | Commit | SHA-256 APK final validé |
|---|---|---|
| STEP-024 v2 | 89ae0f6 | d367d52fb3a3e6857d90c19f333d819a0b6e28d888fcab92c5a38a8dc46fcb09 |
| STEP-025 fix1 | f62162d | a05863ca35183215d53c270652a0a1927da4e74c8547fcf32112f6a42e97544a |
| STEP-026 | 344a584 | 1c6e699d3acf44a6f3e5ce6e85d333ac9bb60c14e946a548992bd5eb099a47a2 |
| STEP-027 | 665c0c8 | 07467efcfb7e663e363e6f6fc61644fd2bf2889e7ee3a3001d42589e0c6cf611 |

Ces retours sont globaux « F6 OK, tests manuels OK, fluidité OK ». Ne pas leur attribuer
un nombre de contrôles exécutés, une durée de session ou des FPS qui n’ont pas été fournis.
