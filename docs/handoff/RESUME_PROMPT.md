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

# GAMEPLAY-002 — contournement local en recette

Anne, Mako et les squelettes partagent un navigateur local : détour, cache de chemin,
recalculs bornés et attente stable sans passage. GroundCrowd garde le contrôle de contact.
Rayon 0,35 et échelle 0,65 conservés. 39 bancs / 2 481 contrôles passent ; 28 scénarios
Android réussis et relevé de coût en combat réel. Voir docs/steps/GAMEPLAY-002.md et
docs/local-navigation.md. F6 : scenes/debug/local_navigation_lab.tscn ; F8/F5 : Main.
APK normal 0.1.0-gameplay002 (41), installé/lancé sur Galaxy A16.
Étape non commitée ; attendre validation avant clôture et GAMEPLAY-003.
Les sections suivantes décrivent les préparations et états historiques.

# Deux étapes ajoutées avant la livraison finale

À la demande du propriétaire : GAMEPLAY-002 ajoute un contournement local commun à tous
les héros/ennemis avec leurs dimensions actuelles ; GAMEPLAY-003 réduit ensuite leur emprise
et leur échelle visuelle pour faciliter les passages. Voir docs/local-navigation-plan.md et
les fiches docs/steps/GAMEPLAY-002.md / GAMEPLAY-003.md. Le plan est préparé ; aucun code de
mouvement ni gabarit n'est encore changé. GAMEPLAY-002 attend GO.
GRAPHICS-007 est clôturée au commit local 440829b, sauvegarde restaurée/vérifiée.
Ordre : GAMEPLAY-002 → GAMEPLAY-003 → STEP-029 → STEP-030.
APK normal actuel inchangé : 0.1.0-graphics007 (39). Les sections suivantes sont historiques.

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

# Reprise au 26 octobre 2026 — GRAPHICS-003

Lire PROJECT_STATUS.md, docs/steps/GRAPHICS-003.md, docs/character-presentation.md et
 docs/party-skills-plan.md. GRAPHICS-003 non commitée, en attente de validation. APK
0.1.0-graphics003 / code31 installé sur A16. Les états de combat sont inchangés ; GAMEPLAY-001
reste à faire. Les consignes anciennes ci-dessous décrivent les checkpoints précédents.

# Prompt à transmettre à la prochaine IA

Actualisation GRAPHICS-002 : GRAPHICS-001 est validée et clôturée au commit local f5a790d,
avec sauvegarde restaurée/vérifiée (354 fichiers). GRAPHICS-002 est implémentée après GO,
et validée par le propriétaire : catalogue des huit fonds fournis, vignettes et sélecteur
en pause dans le jeu et la galerie. Lire docs/steps/GRAPHICS-002.md et PROJECT_STATUS.md.
Le propriétaire demande le commit de GRAPHICS-002 ; vérifier Git pour son hash effectif.
GRAPHICS-003 attend les modèles 3D qu'il a annoncé fournir. origin/main n'a pas reçu le
checkpoint graphique local à la rédaction de cette note.
Les paragraphes suivants conservent le contexte des checkpoints antérieurs.

Actualisation GRAPHICS-001 : STEP-028 est clôturée au commit 580ce64, poussée et sauvegarde
restaurée/vérifiée (327 fichiers). Le propriétaire a validé la roadmap graphique et donné GO.
GRAPHICS-001 est maintenant implémentée, en attente de validation utilisateur : lire
docs/steps/GRAPHICS-001.md, docs/arena-presentation.md et docs/graphics-roadmap.md avant
les paragraphes historiques suivants. Main affiche le Colisée fourni, les anciens labs
gardent la référence. Ne pas redémarrer STEP-028 ni lancer STEP-029 à la place du chantier
graphique. La prochaine étape graphique après clôture est GRAPHICS-002.

Tu reprends Gambit Arena, prototype Godot Android portrait. Travaille en français et commence
par lire HANDOFF.md, PROJECT_STATUS.md, ARCHITECTURE.md, ROADMAP.md et docs/handoff/.
Lis aussi les instructions locales éventuellement présentes dans ton nouvel environnement.
Le dépôt fourni est la source de vérité ; vérifie ses fichiers et son état avant de modifier.

Dernière base commitée : HANDOFF-001 au commit
cc91c79b0bcf82df6fb852d9b792fce63aa32148, parent 665c0c8d86a6400f88c77773295ed06b1a518206.
STEP-028 est validée par l'utilisateur mais son commit et sa sauvegarde restent à faire.
Vérifie git log, git status et le remote réel. Ne suppose pas un push déjà effectué.

APK de référence STEP-028 : step-028-debug.apk, version 0.1.0-step028, code 28,
SHA-256 d2c710ef6fb1c935eb6afecbfe54e98b1a03d0a03266753c5c8b537cce1a23b9.
L'utilisateur a validé F6, F5, tactile Android et pause/reprise. Les mesures et leurs limites
sont dans docs/steps/STEP-028.md ; le seuil historique de 30 FPS Debug n'est pas atteint mais
est explicitement accepté pour le périmètre réel. Godot 4.7.2 et l'appareil ont été utilisés :
ne présente pas les contrôles historiques comme la seule preuve disponible.

Le jeu utilise des mannequins 3D procéduraux, pas des assets finaux. Un coordinateur contrôle
le combat, les coûts/effets sont uniques et partagés entre commandes manuelles et gambits.
Préserve impérativement : cible vivante à portée conservée entre actions et après soin,
aucun pas/jambes en marche à portée, swipe tactile sans commande parasite, trois vagues avec
comptes exacts, défaite/replay sans résidus, pause au retour Android avec reprise explicite.
Ne change pas animations, équilibrage ou gameplay pendant un chantier sans rapport.

Méthode établie : étape autorisée par GO ; archive complète sans .git/.godot ; recette F6 et
APK ; retour utilisateur + SHA ; archive de validation documentaire seule ; commit utilisateur
et sauvegarde vérifiée avant l’étape suivante. Ne réécris pas l’historique, ne fais pas de push
forcé, ne restaure pas silencieusement les modifications utilisateur. Les correctifs doivent
reproduire le bug dans un banc pertinent. Tous les détails sont dans la passation.

La clôture immédiate est le commit utilisateur STEP-028 puis sa sauvegarde vérifiée. STEP-029
(clone/import/export/install propre) et STEP-030 (recette finale MVP) ne sont pas réalisées.
Le plan détaillé proposé dans docs/handoff/NEXT_STEPS.md ne remplace pas le GO utilisateur.
Après vérification du commit et de la sauvegarde, attendre un GO explicite pour STEP-029.
