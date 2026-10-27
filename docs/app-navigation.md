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

# Navigation d'application — UI-001

F5 ouvre scenes/app/app_root.tscn : image Home fournie et boutons Équipe/Arène en
surimpression. Équipe est visible mais désactivé dans cette première étape ; la page et
ses aperçus arrivent dans UI-002. Les routes team/hero/gambits sont réservées, pas simulées.
F6 scenes/main.tscn conserve le combat historique avec son UID et ses commandes de diagnostic.

## Propriété des scènes

AppRoot possède une route home ou arena et au plus une ArenaPage. Aucun PartySimulation
n'est instancié sur l'accueil. À l'entrée en arène, une nouvelle page charge les gambits
via le fichier existant user://party_rules_v2.json. PV, mana, actions et vagues sont neufs.
Au retour, le traitement et les gestes du combat sont arrêtés, la page est détachée puis
queue_free ; acteurs, barres, effets et chemins appartiennent à ce sous-arbre. Aucun état
de combat n'est conservé pour la prochaine entrée. Le fichier des règles n'est pas supprimé.

La transition est gardée contre les doubles appuis. Les signaux Escape et Retour Android rapprochés sont regroupés pendant 180 ms pour une
seule intention de navigation, avant le traitement des raccourcis du combat. Ils ferment d'abord
la modale ouverte, sinon abandonnent l'arène. Sur l'accueil, Retour Android reste sur
l'accueil : un double retour ne doit pas quitter l'application. La navigation système du
téléphone reste disponible. Les gardes d'arrière-plan et d'entrée existantes restent actives ;
retourner de l'arrière-plan n'abandonne pas un combat et ne le reprend pas automatiquement.

ArenaPage étend PartyApplication sans modifier celle-ci ni le moteur. Elle garde le même
éditeur en combat et la même persistance, les mêmes actions et présentateurs. La racine
historique et les laboratoires restent indépendants de cette composition produit.

## Arènes et composition

ArenaChoice possède un RandomNumberGenerator privé et un catalogue de huit IDs illustrés.
Chaque nouvelle entrée et chaque Rejouer effectuent un seul tirage uniforme ; référence
exclue et répétitions possibles. Ni pause/reprise ni vague ne relancent le tirage. Les tests
peuvent injecter un chooser ; son RNG ne consomme pas le flux global du gameplay.
L'identifiant du tirage est exposé par chosen_arena et journalisé dans les builds Debug.
Le sélecteur manuel reste accessible ; la référence est masquée dans cette page produit.

Le fond et le SubViewport 3D couvrent la page ; les boutons et les textes sont superposés.
Les anciens HeaderPanel/FooterPanel opaques sont masqués. Les modales sont des voiles
locaux translucides. La caméra et l'image calibrée zooment ensemble autour de la même
origine, jusqu'à couvrir le viewport. L'image n'est jamais étirée indépendamment des pieds.
Le diamètre physique 0,70 et le modèle à l'échelle 0,65 restent inchangés. Les barres utilisent
les nouvelles projections du viewport plein écran. La zone sûre s'applique aux commandes,
le décor couvre aussi les marges. Les listes gardent leur routeur de défilement tactile.

## Art et réglages

Source de vérité du thème : resources/ui/night_gold.tres (StyleBoxFlat, couleurs, états,
coins et marges). scripts/app/app_theme.gd est un générateur facultatif utilisé pour sa
création ; il n'est pas exécuté au démarrage. Modifier le .tres ne nécessite pas de modifier
la navigation. Palette : #10182F / #172B4D, or #D9AA4C, accent ambré et texte #FFF2D4.
Le texte d'un bouton désactivé reste lisible ; l'accueil garde le logo intégré à l'image.
Les deux images originales sont importées sans modification de leurs octets. Provenance
et empreintes dans assets/art/ui/README.md. team.png est prêt pour UI-002, sans page Équipe
cachée ou modèle 3D créé à cette étape.

Le nouveau point d'entrée est explicite dans project.godot. Les exports diagnostiques
navigation/qualification remplacent désormais l'entrée par expression régulière, sans
supposer l'ancien UID de Main. Leurs versions diagnostiques restent distinctes de l'APK normal.

## Vérifications

Voir steps/UI-001.md : parcours, sauvegarde existante, doubles entrées, abandon pendant les
sorts, vrai tap tactile et copie souris, trois formats, huit fonds calibrés, retours et
nettoyage. Les tests de régression historiques exécutent toujours leurs scènes d'origine.
Le contrôle natif valide séparément les notifications Retour Android et les boutons.
Aucune mesure FPS n'est déduite de ces captures.
