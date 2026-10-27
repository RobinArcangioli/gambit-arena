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

# GAMEPLAY-002 en recette

La navigation locale commune aux héros et ennemis est implémentée sur Main ; elle contourne
les empreintes logiques, sans ajouter de collisions aux PNG. Les gabarits restent inchangés.
Voir ../local-navigation.md et ../steps/GAMEPLAY-002.md. GAMEPLAY-003 attend validation/clôture
de cette étape. Les décisions et exclusions suivantes décrivent des états antérieurs.

# Actualisation après GRAPHICS-007

L'équipe Anne/Mako, les squelettes pirates, le soin et Foudre sont livrés et validés ;
GRAPHICS-007 est clôturée au commit 440829b. La nouvelle demande autorise la préparation de
deux étapes avant STEP-029 : GAMEPLAY-002 (navigation locale sur les obstacles logiques,
commune à tous) puis GAMEPLAY-003 (rayon et échelle visuelle réduits). Plan détaillé dans
../local-navigation-plan.md. La navigation globale complexe et le décor bloquant ne font
pas partie de cette demande. Aucun changement d'implémentation avec cette mise à jour.
Les décisions et exclusions ci-dessous décrivent des états historiques.

# État et décisions à préserver

## Produit

Gambit Arena est un prototype Godot Android portrait : arène fixe, héros autonome,
ennemis poursuivants, combat piloté par trois gambits et commandes manuelles de compétences.
Le joueur ne déplace pas directement le héros. Une partie comporte trois vagues.
Six emplacements de compétences sont affichés, trois actifs (attaque, soin, spéciale).
L’éditeur permet activation, ordre et champs cible/condition/seuil/action ; Rejouer conserve
ces réglages pendant la session. Pas de persistance sur disque.

Exclus du MVP actuel : équipe, multijoueur, backend, pathfinding complexe, décor bloquant,
progression persistante, publication boutique. Ne pas ajouter ces systèmes pendant une
correction ou l’instrumentation de performance.

## Présentation et assets

Le prototype 2D initial a été validé jusqu’à STEP-005. Le 22 octobre, l’utilisateur a choisi
des personnages 3D sur fond 2D isométrique. TRANSITION-001 a vérifié cette approche avant
STEP-006. Aujourd’hui les personnages sont des mannequins procéduraux (BoxMesh/SphereMesh),
avec poses de diagnostic ; ce ne sont pas des modèles finaux riggés/animés.
La caméra est dimétrique, sol logique 2D et positions mondiales 3D. 540 × 960 est la référence
portrait ; 48 pixels est un repère historique, pas un cahier des charges artistique final.
Les anciens SVG/atlas et scènes de laboratoire restent dans le dépôt pour les régressions.
Des illustrations envisagées ailleurs ne doivent jamais être présumées intégrées au dépôt.
La licence publique globale du jeu reste à choisir par le propriétaire ; lire docs/assets.md
et assets/actors/PROVENANCE.md. Aucun pack commercial tiers n’est présumé disponible.

## Garanties de gameplay non négociables sans nouvelle décision utilisateur

- Un seul impact par action et un seul coût/cooldown à l’engagement.
- Exécuteur partagé entre automatique et manuel ; pas de dégât appliqué depuis l’UI.
- Une commande manuelle en attente, remplaçable, valide trois secondes de temps de jeu.
  Elle ne coupe pas une action déjà engagée. La pause fige son échéance.
- Le héros conserve sa cible offensive tant qu’elle vit et reste à portée, même si un
  autre ennemi devient plus proche. Soin sur soi et commande manuelle partagent cette mémoire.
- Une cible morte/hors portée permet un nouveau choix. La suppression ou le remplacement
  d’état invalide aussi les références. Une règle non satisfaite ne doit pas contourner
  le verrou pour choisir un autre ennemi à portée.
- Aucun petit pas répété ni marche parasite entre attaques sur une cible déjà à portée.
  Ne pas « corriger » ce comportement par un changement d’animation.
- Aucun soin gratuit entre vagues ; même héros, PV, ressource, cooldowns et action engagée.
- Mort du héros prioritaire, même au tick du dernier ennemi. Pas de fausse victoire lors
  d’une suppression externe d’acteur.
- Pause/arrière-plan : aucun rattrapage de temps mural ; reprise explicite au retour.
- Rejouer recrée le héros, retire les anciens exécuteurs/acteurs, efface comptes et traces,
  conserve les gambits et la pause. Les identifiants restent monotones.

## Valeurs actuelles (configuration de prototype, pas équilibrage final)

| Élément | Valeur |
|---|---|
| Portée d’attaque | 1 unité, borne incluse |
| Préparation/récupération | 0,6 s / 0,4 s |
| Évaluation des gambits | 10 Hz hors action engagée |
| Énergie maximale/régénération | 60 / 5 par seconde de jeu |
| Soin | soi, 30 PV, coût 20, cooldown 4 s |
| Spéciale | dégâts 2 × attaque − défense, coût 30, cooldown 6 s |
| Attaque normale | gratuite, dégâts au moins 1 |
| Commande en attente | une seule, expiration à 3 s de jeu |
| Normal et Soin | 3 × 12 ennemis, plafond simultané 6 |
| Charge | 3 × 24 ennemis, plafond simultané 20 |
| Arrivées | première après 1 s ; cadence 2 / 1,5 / 1 s selon les tiers |
| Collision/séparation | rayon 0,35 ; plafond global 20 vivants |
| Horloge | dt de gameplay borné à 1/30 s |
| Diagnostic | journal borné à 64 entrées |

Les profils de laboratoire restent locaux : normal héros 250 PV/attaque 30 ; Soin profil
100 PV avec 60 dégâts initiaux dans le laboratoire ; Charge héros 2500 PV.
Les tests utilisent parfois un héros durable pour isoler les mécaniques de l’équilibrage.
Cela ne prouve pas que le scénario normal est gagnable dans toutes les configurations.

## Correctifs ayant motivé des retours utilisateur

| Correctif | Cause / leçon |
|---|---|
| FIX-STEP-014-001 | Consigner correctement validation/configuration ; archive initialement absente, export_path et project.godot à surveiller |
| FIX-STEP-018-001 | Le monde contient aussi caméra/lumières ; compter les acteurs par type, pas tous les enfants. Éviter les noms locaux confusables |
| FIX-STEP-019-001 | Arrêt du mover à 0,8 contre portée 1 : approche inutile et jambes en marche. Bloquer l’approche du héros déjà à portée |
| FIX-STEP-021-001 | ScrollContainer mesure son enfant direct ; tenir compte des hauteurs minimales réelles pour atteindre la dernière règle |
| FIX-STEP-023-001 / FIX-STEP-024-001 | Molette OK ne prouve pas swipe OK. Routeur tactile explicite ; annulation, copie souris et clic unique. Initialiser chosen à null |
| STEP-025-fix1 | La cible était recalculée entre deux actions ; mémoire offensive persistante partagée par gambits et manuel |

Tous sont inclus dans la base STEP-027. Voir les fichiers correspondants sous docs/steps.
L’utilisateur surveille particulièrement le ciblage, le swipe Android et les animations.

## Limites ouvertes

Pas de mesures de performance chiffrées ; « fluidité OK » est un retour qualitatif.
Pas de campagne clone/export propre finalisée (STEP-029). Pas de recette finale MVP (STEP-030).
Pas de reprise de partie après destruction du processus Android. Aucun serveur ou compte joueur.
Godot n’a pas été exécuté dans l’environnement de l’assistant ; les validations moteur proviennent
explicitement de l’utilisateur. Ne pas transformer cette distinction en faux résultat automatisé.
