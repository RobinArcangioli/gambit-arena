# HOME-001 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » après le choix de l'essai C et la recette Android.
La version retenue est HOME-001-FIX2 : huit bougies recalées, deux braséros, halos doux à
taille fixe, scintillement C. Le banc A/B/C est conservé pour les ajustements futurs.
APK 0.1.0-home001-fix2 (52), SHA-256
`7cfefa33a7cdd0a85ca246864f2875534923de3d62a0ce3e50879d3a949783bb`.
Seuls les documents sont actualisés ; code, scènes, assets, configuration et APK restent
identiques à la livraison validée. Les 144 contrôles de parcours et 24 contrôles GPU ne
sont pas relancés. Recette Android réussie, gambits conservés octet pour octet.
Clôture par commit unique et sauvegarde restaurée/vérifiée. Prochain GO : UI-005,
qualification intégrée prolongée Android, puis STEP-029/030. GAMEPLAY-003 reste annulée.
Les états et essais précédents ci-dessous sont historiques.

# HOME-001-FIX2 — Réglage C retenu par le propriétaire — en recette

Après comparaison dans Godot de trois essais (A Doux, B Équilibré, C Un peu plus présent),
le propriétaire choisit explicitement « C — Un peu plus présent ». Ce choix esthétique
n'est pas encore une validation de clôture de HOME-001.
Halos adoucis, taille fixe, aucune langue de flamme synthétique ni gonflement de disque.
Huit bougies recalées sur les flammes visibles : les faux points sur livres/colonnes retirés.
Deux braséros conservés. Rayons : bougies 28×38, braséros 72×90 (pixels de l'illustration).
Intensités C : bougies 0,30, braséros 0,46 ; modulation maximale ±34 % avec rythmes déphasés.
Le scintillement utilise trois oscillations ; arrêt hors accueil / arrière-plan conservé.
Banc F6 réutilisable : scenes/debug/home_lighting_tuning.tscn, défilement A/B/C toutes les
8 secondes, pause et sélection ; il conserve le choix dans user://home_lighting_choice.json
et ne change pas les réglages de production. L'accueil normal utilise désormais C par défaut.
APK 0.1.0-home001-fix2 (52), SHA-256 `7cfefa33a7cdd0a85ca246864f2875534923de3d62a0ce3e50879d3a949783bb`.
144 contrôles de parcours et 24 contrôles GPU réussis. Recette Android dans la livraison.
Les essais précédents ci-dessous sont historiques et remplacés par ce réglage.

# HOME-001-FIX1 — Animation renforcée — en recette

Retour propriétaire : l'effet initial est trop subtil et l'animation imperceptible.
Variation de luminosité portée de ±9 % à ±52 %, halos agrandis et rayons animés de ±18 %.
Deux langues lumineuses ondulent dans chaque flamme ; phases distinctes par source.
Intensités de base : bougies 0,46, braséros 0,64. Arrêt hors accueil et en arrière-plan
conservé ; la texture et le cadrage ne changent pas. Les valeurs restent réglables dans
le profil visuel. Ce fix appartient à HOME-001, toujours en attente de validation.
APK 0.1.0-home001-fix1 (51), SHA-256 `17d389a3ed5a8dd66ed59e98a99655911b7f7c501f958feb9085d4b4bad98a4f`.
Deux bancs / 144 contrôles et recette GPU / 24 contrôles réussis après réimport ;
aperçu animé 3 secondes et recette Android, sans erreur. Gambits Android identiques.
La livraison précédente HOME-001 est remplacée par cette révision ; aucun commit effectué.
Les descriptions antérieures ci-dessous décrivent la version initiale.

# HOME-001 — Lueurs procédurales de l'accueil — en recette

À la demande du propriétaire, les bougies et les deux braséros de l'accueil reçoivent des
halos additifs locaux et un scintillement discret. Profil visuel séparé du routage et de la
logique de jeu ; image d'origine intacte. Nouvelle étape esthétique avant UI-005.
Base clôturée GAMBITS-002 : `4b5eea1412cdc8c52daca1c85638d36bb6675ce9`, sauvegarde restaurée
et vérifiée (685 fichiers). HOME-001 attend validation avant commit et sauvegarde de clôture.
APK 0.1.0-home001 (50), SHA-256 `739a198892a17db6eecb158cc475d50354cb0f360bbd41d0c725fc88cd951ce4`.
Deux bancs de parcours/layout : 144 contrôles ; vérification GPU dédiée : 24 contrôles,
sans erreur. Preuves avant/après et recette native dans l'archive de livraison.
Aucun benchmark FPS. Prochaine étape après validation/clôture et GO : UI-005.
Les états précédents ci-dessous sont historiques.

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

# Précision de périmètre — sauvegarde immédiate des gambits

Demande du propriétaire : aucune commande Appliquer/Annuler dans la refonte. Chaque
changement est enregistré immédiatement, y compris ajout, suppression et réordonnancement.
Retour conserve les modifications. Interface sobre, sans confirmation ni message de réussite
à chaque action. Ce comportement concerne la refonte GAMBITS-001/002 ; le checkpoint UI-004
reste inchangé tant que cette refonte n'est pas implémentée.

# Refonte des gambits proposée — 27 octobre 2026

Demandes et précisions du propriétaire : Critère de ciblage + capacité, dix critères fixes,
alliés incluant soi-même, sélection de l'allié au plus faible pourcentage de PV, ennemis
classés par PV actuels absolus, associations libres, 0 à 100 ordres par héros. Migration
des seuils vers le plus grand seuil disponible inférieur ou égal (Anne 80 → 70).
Plan : GAMBITS-001 (catalogue/modèle/migration isolés), GAMBITS-002 (bascule combat et
éditeurs sur une ligne avec ajout/suppression), puis UI-005 étendue à la recette intégrée.
Voir docs/gambits-refactor-roadmap.md. Plan proposé, aucun code ou APK modifié. Attendre
validation du découpage et GO. UI-004 reste le checkpoint fonctionnel 2f1e9b9603d7.
Les périmètres antérieurs ci-dessous sont historiques s'ils décrivent les trois règles v2.

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

Précisions du propriétaire (27 octobre 2026) : tous les boutons sont superposés aux fonds
sur toutes les pages, avec thème bleu nuit/bleu profond et or/orange ambré. Chaque nouveau
combat, y compris Rejouer, choisit une des huit arènes illustrées au hasard. UI-001 intègre
ces exigences, UI-005 les recettera. Roadmap documentaire ; attendre GO avant implémentation.

# Nouveau parcours proposé — accueil, équipe, fiches et gambits

Roadmap préparée le 27 octobre 2026 : voir docs/app-pages-roadmap.md et docs/steps/UI-001.md
à UI-005.md. Ce changement est documentaire, aucun nouvel écran n’est encore implémenté.
Décisions du propriétaire : retour accueil depuis l’arène abandonne le combat ; nouvelle
entrée = partie neuve ; équipe en grille 2 × 2 (Mako, Anne, Vide, Vide) ; fiches en valeurs
de référence. Les gambits sauvegardés sont conservés. Fonds fournis pour accueil et équipe.
Prochaine étape proposée : UI-001, après accord sur le plan et GO. Puis UI-002/003/004/005,
STEP-029 (reproduction) et STEP-030 (recette finale élargie). GAMEPLAY-003 reste annulée.
Base fonctionnelle : GRAPHICS-009 clôturée au commit d632dfb, sauvegarde restaurée/vérifiée.
Les sections suivantes décrivent les étapes et états historiques.

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

# GAMEPLAY-002 — en recette

Contournement partagé livré sur les gabarits actuels : 39 bancs / 2 481 contrôles et
28 scénarios Android. Attendre validation/clôture avant GAMEPLAY-003 (gabarits plus fins),
puis STEP-029 et STEP-030. Voir docs/steps/GAMEPLAY-002.md. Le registre initial suit.

# Roadmap — Gambit Arena

La roadmap détaillée a été validée par l'utilisateur dans la conversation
de lancement. Ce fichier en constitue le registre opérationnel initial.

## Périmètre MVP

Android portrait, arène fixe avec personnages 3D sur fond 2D isométrique,
un héros automatiquement mobile, un type d'ennemi, combat et vagues,
trois gambits configurables, six emplacements manuels dont trois actifs,
pause, défaite et redémarrage.

Exclus : équipe, multijoueur, backend, déplacement manuel, pathfinding
complexe, décor bloquant, progression persistante et publication en boutique.

## Choix de départ approuvés

- Godot 4.7.2 standard ; rendu Compatibility.
- Référence proposée : 540 × 960.
- Taille apparente retenue après STEP-004 : 48 pixels de référence.
  Comparaison 48/64/80 effectuée ; ajustement possible avec les vrais assets.
- Vue dimétrique 2:1 ; coordonnées logiques au sol.
- Idle, Move, Attack, Hit et Death restent les états visuels cibles.
- Les quatre directions en sprites de STEP-005 décrivent le prototype historique ;
  elles ne contraignent pas la future orientation des personnages 3D.
- Évaluation initiale des gambits à 10 Hz.
- Plafond initial : 20 ennemis vivants.
- Objectif provisoire : 30 images/s soutenues sur le téléphone de référence.
- Gambits conservés au redémarrage de partie, sans sauvegarde persistante.
- Une commande manuelle en attente, remplaçable, valide trois secondes
  de temps de jeu ; aucune interruption d'une action engagée.

Les valeurs visuelles et de performance seront confirmées sur appareil.
Elles ne sont pas des résultats déjà mesurés.

## Registre chronologique

Chaque étape dépend de la clôture de la précédente, sauf STEP-001,
qui dépend de la validation de la roadmap.

| ID | Phase | Livrable et acceptation principale |
|---|---|---|
| STEP-001 | 1. Initialisation | Projet minimal lançable, Git et documentation |
| STEP-002 | 1. Initialisation | Prérequis Android documentés, téléphone autorisé dans ADB |
| STEP-003 | 2. Prototype | Projection et inverse cohérentes, sprites mobiles triés aux pieds |
| STEP-004 | 2. Prototype | APK installé : mobilité, tri, taille et bouton tactile vérifiés |
| STEP-005 | 3. Assets | Deux acteurs temporaires, cinq animations, ancrages et licences |
| STEP-006 | 4. Arène | Arène fixe lisible, limites et réservations pour l'interface |
| STEP-007 | 5. Déplacement | Approche A puis B, arrêt sans cible, vitesse et limites cohérentes |
| STEP-008 | 5. Déplacement | Ennemis apparaissant aux côtés et poursuivant le héros |
| STEP-009 | 5. Déplacement | Séparation bornée, encerclement et blocage sans téléportation |
| STEP-010 | 6. Combat | Statistiques et PV isolés entre instances |
| STEP-011 | 6. Combat | Action identifiée, impact unique, portée et mort respectées |
| STEP-012 | 6. Combat | Premier combat autonome complet contre plusieurs ennemis |
| STEP-013 | 7. Compétences | Exécuteur partagé, coûts et cooldowns appliqués une seule fois |
| STEP-014 | 7. Compétences | Attaque, soin et spéciale fonctionnels, ressource récupérable |
| STEP-015 | 7. Compétences | Pause commune et interruption par la mort sans effet tardif |
| STEP-016 | 8. Gambits | Évaluateur déterministe sans effet de bord |
| STEP-017 | 8. Gambits | Intentions pilotant seules le héros ; contrôleur temporaire retiré |
| STEP-018 | 8. Gambits | Diagnostics bornés et scénarios de règles reproductibles |
| STEP-019 | 9. Éditeur | Trois règles visibles, activables et réordonnables au toucher |
| STEP-020 | 9. Éditeur | Cible, condition, seuil et action éditables avec validation |
| STEP-021 | 10. Interface | HUD portrait lisible et adapté aux zones de sécurité |
| STEP-022 | 10. Interface | Six emplacements, trois compétences, états disponibles visibles |
| STEP-023 | 10. Interface | Commande manuelle prioritaire, attente bornée et revalidation |
| STEP-024 | 11. Partie | Vague progressive, fin correcte et plafond simultané |
| STEP-025 | 11. Partie | Enchaînement de trois vagues et compteurs exacts |
| STEP-026 | 11. Partie | Défaite et dix redémarrages sans résidus |
| STEP-027 | 12. Robustesse | Pause, arrière-plan, verrouillage et retour Android cohérents |
| STEP-028 | 12. Performance | Mesures reproductibles et décision produit sur le budget matériel |
| STEP-029 | 13. Livraison | Clone propre, import, export et installation reproductibles |
| STEP-030 | 13. Livraison | Recette finale du MVP validée sur l'APK identifié |

## Statuts

- STEP-001 : validée et anciennement commitée — 6583515 (historique perdu).
- STEP-002 : validée et anciennement commitée — 5b9baac (historique perdu).
- STEP-003 : validée après correctif ; aucun commit confirmé avant suppression.
- RECOVERY-001 : validée et commitée — 6282d81 ; sauvegarde avec bundle reçue et vérifiée.
- STEP-004 : validée et commitée — 491cde8 ; sauvegarde reçue et vérifiée.
- STEP-005 : validée et commitée — 44f81d5 ; sauvegarde reçue et vérifiée.
- TRANSITION-001 : validée et commitée — 056a464 ; sauvegarde reçue et vérifiée.
- STEP-006 : validée et commitée — 1cc7f05 ; sauvegarde reçue et vérifiée.
- STEP-007 : validée et commitée — 9b3240c ; sauvegarde reçue et vérifiée.
- STEP-008 : validée et commitée — 46dfaa7 ; sauvegarde reçue et vérifiée.
- STEP-009 : validée et commitée — ec576ce ; sauvegarde reçue et vérifiée.
- STEP-010 : validée et commitée — ba56209 ; sauvegarde reçue et vérifiée.
- STEP-011 : validée et commitée — 3633927 ; sauvegarde reçue et vérifiée.
- STEP-012 : validée et commitée — 9725f5d ; sauvegarde reçue et vérifiée.
- STEP-013 : validée et commitée — 1ffd24a ; sauvegarde reçue et vérifiée.
- STEP-014 : validée et commitée — 5c39ac2, validation 4f4244c ; sauvegarde vérifiée.
- STEP-015 : validée et commitée — dd9fec8 ; sauvegarde reçue et vérifiée.
- STEP-016 : validée et commitée — 1da833e ; sauvegarde reçue et vérifiée.
- STEP-017 : validée et commitée — 5b2bc4d ; sauvegarde reçue et vérifiée.
- STEP-018 : validée et commitée — 4719e8d ; sauvegarde reçue et vérifiée.
- STEP-019 : validée et commitée — 4125d44 ; sauvegarde reçue et vérifiée, correctif inclus.
- STEP-020 : validée et commitée — ac58190 ; sauvegarde reçue et vérifiée.
- STEP-021 : validée et commitée — 9491d40 ; sauvegarde reçue et vérifiée, correctif inclus.
- STEP-022 : validée et commitée — 307e8c6 ; sauvegarde reçue et vérifiée.
- STEP-023 : validée et commitée — 7579504 ; sauvegarde vérifiée ; swipe traité dans STEP-024.
- STEP-024 : validée et commitée — 89ae0f6 ; sauvegarde reçue et vérifiée, correctifs inclus.
- STEP-025 : validée et commitée — f62162d ; fix1 inclus, sauvegarde reçue et vérifiée.
- STEP-026 : validée et commitée — 344a584 ; sauvegarde reçue et vérifiée.
- STEP-027 : validée et commitée — 665c0c8 ; sauvegarde reçue et vérifiée.
- STEP-028 : validée explicitement par l'utilisateur ; F6, F5, tactile Android et pause/reprise
  OK. L'ancien seuil 30 FPS Debug n'est pas atteint, mais la décision produit l'accepte pour le
  périmètre réel et 20 ennemis reste un stress test. Commit et sauvegarde en attente.
  Voir docs/steps/STEP-028.md.
- STEP-029 et STEP-030 : À faire.

Les anciens hashes STEP-001/002 attestent les retours utilisateur ; leurs objets
sont perdus. Le nouveau commit 6282d81 est disponible et sauvegardé.
STEP-003 validée est incluse dans ce commit de reprise.
Voir [la reprise](docs/recovery.md) et [les sauvegardes](docs/backup.md).

## Situation de passation

HANDOFF-001 documente l’état après STEP-027, sans nouvelle étape fonctionnelle.
Commit documentaire cc91c79 et main GitHub vérifiés le 26 octobre 2026.
Voir [HANDOFF.md](HANDOFF.md) et [la procédure GitHub](docs/handoff/GITHUB.md).

## Étapes restantes

Actualisation après GRAPHICS-007 : deux nouvelles étapes de gameplay demandées par le
propriétaire s'intercalent avant STEP-029/030. D'abord contournement local partagé, puis
réduction de gabarit ; voir [le plan](docs/local-navigation-plan.md). Le plan est préparé,
les deux fonctionnalités ne sont pas implémentées. Le prochain GO démarre GAMEPLAY-002.


Le propriétaire a demandé de préparer un chantier graphique avant la livraison finale :
voir la [roadmap graphique GRAPHICS-001 à GRAPHICS-007](docs/graphics-roadmap.md).
Elle prévoit d'abord les arènes interchangeables, puis les personnages 3D et les actions
attaque, soin et Foudre, avec une couche de présentation isolée du gameplay. Plan validé et
GRAPHICS-001 clôturée localement (f5a790d), GRAPHICS-002 validée avec commit autorisé. STEP-029 et STEP-030 conservent
leurs identifiants et se dérouleront après ce chantier.

| Étape | État | Livrable |
|---|---|---|
| STEP-028 | Clôturée — 580ce64, poussée et sauvegarde vérifiée | Mesures reproductibles sur téléphone ; objectif historique 30 FPS non atteint en Debug, accepté pour le périmètre prévu |
| GRAPHICS-001 | Validée, commit local f5a790d et sauvegarde vérifiée | Colisée et référence interchangeables, galerie et contrat de présentation |
| GRAPHICS-002 | Clôturée localement — 1e42756, sauvegarde vérifiée | Catalogue des huit arènes fournies |
| GRAPHICS-003 | Clôturée localement — 7956cfc, sauvegarde vérifiée | Anne, Mako et deux squelettes : modèles 3D et animation de base |
| GAMEPLAY-001 | Clôturée localement — b1dfb33, sauvegarde vérifiée | Équipe Anne/Mako, compétences propres, soin ciblé et gambit Allié < 50 % PV ; voir docs/party-skills-plan.md |
| GRAPHICS-004 | Clôturée localement — 074f971, sauvegarde vérifiée | Attaque, réaction, mort et priorités des actions ; Duck pour les sorts |
| GRAPHICS-005 | Clôturée localement — bf4904d, sauvegarde vérifiée | Halo de soin, valeur rendue, profil remplaçable et cycle de vie |
| GRAPHICS-006 | Clôturée localement — 834f532, sauvegarde vérifiée | Éclair descendant et glow, préparation et impact sur cible réelle |
| GRAPHICS-007 | Clôturée localement — 440829b, sauvegarde vérifiée | Qualification graphique et facilité de remplacement |
| GAMEPLAY-002 | Validée — 27 octobre 2026 | Contournement local partagé héros/ennemis aux dimensions actuelles |
| GAMEPLAY-003 | Annulée — 27 octobre 2026 | Tailles et contournements conservés à la demande du propriétaire |
| GRAPHICS-008 | Validée — 27 octobre 2026 | Disques d’ombre translucides dimensionnés sur l’emprise au sol |
| GRAPHICS-009 | Validée — 27 octobre 2026 | Soin vert fluo, deux anneaux concentriques tournants et fondu en une seconde |
| UI-001 | Clôturée — 01481bad6e02 | Accueil, boutons sur fonds, thème nuit/or, arène aléatoire et abandon au retour |
| UI-002 | Clôturée — 2d3787fc1aeb | Équipe 2 × 2, Mako/Anne en Idle et deux places vides |
| UI-003 | Clôturée — c8497aac5760 | Fiches de référence et accès aux compétences |
| UI-004 | Validée — 27 octobre 2026 | Page Gambits du héros, indépendante du combat et sauvegarde préservée |
| GAMBITS-001 | Validée — 27 octobre 2026 | Catalogue fixe, modèle 0–100, résolution et migration testées isolément |
| GAMBITS-002 | Plan proposé — après GAMBITS-001 | Bascule combat et éditeurs en ligne, capacités/cibles libres, ajout/suppression |
| UI-005 | Plan proposé — après GAMBITS-002 | Recette du parcours complet sur PC et Android |
| STEP-029 | Après UI-005 | Clone neuf, import, export et installation reproductibles |
| STEP-030 | À faire | Recette finale MVP sur APK identifié |

Le [plan détaillé proposé](docs/handoff/NEXT_STEPS.md) prépare ces étapes ; il ne prétend
ni les implémenter ni remplacer leur autorisation. « Fluidité OK » ne prouve pas un budget
matériel mesuré. La publication initiale du dépôt ne remplace pas la recette STEP-029.

## Conventions et risques

Une étape validée est commitée avec sa documentation, puis sauvegardée et vérifiée avant GO.
Le hash d’un commit est consigné à l’étape suivante, sans amendement circulaire. Les recettes
historiques peuvent donc mentionner « commit en attente » ; le présent registre et Git
font foi pour l’état courant. Correctifs et changements de direction restent documentés.

Préserver ciblage vivant à portée, impact/coût uniques, immobilité à portée, swipe tactile,
compteurs des trois vagues, fin/replay et reprise explicite Android. Les modèles/animations
finaux, l’équilibrage et la mesure matérielle ne sont pas acquis. Voir la passation.

## Limite du document initial

Le fichier transmis au lancement contenait un titre d’annexe sans son texte détaillé.
Le registre des 30 étapes ci-dessus est conservé. Ne pas inventer l’annexe manquante.
Le choix du 22 octobre 2026 remplace les sprites par des personnages 3D sur fond 2D :
TRANSITION-001 a été insérée après STEP-005 et avant STEP-006. Les anciens laboratoires
2D restent historiques ; la production d’assets 3D définitifs n’a pas été réalisée.
