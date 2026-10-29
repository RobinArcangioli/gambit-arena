# PORTRAITS-001 validée — 29 octobre 2026

Le propriétaire confirme sur Galaxy A16 : « Oui, étape validée » pour la version
corrigée : Mako remonté dans Équipe et Combat, Anne inchangée, cadres Idle plus petits
avec modèles conservés à leur taille initiale et buffs horizontaux au bas des panneaux.
Les PNG fournis sont intacts. Les cadrages et fenêtres de présentation sont indépendants
de la logique de jeu. Les 69 scènes / 5 105 contrôles et la recette tactile Android
avaient réussi. Gambits et réglages sont conservés octet pour octet ; pause vérifiée.
Clôture documentaire uniquement : code, ressources, configuration et APK identiques
à la livraison validée. Aucun nouveau test ni mesure de performances à cette clôture.
APK installé : `0.1.0-portraits001-layout` (80), SHA-256
`fd47a9d30effb17185507dac7b3739c71693efd4fcb8630bdfe9d227deb44ad6`.
Clôture par commit local et sauvegarde complète restaurée/vérifiée. Aucun push automatique.
Prochain GO : UI-005, qualification intégrée Android, puis STEP-029/030.
Les états précédents ci-dessous sont historiques.

# PORTRAITS-001 — Illustrations 2D et cadres Idle

Statut : en recette, validation visuelle propriétaire attendue.

## Ressources et séparation

Les deux PNG 941×1672 de Downloads sont copiés octet pour octet sous
assets/art/portraits/illustrations/. Noms d’origine et SHA-256 : provenance.json.
Les anciennes images carrées restent intactes. Aucune image générée ou retouchée.
Les mipmaps concernent uniquement l’import Godot. HeroIllustration est un Control
passif partagé, avec catalogue, zooms et points focaux dans
scripts/presentation/hero_illustration.gd. Son recadrage remplit l’emplacement sans
étirement ; le bas peut être tronqué. Les points focaux Équipe/Combat sont séparés.
Mako est remonté sur les deux pages ; Anne conserve son cadrage initial approuvé.
Aucun accès à la simulation, aux actions ou aux sauvegardes. Remplacer l’art ou le
cadrage reste une modification de présentation.

## Équipe

Quatre emplacements 2×2 : Mako, Anne, Vide, Vide. Les cartes occupées affichent
l’illustration principale, un nom lisible sur bleu nuit et le petit cadre Idle bleu nuit/or.
L’image principale réserve 12 px à droite/en bas ; le cadre 3D chevauche son coin et
dépasse de 12 px sur chaque axe. Le bouton entier contient le montage : aucun débordement
sur les voisins. Illustrations et cadre transmettent les touches à la carte.

Le cadre conserve le vrai modèle et son Idle. Sa taille rendue reste celle de la première
proposition : la taille du SubViewportContainer et le calcul de caméra sont inchangés.
Le cadre extérieur est resserré à 74 % de la largeur et 72 % de la hauteur initiales,
avec 2 px de marge intérieure. Un Control clippé retire le vide autour du viewport
initial, sans zoom ni agrandissement du modèle. Le moteur de portrait 3D lui-même est
identique octet pour octet à la base. L’arrêt des animations et du rendu hors focus,
la libération des viewports et le lien direct vers la fiche sont préservés.
Aucune sélection persistante, aucun modèle sous les emplacements vides.

## Combat

Portrait rapproché fixe 42×76 dans la colonne gauche, marges existantes. La zone ne
dépend pas des proportions du PNG. Les trois barres gardent leur longueur, couleurs,
textes et icône de sort calée à droite. Leur groupe et le nom remontent de 4 px pour
libérer la ligne de buffs à y=80 dans le contenu. Les buffs s’alignent à gauche dans
une HBoxContainer à espacement 4 px, sur une seule ligne clippée au panneau.
La hauteur commune passe de 106 à 110 px pour conserver le padding sous cette ligne.
Les quatre cases, vides comprises, gardent la même taille ; leur bloc reste en bas,
et l’arène ainsi que les menus adaptent leur zone par le layout existant.
Aucun portrait ni nouvelle icône au-dessus des modèles. Les variantes du laboratoire
historique adaptent leur hauteur à la taille des buffs.

## Vérifications

69 scènes / 5 105 contrôles réussis, sans échec ni warning moteur. Nouveau banc à
78 contrôles : SHA des images, montage décalé contenu dans les cartes, cadre réduit
et viewport de taille initiale, absence de déformation, conservation des points focaux,
cadrage fixe en combat, égalité des quatre panneaux et libération des viewports,
à 540×960, 540×1170 et 360×640. Les bancs Équipe existants conservent les vrais touchers
sur les modèles, les retours de fiche, le cycle de vie et les animations Idle.
Le banc des icônes vérifie l’alignement horizontal des buffs, la disparition des états
expirés et la pureté des rafraîchissements. Captures GPU de la révision finale ;
le laboratoire Équipe/Combat est aussi exécuté aller-retour sans erreur.
Recette Android : Équipe, Idle animé, Mako/Anne et retours de fiche, formation, combat
avec buffs et portrait 2D, pause figée. Aucun changement aux fichiers du joueur.
Aucune mesure FPS. Validation esthétique du propriétaire attendue.

## Laboratoire et livraison

scenes/debug/hero_illustrations_lab.tscn : onglets Équipe/Combat, sans lecture/écriture
des sauvegardes du joueur. tools/export_hero_illustrations_lab.py exporte depuis une
copie isolée ; Main reste inchangé. Archive complète sans .git/.godot, bundle de la
base séparé et restauration vérifiée. Aucun fichier privé livré.

Normal : portraits-001-layout-debug.apk, 0.1.0-portraits001-layout (80).
SHA-256 : `fd47a9d30effb17185507dac7b3739c71693efd4fcb8630bdfe9d227deb44ad6`.
Laboratoire : portraits-001-layout-lab-debug.apk, 0.1.0-portraits001-layout-lab (80).
SHA-256 : `dd6dea1c38e96262892a76e8ac62006e8351cb5be35c414af6511f4e5b572e16`.
Validation attendue avant commit. Aucun push automatique. UI-005 reste à qualifier
après clôture de cette évolution visuelle.
