# GRAPHICS-013 validée — 29 octobre 2026

Le propriétaire confirme « Step validée. » après approbation du cadrage sur Galaxy A16.
Icônes Discret dans les compétences et gambits ; icône d'incantation au bord droit
fixe de la barre des panneaux héros. Portraits retirés, buffs verticaux en haut à
gauche au padding commun. Grille 2×2 en bas avec quatre panneaux identiques ; arène
légèrement dézoomée et recadrée au-dessus, compteur de vagues au-dessus de la grille.
Les 62 bancs / 4 191 contrôles et la recette Android avaient déjà réussi.
Clôture documentaire uniquement : code, ressources, configuration et les deux APK
restent identiques à la livraison validée. Pas de nouvelle exécution des tests.
APK normal installé : `0.1.0-graphics013-layout` (63), SHA-256
`e43cc09f1411c2e9ecd1b76fe97237bae6f9894f9eabf3dd56c0965219066a91`.
Gambits conservés. Le laboratoire a été exporté ; seule la version normale du dernier
cadrage a été installée et validée. Clôture par commit et sauvegarde complète vérifiée.
Prochain GO : UI-005, qualification intégrée Android, puis STEP-029/030.
Aucun push automatique. Les états précédents ci-dessous sont historiques.

# GRAPHICS-013 — Grille basse et cadrage Android approuvé — en recette

Le 28 octobre, le propriétaire valide sur Galaxy A16 : « Oui, ce cadrage me convient ».
Arène légèrement dézoomée (base 8 %) et cadrée au-dessus de la grille 2×2 placée en bas.
Quatre panneaux strictement identiques : 106 px de hauteur, ancrage à 12 px du bas de la
zone sûre, compteur de vagues juste au-dessus. Pause reste en haut à droite.
Le décor, les personnages et leurs barres partagent la même projection ; le cadrage
s'adapte aux petits formats. Les icônes Discret, les buffs verticaux au padding commun
et l'absence de portraits sont conservés. Aucun changement de logique de jeu.
62 bancs / 4 191 contrôles réussis. APK normal `0.1.0-graphics013-layout` (63) installé :
`e43cc09f1411c2e9ecd1b76fe97237bae6f9894f9eabf3dd56c0965219066a91`.
Gambits conservés ; gel de la pause et SHA installé vérifiés. La validation du cadrage
est acquise ; clôture complète de GRAPHICS-013 après validation de l'étape.
Prochain GO après clôture : UI-005, puis STEP-029/030.
Les états précédents ci-dessous sont historiques.

# GRAPHICS-013 — Icônes des compétences et buffs des héros

Statut : en recette, validation de l'étape attendue. Base MODE-INFINI-001 clôturée,
`2da42df24f70812fa4ad53bf949ce1282791cc95`. Choix visuel utilisateur : A — Discret.
Précisions intégrées ensuite : supprimer les portraits de ces panneaux, utiliser leur
place pour les buffs verticaux, alignés en haut à gauche avec le padding commun.

## Présentation et données

Les trois images fournies sont copiées à l'identique dans `assets/art/skills/`, sous
les noms `heal.png`, `lightning.png`, `booster.png`. Les sources gardent leur définition
1024 ; l'import Godot utilise une limite 256 avec mipmaps pour l'interface mobile.
`skill_icons.gd` est le catalogue unique ; `skill_icon_style.gd` et
`resources/presentation/skill_icons/standard.tres` définissent les tailles, facilement
modifiables sans modifier coûts, ciblage, buffs ou animations de combat.

- Fiches : image de 40 px à côté du nom de Soin/Foudre/Booster.
- Gambits : icônes 16 px dans le choix de capacité et ses options, avec les noms et
  la sauvegarde immédiate conservés. Le champ capacité réserve plus de largeur sur
  les formats larges. Attaque conserve son texte, aucune image dédiée n'étant fournie.
- Incantation : image 16 px dans le panneau du lanceur, alignée au bord droit
  théorique de la barre, indépendante du remplissage. Texte blanc conservé avec
  espace réservé ; image cachée dès résolution ou annulation. Aucun ajout sur les
  barres flottantes au-dessus des modèles.
- Buffs : colonne verticale d'images 14 px dans l'ancien espace gauche du portrait,
  alignée sur les marges internes du panneau (14/8 px). Espacement vertical de 4 px.
  Booster reprend exactement sa texture de compétence. Les icônes suivent uniquement
  les états actifs reçus : apparition, expiration, retrait et mort ; aucune horloge
  ou dépense déclenchée par la vue. Les nœuds sont réutilisés tant que le buff existe.

Les portraits des quatre panneaux de combat sont retirés. Les quatre cadres gardent
106 px de hauteur ; la grille complète est maintenant ancrée en bas de la zone sûre,
avec 12 px de marge, deux rangées espacées de 8 px et le compteur juste au-dessus. La gouttière de buffs est bornée et découpée
pour ne pas empiéter sur les barres. Noms et textes de ressources restent lisibles.
Longueurs des barres, néons, segmentation et logique du mode Infini inchangés.

## Vérifications réellement exécutées

- Suite complète : 62 scènes / 4 191 contrôles, zéro échec, erreur ou avertissement.
- 67 contrôles spécifiques : références de textures, ancrage fixe, annulation,
  expiration/mort, absence de portraits et d'icônes sur les barres flottantes,
  alignement sur le padding, empilement de plusieurs états de présentation,
  réutilisation de nœuds, affichage sans mutation de la simulation ou des sauvegardes.
- Grille basse de quatre tailles identiques, compteur et inclusion des icônes vérifiés en 540×960,
  540×1170 et 360×640 avec zone sûre décalée. Barres de largeur identique.
- Aperçus GPU : combat Foudre/Soin et Booster, fiches Mako/Anne, gambits et menus,
  petit format ; coordonnées conservées, aucun nœud orphelin. La capture automatisée
  attend la libération des pages avant redimensionnement ; le scénario figé de
  capture peut rendre sans focus, sans changer les protections du produit.
- Galaxy A16 : contrôle visuel du panneau sans portrait, icônes d'incantation/buff,
  fiches et gambits, pause gelée, configuration joueur conservée. Recette native de la version normale finale, version et SHA vérifiés ; laboratoire
  correspondant exporté pour la livraison. Aucun benchmark FPS nouveau.

## Recette

F6 : `scenes/debug/skill_icons_lab.tscn`, démarrage sur A. Combat, Fiche et Gambits
permettent de comparer ; « Sort Mako » alterne Foudre/Booster et « Mako ↔ Anne »
change le héros des autres onglets. Le laboratoire est figé et utilise uniquement
`user://icons001-lab.json`, sans lire ou écrire la configuration normale du joueur.
F8 avant F5. F5 garde l'accueil et le mode Infini. Banc automatisé :
`scenes/tests/skill_icons_tests.tscn` → 67 contrôles, zéro échec.

Les demandes successives ont remplacé la première proposition de ligne sous la barre
par une colonne gauche sans portrait ; la livraison finale contient cette dernière
version. Les portraits utilisés ailleurs dans le projet ne sont pas concernés.

APK normal `0.1.0-graphics013-layout` (63), installé :
`e43cc09f1411c2e9ecd1b76fe97237bae6f9894f9eabf3dd56c0965219066a91`.
APK laboratoire `0.1.0-graphics013-layout-lab` (63) :
`26cd9355ca8d90c04207906caffa84fa548c62b81cdbbb177f72fbaee6e0c1a7`.
Export isolé du laboratoire sans modifier Main :
`python3 tools/export_skill_icons_lab.py --godot /chemin/godot --output /chemin/lab.apk`.

Livraison complète avec sources, deux APK, preuves et manifestes, sans `.git/.godot`
ni configuration privée. Historique séparé à la base `2da42df`, sans ces changements
non commités. Extraction et comparaisons effectuées avant synchronisation du dépôt.
Validation utilisateur avant commit/sauvegarde de clôture ; aucun push automatique.
Puis UI-005, STEP-029 et STEP-030.

## Cadrage Android validé le 28 octobre

La version haute des panneaux est remplacée par une grille basse à quatre dimensions
égales, calculée dans la zone sûre. Le compteur suit la grille et l'incantation centrale
reste dans la zone de combat supérieure. Le zoom de présentation commence à 1,08 fois
la taille de caméra précédente, puis s'adapte seulement si le terrain complet et la
hauteur des modèles ne tiennent pas dans la zone disponible. Un décalage visuel commun
repositionne sol, personnages et barres sans modifier les positions simulées.
Le fond prolonge en miroir ses seules bordures décoratives hors du rectangle calibré,
pour éviter les bandes vides. L'illustration intérieure et les pieds restent alignés.
Les anciens bancs de navigation/layout sont actualisés pour vérifier ce cadrage, les
huit décors et les petits formats ; les 62 bancs réussissent. Le propriétaire approuve
explicitement le résultat installé sur le Galaxy. Aucun nouvel équilibrage ou benchmark.
Le laboratoire fourni est exporté mais n'a pas remplacé sur téléphone le combat normal
que le propriétaire vient de valider.
