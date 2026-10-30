# Chaîne d’éclairs — CHAIN-001

Validée sur Galaxy A16 : « Oui, CHAIN-001 validée ».
Choix Godot/Android : **C — Foudre déchaînée**, rebonds à 0,1 s. Base : MULTI-001, commit `dbb1d6cc5574`.
Clôture documentaire : code et APK identiques à la version validée.

## Contrat confirmé

Nassau reçoit Chaîne d’éclairs en plus d’Attaque et Booster : coût 30 PM,
incantation 2 s, recharge 4 s à la libération, portée initiale 4 unités.
Trois rebonds après le premier impact, soit quatre victimes maximum.
Le propriétaire confirme : dégâts fixes sans défense, réduction composée de
20 % arrondie à l’entier le plus proche : **30 → 24 → 19 → 15**.
Un ennemi ne peut être touché qu’une fois par lancement.

Le gambit « 3 ennemis ou plus → Chaîne d’éclairs » vérifie uniquement une
population d’au moins trois ennemis vivants, puis choisit le plus proche.
Aucune contrainte de voisinage, aucun calcul de groupe ou de trajet maximal.
Les critères à seuil utilisent désormais cette même règle pour les compétences
monocibles. Traits de glace conserve son préfiltre k=min(n,m), et les AOE
conservent la maximisation dans leur propre rayon : trois comportements séparés.

Pendant l’approche, toute la liste des gambits est réévaluée et un ordre
prioritaire peut interrompre le déplacement. Au cours du cast, une baisse de
population ou une dispersion n’annule pas le sort. La mort/perte de la cible
principale ou sa sortie de portée annule gratuitement et permet un nouveau
choix immédiat. Mana et recharge ne commencent qu’au lancement effectif.

Le premier impact arrive à la fin de l’incantation. Les suivants interviennent
après 0,1, 0,2 et 0,3 seconde de temps normal de combat. À chaque échéance,
rechercher l’ennemi vivant non encore touché le plus proche dans un rayon de
2,5 unités entre centres au sol autour de la victime précédente ; égalité par
ID stable. Les candidats sont ceux présents au moment du rebond, sans liste
précalculée. Sans candidat admissible, la chaîne s’arrête.

Le point de départ est la position actuelle de la victime précédente si son
acteur et son état d’origine existent encore ; sinon sa dernière position
connue à l’impact. Une victime tuée par l’éclair n’arrête donc pas les rebonds.
La chaîne libérée survit à la mort du lanceur ; pause, reset et fin du combat
suivent les règles des autres sorts libérés. Booster accélère incantation et
recharge, mais pas l’intervalle de 0,1 s ni la régénération des PM.

## Séparation logique / présentation

- `scripts/skills/chain_skills.gd` : paramètres, dégâts et recherche du prochain ennemi.
- `scripts/skills/chain_projectiles.gd` : chaîne détenue par le combat, références
  faibles aux anciennes victimes, identités déjà frappées, échéances et faits.
- `scripts/skills/area_projectiles.gd` : délègue l’horloge à cette file de chaînes,
  parallèlement aux autres sorts ; reset et génération partagés.
- `scripts/party/party_executor.gd` : engagement, annulation, coût unique, recharge.
- `scripts/presentation/chain_lightning_definition.gd`, `chain_lightning_segment.gd`
  et `chain_lightning_presenter.gd` : uniquement art passif. Chaque fait d’impact
  déclenche un arc rouge/rose ramifié avec cœur clair, réillumination brève,
  étincelles et halo local. Aucun shader ni effet ne peut infliger des dégâts.
- `resources/presentation/effects/chain_lightning.tres` : profil graphique remplaçable.

Icône fournie, copiée sans retouche depuis
`/home/arkhane/Crimson_Chain_Lightning.png` vers
`assets/art/skills/chain_lightning.png` ; mipmaps pour les petits gabarits.
Fiche de Nassau, éditeur de gambits, barre d’incantation, icône et effets de cast,
textes flottants, statistiques, MVP et journal sont reliés au même identifiant.
Le journal détaille chaque impact et la fin de chaîne sans doubler les totaux.

Le codec reste en v4. Les nouvelles configurations placent le nouveau gambit
après Booster chez Nassau. Les sauvegardes existantes ne sont pas réécrites
par le code ; l’ajout demandé sur le Galaxy a été explicite, après sauvegarde
des fichiers, sans remplacer les autres ordres ni modifier l’équipe ou les réglages.

## Recette

F6 : `scenes/debug/chain_lightning_lab.tscn`. Copie isolée ; fichiers joueur et
réglages uniquement en mémoire. Trois rendus : A Filament carmin, B Arc écarlate,
C Foudre déchaînée. Huit scénarios : quatre impacts ; plus proche isolé ; seuil
non atteint ; nouvelle cible au rebond ; principale tuée ; mort pendant cast ;
approche interrompue par Booster ; lanceur mort après lancement. Boucle,
replay et pause/lecture disponibles.

82 scènes / 6 096 contrôles réussis, dont 66 pour la chaîne. Captures GPU des
trois rendus et des quatre impacts, sans erreur moteur. Contrôles ciblés :
seuil global, absence de couverture préalable, dégâts ignorant une défense de
9 999, victimes distinctes, changement de cible, frontière 2,5 incluse,
annulation sans paiement, mort/disparition d’acteurs, pause, Booster, reset,
réentrance et libération complète des nœuds de présentation.

## Rythme et APK de recette

C — Foudre déchaînée retenue : arcs et fondus à leur vitesse d’origine,
intervalle des rebonds réduit de 0,3 à 0,1 s à la demande du propriétaire pour
un enchaînement plus fluide. Durée visuelle par segment 0,46 s : chevauchement
progressif des arcs, sans accélérer le scintillement ou le fondu.

APK `chain-001-debug.apk`, v94 `0.1.0-chain001`.
SHA-256 : `7a662a1362859ac6bf047e805875cc250fb859aa4dd9db01687feb1d555588c8`.
Installation avec conservation des quatre fichiers ; ajout explicite d’un seul
gambit de Nassau après Booster. Autres ordres, équipe, style et réglages conservés.
Le propriétaire confirme : « Oui, CHAIN-001 validée ».
Séquence native enregistrée, aucune erreur moteur ; téléphone laissé en pause
pendant une incantation de Nassau avant validation. Pas de mesure FPS.
Commit local et sauvegarde complète restaurée/vérifiée. Aucun push automatique.
