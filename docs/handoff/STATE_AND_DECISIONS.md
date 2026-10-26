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
