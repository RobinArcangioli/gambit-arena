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

# État courant

GRAPHICS-003 est en recette : modèles pirates, vues remplaçables, Idle/Walk, galerie.
Voir ../steps/GRAPHICS-003.md. Attendre validation puis commit/sauvegarde vérifiée.
Étape suivante : GAMEPLAY-001 selon ../party-skills-plan.md, puis GRAPHICS-004 à 007.
Les propositions anciennes ci-dessous sont remplacées lorsqu'elles contredisent ce plan.

# Roadmap restante et plan de reprise

## Nouvelle priorité validée — évolutions graphiques

STEP-028 est maintenant clôturée : commit 580ce64, push et sauvegarde vérifiés. Le propriétaire
a demandé de préparer des évolutions graphiques avant la recette finale. Lire la
[roadmap graphique](../graphics-roadmap.md), GRAPHICS-001 à GRAPHICS-007 : arènes, modèles 3D,
attaque, soin et Foudre, avec présentation interchangeable et gameplay préservé.
GRAPHICS-001 est clôturée au commit local f5a790d, sauvegarde restaurée/vérifiée.
GRAPHICS-002 est validée par le propriétaire, qui demande son commit ; les huit arènes et
leur catalogue sont implémentés. Les sections ci-dessous conservent le contexte des étapes
initiales de livraison, qui gardent leurs identifiants. La prochaine étape graphique est
GRAPHICS-003 : modèles 3D et animation de base, en attente des modèles annoncés par le propriétaire.

STEP-001 à STEP-027 sont clôturées selon les preuves du registre, avec reprise d’historique
RECOVERY-001 et transition 3D TRANSITION-001. HANDOFF-001 prépare la transmission et GitHub ;
elle n’autorise ni n’implémente STEP-028. Les trois étapes restantes gardent leur périmètre.

## STEP-028 — Mesures reproductibles et budget matériel

Actualisation du 26 octobre : instrumentation, protocole et campagnes Android sont exécutés.
Consulter ../steps/STEP-028.md pour les essais, résultats et SHA testé. L'ancien objectif de
30 FPS Debug n'est pas atteint ; le propriétaire a cependant accepté explicitement la performance
pour le périmètre réel, où 20 ennemis simultanés ne sont pas prévus. Le plan ci-dessous reste
le contexte historique de l'étape, pas une promesse de performance générale.

Le propriétaire a ensuite validé STEP-028 : F6, F5, tactile Android et pause/reprise OK.
La clôture immédiate consiste uniquement à commiter puis sauvegarder cette étape ; STEP-029
reste une étape distincte, à démarrer seulement avec son GO.

Objectif initial : vérifier le budget matériel, avec cible provisoire de 30 images/s soutenues
sur le Galaxy A16. Les mesures chiffrées et la décision produit sont maintenant consignées dans
`../steps/STEP-028.md` ; ne pas les remplacer par ce plan antérieur.

Plan d’implémentation proposé, à préciser au démarrage :

1. Relever appareil/OS, Godot/templates, APK/SHA, mode Debug ou Release, options de rendu,
   conditions de test (charge batterie, alimentation, luminosité, température si disponible).
2. Définir un protocole reproductible : durée de chauffe, durée de capture, scénario normal
   et scénario saturé à 20 ennemis, même UI/règles et répétitions. Fixer explicitement ces
   durées et critères avant de comparer des résultats.
3. Mesurer des temps de frame réels de rendu et de simulation séparément. Ne pas calculer
   les FPS avec le dt borné de GameClock ni présenter un test accéléré F6 comme une mesure réelle.
4. Relever distribution des temps de frame (médiane/p95/p99 ou équivalent), images longues,
   mémoire si disponible, pics d’acteurs/objets et dérive après resets. Choisir une collecte
   bornée et un export exploitable, sans remplir indéfiniment un tableau ou le journal UI.
5. Confronter les résultats à l’objectif 30 FPS ; documenter les limites des compteurs et
   l’influence de Debug/USB/éditeur. Ne pas promettre une conformité avec la seule moyenne.
6. N’optimiser que les postes réellement dominants, un changement à la fois, avec nouvelle
   mesure comparable et régressions ciblage/actions/swipe/cycle de vie.

Points à examiner, pas des goulots déjà prouvés : séparateur Crowd, captures/allocations de
snapshots, HUD actualisé et relayout différé, rendu SubViewport, ressources de diagnostic
incluses par all_resources. Aucun de ces éléments ne doit être supprimé sans preuve et recette.
Livrables attendus : protocole, données brutes, synthèse, APK identifié, décision sur budget.

## STEP-029 — Clone propre, import, export et installation

Objectif approuvé : reproduire une installation depuis un clone neuf sans cache existant.
La première publication GitHub de HANDOFF-001 ne valide pas à elle seule STEP-029.

Plan proposé : vérifier l’URL/branche et le commit de référence ; cloner dans un nouveau
dossier ; relever versions et chemins SDK/JDK/templates ; importer sans .godot réutilisé ;
exécuter les tests utiles ; exporter/installler un APK propre et relever son SHA ; documenter
ce qui est global à la machine (SDK, templates, signature Debug) et ce qui est versionné.
Ne pas exiger un APK bit-à-bit reproductible sans avoir étudié métadonnées et signature.
Vérifier aussi la restauration du bundle et une nouvelle sauvegarde. Ne pas inscrire de
mot de passe ou clé privée dans export_presets.cfg. La CI éventuelle n’est pas déjà en place.

## STEP-030 — Recette finale MVP

Objectif approuvé : validation finale sur un APK identifié. Rassembler la matrice gameplay,
UI/portrait/zones sûres, ciblage, coûts/impacts, trois vagues, défaite/replay, pause/Android,
performance et installation. Consigner les réserves connues, décisions, SHA et commit.
Ne pas déclarer le MVP finalisé simplement parce que STEP-027 est validée. Le contenu
artistique reste provisoire tant qu’un chantier distinct n’a pas été décidé.

## Après MVP — propositions, hors autorisation actuelle

Production de modèles/rigs/animations et décors définitifs, direction artistique, équilibrage,
options d’accessibilité, sauvegarde persistante ou publication boutique demanderaient des
choix explicites. Ce ne sont pas des extensions automatiques de STEP-028 à STEP-030.
L’annexe détaillée initiale n’était pas fournie dans le fichier de lancement : le registre
des 30 étapes est conservé, mais ne pas inventer une spécification originale plus détaillée.

## Premier tour recommandé pour la prochaine IA

Vérifier le commit STEP-028 et sa sauvegarde une fois fournis ; lire HANDOFF.md et les
invariants ; confirmer les outils réellement disponibles. Attendre ensuite un GO explicite
pour STEP-029. Toujours conserver les corrections utilisateur et les preuves de validation.
