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

# GRAPHICS-004 avec fix1 — en recette

Base GAMEPLAY-001/fix1 clôturée au commit local b1dfb33, sauvegarde restaurée et vérifiée.
Attaques, réactions, morts et gestes Duck raccordés ; priorités strictes demandées par
le propriétaire et cas d'arrêt de lecteur corrigés. 34 bancs / 2 154 contrôles passent.
Voir docs/steps/GRAPHICS-004.md et docs/combat-presentation.md. APK actif code 35 installé et lancé sur Galaxy A16 ;
version vérifiée par ADB, validation visuelle utilisateur attendue. Étape non commitée.
Les sections suivantes décrivent les états historiques.

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

# GAMEPLAY-001 — livraison en recette

GRAPHICS-003 est clôturée au commit local 7956cfce2efcdaf4b95fd3f0631193cb9d442589,
sauvegarde restaurée et vérifiée (445 fichiers). Main utilise maintenant l'équipe Anne/Mako,
les compétences propres, les gambits alliés, la mana et les barres d'incantation.
31 bancs / 1 921 contrôles passent. APK 0.1.0-gameplay001 (32) installé et lancé sur A16.
Voir [la recette](docs/steps/GAMEPLAY-001.md) et [les choix de gameplay](docs/party-gameplay.md).
Étape en attente de validation ; pas de commit/push de GAMEPLAY-001. GRAPHICS-004 suit.
Les sections suivantes sont historiques.

# GRAPHICS-003 validée — clôture autorisée

Le propriétaire valide GRAPHICS-003 et donne GO pour GAMEPLAY-001.
Les fichiers non documentaires sont identiques à la livraison validée.

# Actualisation GRAPHICS-003 — livrée en recette

Base GRAPHICS-002 : commit local 1e427560a9d2884ce1d3e339a093d576192fc22f,
sauvegarde restaurée et vérifiée. GRAPHICS-003 ajoute les quatre modèles pirates, Idle/Walk,
les vues remplaçables et la galerie character_lab. 28 bancs / 1 803 contrôles sans échec.
APK 0.1.0-graphics003 (code 31) installé et lancé sur Galaxy A16 ; rendu capturé.
Voir [la recette](docs/steps/GRAPHICS-003.md). Validation utilisateur et commit en attente.
GAMEPLAY-001 vient ensuite : équipe Anne/Mako, soin allié, Foudre, mana et barres.
Les sections ci-dessous décrivent les états historiques.

# État du projet — 26 octobre 2026

## GRAPHICS-002 — validée, commit autorisé

GRAPHICS-001 validée, commit local `f5a790d38ed12cd3ccc3bac85162308986a5f894`.
Sauvegarde `gambit-arena-20261026-055618-f5a790d38ed1.tar.gz` restaurée et vérifiée :
bundle, intégrité Git et 354 fichiers identiques. Ce checkpoint est local ; origin/main
reste à STEP-028 tant qu'aucun push supplémentaire n'a été effectué.

GO reçu pour GRAPHICS-002 : les huit arènes sont intégrées, avec vignettes et sélecteur commun
au jeu et à la galerie. Ouverture en pause, choix sans reset ni mutation du combat, reprise
explicite, Rejouer conserve le décor dans la session. 27 bancs headless : 1 728 contrôles,
zéro échec et aucun warning/erreur Godot ; 14 contrôles en fenêtre passent également.
Voir [docs/steps/GRAPHICS-002.md](docs/steps/GRAPHICS-002.md).

GRAPHICS-002 est explicitement validée par le propriétaire, qui demande son commit.
La sauvegarde sera créée et vérifiée après ce commit. GRAPHICS-003 attend les modèles 3D
de personnages/ennemis annoncés par le propriétaire. GRAPHICS-003 à GRAPHICS-007, puis
STEP-029/030 restent à réaliser. Les sections suivantes sont historiques.

## GRAPHICS-001 — validée par le propriétaire

Roadmap graphique validée par le propriétaire, GO reçu. Base commitée : STEP-028 / 580ce64.
Le Colisée fourni est intégré dans Main via une Resource de présentation ; la référence
procédurale reste le défaut des anciens laboratoires. Galerie indépendante et test de contrat
ajoutés. Les huit thèmes sont fixés par l'archive reçue ; sept restent pour GRAPHICS-002.
Voir [docs/steps/GRAPHICS-001.md](docs/steps/GRAPHICS-001.md) et
[docs/arena-presentation.md](docs/arena-presentation.md).

Les 26 bancs headless passent 1 649 contrôles ; sept contrôles graphiques supplémentaires
passent en fenêtre. Le propriétaire a validé GRAPHICS-001 et donné le GO pour GRAPHICS-002.
Checkpoint et sauvegarde de la première étape à réaliser avant l'intégration du catalogue.

## Actualisation — clôture STEP-028 et proposition graphique

STEP-028 est clôturée au commit `580ce641390f30667133cec0a580ee3d64f0c51a`, poussé sur main.
Sauvegarde `gambit-arena-20261026-044515-580ce641390f.tar.gz` restaurée et vérifiée : bundle
valide, contrôle d'intégrité Git et 327 fichiers identiques au commit. Les mentions de commit
en attente dans la section suivante décrivent la validation avant cette clôture.

Le propriétaire demande maintenant une roadmap d'évolutions graphiques isolées du gameplay.
Plan dans [docs/graphics-roadmap.md](docs/graphics-roadmap.md) : GRAPHICS-001 à GRAPHICS-007,
arènes puis modèles 3D, attaque, soin et Foudre. Le plan est maintenant validé et GRAPHICS-001
est en recette ; STEP-029 et STEP-030 restent à faire après le chantier graphique.

## STEP-028 — validée par l'utilisateur, commit et sauvegarde en attente

Base réelle vérifiée : cc91c79b0bcf82df6fb852d9b792fce63aa32148, main propre et identique
à GitHub au démarrage. Aucun changement utilisateur à écraser. HANDOFF-001 a bien été
commitée et publiée ; les sections historiques ci-dessous décrivent sa rédaction antérieure.

Instrumentation optionnelle, captures bornées, menu de mesures et export JSON implémentés.
Protocole fixé dans docs/performance.md : chauffe 30 s, capture 60 s, trois répétitions
Normal/20 ennemis et dix resets. Tests et mesures effectifs : docs/steps/STEP-028.md.
L'objectif initial de 30 FPS n'est pas atteint par cet APK Debug, avec ou sans économie
d'énergie ; le propriétaire a explicitement accepté la performance pour le contenu prévu et a
retiré 20 ennemis simultanés des critères de livraison. Aucun correctif de rendu spéculatif n'a
été intégré. Le propriétaire a explicitement validé F6, F5, tactile Android et pause/reprise.
STEP-028 est donc validée par l'utilisateur ; aucun commit/push ni sauvegarde STEP-028 n'a été
effectué.

## Dernière étape fonctionnelle clôturée

STEP-027 : validée et commitée, sauvegarde reçue et vérifiée.
Commit : 665c0c8d86a6400f88c77773295ed06b1a518206 ; branche main propre au checkpoint.
Parent : 344a584ec680ba7b45fb648b3a2eceb8937a97ae.
Backup : gambit-arena-20261026-011155-665c0c8d86a6.tar.gz.
Bundle complet, fsck OK, 307 fichiers identiques entre commit/backup/livraison validée.
APK : step-027-debug.apk ; version 0.1.0-step027, code 27.
SHA-256 : 07467efcfb7e663e363e6f6fc61644fd2bf2889e7ee3a3001d42589e0c6cf611.
Retour utilisateur : F6 OK, tests manuels OK, fluidité OK. Aucun résultat détaillé par banc
ou mesure chiffrée fourni. Aucune nouvelle réserve signalée à cette clôture.

## HANDOFF-001 — Documents préparés, commit/push à effectuer

Demande utilisateur : documenter le projet pour une prochaine IA, créer une archive et
fournir les commandes de push GitHub. Livrable : gambit-arena-complet-handoff-001.tar.gz.
Documents d’entrée actualisés et dossier docs/handoff ajouté. Aucun changement de code,
scène, test, asset, preset ou project.godot ; aucun nouvel APK requis.
Le bundle inclus reste celui de 665c0c8 ; les documents sont dans les sources mais pas encore
commités. Aucun hash documentaire ni URL GitHub ne sont inventés. Aucun push effectué ici.
La prochaine IA doit vérifier si le commit/push a été réalisé après rédaction de cet état.

## Suite

Préparer le commit STEP-028, créer la sauvegarde après le commit et vérifier celle-ci.
Transmettre le hash, le statut et la nouvelle sauvegarde pour vérification. STEP-029 et
STEP-030 restent à faire et nécessitent leur propre GO ; aucun push n'est implicite.

## Limites de preuve

Les limites « Godot non disponible » des sections historiques décrivent HANDOFF-001, non le
travail STEP-028 effectivement exécuté. Le clone propre final et la recette MVP finale restent
à réaliser. Voir HANDOFF.md et docs/handoff/NEXT_STEPS.md.
