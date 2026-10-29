# ARENA-002 validée — 29 octobre 2026

Le propriétaire confirme sur Galaxy A16 : « Oui, step validée » pour les réglages de
combat et les huit arènes sans quadrillage blanc. Engrenage de 30 px, intérieur bleu
nuit, contour or, sans cadre, zone tactile de 48 px alignée au bord droit central.
Menu translucide, titre or, options PV / PM / Incantation indépendantes pour héros et
ennemis, actives par défaut et mémorisées immédiatement. OK compact et combat continu.
Compteur agrandi à 22 px, texte strict « Vague N », y compris après une défaite.
Les 64 bancs / 4 321 contrôles et la recette Android avaient déjà réussi.
Clôture documentaire uniquement : code, ressources, configuration et APK restent
identiques à la livraison validée. Pas de nouvelle exécution des tests.
APK normal installé : `0.1.0-arena002-layout` (66), SHA-256
`4e3f7734f3135fa32210e318b0dcb46efdaa66854626512c082f8b39364a5ef8`.
Gambits conservés octet pour octet ; réglages persistants et gel de la pause vérifiés.
Clôture par commit et sauvegarde complète restaurée/vérifiée.
Prochain GO : UI-005, qualification intégrée Android, puis STEP-029/030.
Aucun push automatique. Les états précédents ci-dessous sont historiques.

# ARENA-002 — Réglages de combat et décors sans grille — en recette

Base GRAPHICS-014 clôturée : `62cc34bfc23249b96c5e1cc38684dabc9e8326e0`.
Le 29 octobre 2026, engrenage seul agrandi à 30 px, zone tactile 48 px alignée au bord
droit du rectangle central, sans marge supplémentaire.
Intérieur bleu nuit, contour or, extérieur transparent ; aucun fond ni cadre de bouton.
Menu translucide assorti aux panneaux héros, deux cases indépendantes pour les barres
flottantes des héros et des ennemis, actives par défaut, effet et sauvegarde immédiats.
Combat maintenu en cours ; bouton OK compact, centré, ajusté au texte, qui ferme le menu.
Options libellées PV / PM / Incantation ; titre « Réglages de combat » en or #ffd16a.
Compteur de vagues agrandi à 22 px : texte strict « Vague N », même après une défaite.
Les panneaux bas et leurs barres restent visibles. Menu absent hors arène.
Les huit fonds et miniatures sont remplacés par des variantes sans quadrillage blanc,
créées avec imagegen intégré. Aucune option de grille. Joints naturels conservés,
caméra et coordonnées de jeu inchangées. Qualification dans `docs/steps/ARENA-002.md`.
Validation complète de l’étape attendue avant commit et sauvegarde de clôture.
Prochain GO après clôture : UI-005, qualification intégrée Android, puis STEP-029/030.
Les états précédents ci-dessous sont historiques.

# GRAPHICS-014 validée — 29 octobre 2026

Le propriétaire confirme sur Android : « Oui, step validée » pour le réglage B —
Équilibré. Le fin contour bleu et les huit particules attirées vers le lanceur sont
validés pendant l’incantation de Soin, Foudre et Booster. La présentation reste isolée
de la logique ; elle s’arrête à la résolution, à l’annulation, à la mort et au reset.
Les 63 bancs / 4 215 contrôles et la recette Galaxy A16 avaient déjà réussi.
Clôture documentaire uniquement : code, ressources, configuration et les deux APK
restent identiques à la livraison validée. Pas de nouvelle exécution des tests.
APK normal installé : `0.1.0-graphics014` (64), SHA-256
`b6f76cc9754ad40ff2813894904d475e60bc780c774378b640694e835d37a68e`.
Gambits conservés octet pour octet ; gel de la pause vérifié sur le téléphone.
Laboratoire A/B/C exporté séparément, non installé sur Android.
Clôture par commit et sauvegarde complète restaurée/vérifiée.
Prochain GO : UI-005, qualification intégrée Android, puis STEP-029/030.
Aucun push automatique. Les états précédents ci-dessous sont historiques.

# GRAPHICS-014 — Énergie d’incantation — en recette

GRAPHICS-013 clôturée : `b497548d283849af42aa821a52ed9a51711eb095`.
Le 29 octobre 2026, ajout d’un fin contour bleu sur la silhouette des héros pendant
l’incantation et de huit particules flottantes attirées vers le lanceur. Choix validé
dans le laboratoire Godot : B — Équilibré (intensité 0,65). Fin immédiate à la résolution,
à l’annulation, à la mort ou à la fin du combat ; aucun effet pendant la récupération.
Présentation seule : aucun changement de ciblage, coûts, durées ou états de combat.
63 bancs / 4 215 contrôles réussis, dont 24 sur le cycle de vie de cette présentation.
APK normal `0.1.0-graphics014` (64) ; laboratoire séparé exporté. APK installé sur Galaxy A16, gambits inchangés et gel de la pause vérifiés.
Validation complète de l’étape attendue avant commit et sauvegarde de clôture.
Prochain GO après clôture : UI-005, qualification intégrée Android, puis STEP-029/030.
Les états précédents ci-dessous sont historiques.

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

# GRAPHICS-013 — Icônes Discret et colonne de buffs — en recette

Le propriétaire a retenu A — Discret, puis demandé la suppression des portraits des
panneaux de combat et des buffs empilés verticalement en haut à gauche. Padding hérité
du panneau : 14 px à gauche, 8 px en haut. Icônes d'incantation 16 px au bord droit fixe
de la barre ; buffs actifs 14 px dans l'ancien espace du portrait. Panneaux conservés
à 106 px, bloc terminé à y=292 et compteur à y=300, avant décalage de zone sûre.
Fiches : icônes 40 px ; gambits et menus : 16 px. Les trois PNG fournis restent intacts.
Catalogue et ressource de style séparés de la logique ; aucun changement de combat.

62 bancs / 4 191 contrôles réussis, dont 67 spécifiques. Aperçus GPU et recette Galaxy
A16 réalisés ; APK normal réinstallé, gambits conservés octet pour octet.
APK normal `0.1.0-graphics013` (62), SHA-256
`545af3b45c59d234df5fe12b10ae181133fd031cfc4497fa7e3d1233b26173c4`.
Étape en attente de validation utilisateur avant commit/sauvegarde de clôture.
Après clôture : UI-005, qualification intégrée Android, puis STEP-029/030.
Les états précédents ci-dessous sont historiques.

# MODE-INFINI-001 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour le premier mode Infini : vagues de six,
attente de trois secondes, compteur, départs sud-ouest/nord-est et nouveau décor aux
vagues 11, 21, 31… avec conservation des héros et de leurs états.
Les 61 bancs / 4 124 contrôles et la recette Godot/Galaxy A16 avaient déjà réussi.
Clôture documentaire uniquement : code, scènes, profils, configuration et les deux APK
restent identiques à la livraison validée. Pas de nouvelle exécution des tests.
APK normal installé : `0.1.0-infinite001` (61), SHA-256
`7b4346c28e9b056f0f3cbaf0e32925e571f8f5ac99fcc964f9ada82071c5afcd`.
Gambits conservés. Clôture par commit et sauvegarde complète restaurée/vérifiée.
Prochain GO : UI-005, qualification intégrée Android incluant le mode Infini, puis
STEP-029/030. Aucun push automatique. Les états précédents ci-dessous sont historiques.

# MODE-INFINI-001 — Premier mode Infini — en recette

Après FIX-COMBAT-001 clôturée (`7d8530d`), le bouton d'accueil « Mode Infini » ouvre
le seul mode produit disponible. Vagues simultanées de six squelettes, sans limite de
vagues ni victoire automatique ; défaite lorsque tous les héros sont morts, ou abandon
confirmé. Héros au sud-ouest au départ, ennemis au nord-est. La vague suivante apparaît
après trois secondes de combat, uniquement après élimination complète de la précédente.
Compte à rebours central or à bordure bleue, compteur sous les quatre panneaux héros.
L'arène initiale est aléatoire puis change pour une autre aux vagues 11, 21, 31…
Aucune réinitialisation des héros entre vagues/décors : PV, mana, buffs, positions,
actions et recharges continuent normalement ; pause et arrière-plan figent le délai.
Les laboratoires et anciens modes techniques gardent leurs contrats historiques.

61 bancs / 4 124 contrôles réussis, dont 70 pour ce mode. Aperçus GPU et recette
Galaxy A16 effectués ; APK normal remis, gambits conservés octet pour octet.
APK `0.1.0-infinite001` (61), SHA-256
`7b4346c28e9b056f0f3cbaf0e32925e571f8f5ac99fcc964f9ada82071c5afcd`.
Validation utilisateur attendue avant commit/sauvegarde. Prochaine étape après clôture :
UI-005, qualification Android incluant le mode Infini, puis STEP-029/030.
Les états précédents ci-dessous sont historiques.

# FIX-COMBAT-001 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour le reciblage après annulation d'une
incantation et les squelettes sans mana ni barre bleue. Les 60 bancs / 4 054 contrôles
et les 24 contrôles natifs sur Galaxy A16 avaient déjà réussi ; gambits conservés.
Clôture documentaire uniquement : code, scènes, profils, shader, configuration et
les deux APK restent identiques à la livraison validée. Pas de nouvelle exécution des tests.
APK normal installé : `0.1.0-fix-combat001` (60), SHA-256
`934a920feb9a906756f2325e5c56ec47c987229497edf5135fa35094271fb824`.
Clôture par commit et sauvegarde complète restaurée/vérifiée. Prochain GO : UI-005,
qualification intégrée Android, puis STEP-029/030. Aucun push automatique.
Les états précédents ci-dessous sont historiques.

# FIX-COMBAT-001 — Annulation et squelettes sans mana — en recette

Correctif demandé après GRAPHICS-012 clôturée (`ea1a3e4`). Une incantation interrompue
avant sa résolution libère désormais sa recharge : le prochain pas de combat peut
sélectionner une nouvelle cible et relancer le sort, sans débit de mana ni récupération
résiduelle. Les recharges des autres capacités et celles des sorts déjà résolus restent
intactes, y compris lorsque l'impact tue sa propre cible. Cadence des sorts réussis conservée.
Les squelettes ont 0 mana et 0 régénération ; leur barre bleue disparaît. Les héros
conservent leurs ressources et le rendu GRAPHICS-012. Le laboratoire des néons respecte
également ces caractéristiques réelles.

60 bancs / 4 054 contrôles réussis, dont 24 nouveaux contrôles de régression. Les 24
contrôles passent aussi sur Galaxy A16 ; combat, rendu et gel de la pause vérifiés.
Gambits enregistrés identiques octet pour octet. APK normal corrigé installé :
`0.1.0-fix-combat001` (60), SHA-256
`934a920feb9a906756f2325e5c56ec47c987229497edf5135fa35094271fb824`.
Étape en attente de validation utilisateur, avant commit/sauvegarde. UI-005 reste ensuite
prévue pour la qualification intégrée Android, puis STEP-029/030.
Détails et recette : [FIX-COMBAT-001](docs/steps/FIX-COMBAT-001.md).
Les états précédents ci-dessous sont historiques.

# GRAPHICS-012 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour les panneaux héros enrichis : textes
blancs PV/mana et sort/temps restant, PV/mana en dix segments, incantation continue,
portions vides renforcées. Panneaux Lumineux et barres flottantes B conservées.
59 bancs / 4 030 contrôles et recette tactile Galaxy A16 déjà réussis. Seuls les documents
sont actualisés pour cette clôture : code, scènes, profils, shader, configuration et
les deux APK restent identiques à la livraison validée. Les tests ne sont pas relancés.
Gambits conservés ; affichage et compte à rebours vérifiés, APK normal remis sur le Galaxy.
APK normal 0.1.0-graphics012 (59), SHA-256
`9aaa8c30283c291c8c7d8ca53fb68156b810bfe997dc83a3fc4be869dfe7d858`.
APK laboratoire 0.1.0-graphics012-lab (59), SHA-256
`5c43e9ed890ac77d61d6863a5c59719f505a485d5899614a7d946973a298e525`.
Clôture par commit unique et sauvegarde restaurée/vérifiée. Prochain GO : UI-005,
qualification intégrée Android, puis STEP-029/030.
Les états précédents ci-dessous sont historiques.

# GRAPHICS-012 — Textes et segments des panneaux héros — en recette

Demande du propriétaire après GRAPHICS-011 clôturée (`fdf9f6e3e5086861794bf1d546e4abcaee1e6f76`,
766 fichiers vérifiés). Rendu Godot ajusté puis approuvé : panneaux en néon Lumineux,
barres flottantes conservées en B. Textes blancs PV actuels / maximums, mana actuelle /
maximum et nom du sort / secondes restantes. Espacement augmenté sans chevauchement.
PV et mana divisés en dix segments, fractions conservées ; incantation continue.
Les portions vides gardent la teinte de la barre, assombrie mais nettement visible.
Longueurs inchangées. Aucune modification des valeurs ou de la logique de combat.

59 bancs / 4 030 contrôles réussis sans erreur ni avertissement moteur, dont 29 nouveaux
contrôles des textes, valeurs, espacement, styles et compte à rebours avec Booster.
Aperçus GPU et recette native Galaxy A16 dans la livraison. Aucun nouveau benchmark FPS.
APK normal 0.1.0-graphics012 (59), SHA-256
`9aaa8c30283c291c8c7d8ca53fb68156b810bfe997dc83a3fc4be869dfe7d858`.
APK laboratoire 0.1.0-graphics012-lab (59), SHA-256
`5c43e9ed890ac77d61d6863a5c59719f505a485d5899614a7d946973a298e525`.
F6 : `scenes/debug/neon_bars_lab.tscn` pour l'instantané et le combat avec ce rendu.
Détails : [GRAPHICS-012](docs/steps/GRAPHICS-012.md). L'accord Godot concerne le rendu ;
validation finale de l'étape attendue avant commit et sauvegarde de clôture.
Après clôture et prochain GO : UI-005, puis STEP-029/030. Les états précédents sont historiques.

# GRAPHICS-011 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » après le choix B — Fin et lisible : barres
néon fines, largeur monde 42 → 29,4 (−30 %), panneaux à longueur inchangée avec un trait
légèrement plus épais. Profil visuel commun et glow discret, sans scintillement.
58 bancs / 4 001 contrôles et recette tactile Galaxy A16 déjà réussis. Seuls les documents
sont actualisés pour cette clôture : code, scènes, ressources, shader, configuration et
les deux APK restent identiques à la livraison validée. Les tests ne sont pas relancés.
Gambits conservés ; rendu clair/sombre et combat vérifiés sur le Galaxy, APK normal remis.
APK normal 0.1.0-graphics011 (58), SHA-256
`937951eb510873159c201e43eed516e4dc88d59793e914e32c23b06bc571f887`.
APK essais 0.1.0-graphics011-lab (58), SHA-256
`8ead02ad9e147bd7afe99d5845e53f3f56bc3076dab76459b3196fb10c4d8e49`.
Clôture par commit unique et sauvegarde restaurée/vérifiée. Prochain GO : UI-005,
qualification intégrée Android, puis STEP-029/030.
Les états précédents ci-dessous sont historiques.

# GRAPHICS-011 — Barres néon fines — en recette

Demande directe du propriétaire après GRAPHICS-010 clôturée (`eec1310a599051e5391740efcedd733c575e3078`,
756 fichiers vérifiés). Nouvelle étape visuelle avant UI-005. Le propriétaire choisit
B — Fin et lisible parmi les trois essais Godot ; ce choix ne vaut pas encore clôture.
Barres au-dessus de tous les héros et ennemis : longueur 42 → 29,4 (−30 %), trait de
1,25 au lieu de 3,5. Panneaux : même rendu, trait de 1,9 au lieu de 5, longueur inchangée.
PV rouges, mana bleue et incantation dorée facultative, léger glow local sans scintillement.
Profil visuel commun, sans modification des valeurs, de la logique ou du HUD hors combat.

58 bancs / 4 001 contrôles existants réussis sans erreur ni avertissement moteur.
Captures GPU A/B/C sur arènes claire et sombre : quatre barres de monde à 29,4 et deux
panneaux conservant leur largeur de 171 sur le viewport 540×960. Aucun nœud orphelin.
Recette Android et preuves dans la livraison ; aucun nouveau benchmark FPS.
APK normal 0.1.0-graphics011 (58), SHA-256
`937951eb510873159c201e43eed516e4dc88d59793e914e32c23b06bc571f887`.
APK laboratoire 0.1.0-graphics011-lab (58), SHA-256
`8ead02ad9e147bd7afe99d5845e53f3f56bc3076dab76459b3196fb10c4d8e49`.
F6 : `scenes/debug/neon_bars_lab.tscn` pour comparer A/B/C, arène claire/sombre et combat.
Détails : [GRAPHICS-011](docs/steps/GRAPHICS-011.md). Validation utilisateur attendue avant
commit et sauvegarde de clôture. Prochain GO après clôture : UI-005, puis STEP-029/030.
Les descriptions précédentes ci-dessous sont historiques.

# GRAPHICS-010 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » après le choix B — Équilibré : montre dorée
procédurale translucide de 2 s, aiguilles accélérées, suivi de cible et fondu partagé.
Le soin garde son rendu et sa durée de 1 s ; la logique des buffs reste inchangée.
58 bancs / 4 001 contrôles et recette tactile Galaxy A16 déjà réussis. Seuls les documents
sont actualisés pour cette clôture : code, scènes, ressources, configuration et deux APK
restent identiques à la livraison validée. Les tests moteur ne sont pas relancés.
Gambits du téléphone conservés ; réglage B vérifié sur le Galaxy et APK normal remis.
APK normal 0.1.0-graphics010 (57), SHA-256
`593592a564cd8b5b2493875f799c4aed43aed77cd039395ad65c43eff2c4417d`.
APK essais 0.1.0-graphics010-lab (57), SHA-256
`2f52538443d4f35d2a61c4ea01c1451522edc170d79a00116a14aa0032975eb9`.
Clôture par commit unique et sauvegarde restaurée/vérifiée. Prochain GO : UI-005,
qualification intégrée Android, puis STEP-029/030.
Les états précédents ci-dessous sont historiques.

# GRAPHICS-010 — Montre Booster et fondu partagé — en recette

GO reçu après BUFFS-002 clôturée `1d2d66a8a3e6356ae4867b0e1727776bb1b28d27`
(sauvegarde restaurée, 738 fichiers vérifiés). Montre dorée procédurale translucide,
deux aiguilles accélérant rapidement, durée de 2 s et fondu commun avec le soin.
Le propriétaire choisit B — Équilibré dans le laboratoire A/B/C. Ce choix de rendu
ne constitue pas encore la validation de clôture de GRAPHICS-010.

La montre suit la cible et regarde la caméra ; elle apparaît uniquement sur un fait réel
buff_applied réussi. Doublons, annulations, décès, disparition, pause et reset sont gérés.
Les matériaux sont privés et le nombre d'effets borné. Le soin garde sa durée de 1 s,
son intensité et ses anneaux : seule sa formule d'opacité est extraite, à résultat identique.
Aucune logique de buff, de mana, de ciblage ou de temps personnel n'est modifiée.
58 bancs / 4 001 contrôles réussis sans erreur ni avertissement moteur ; 152 contrôles
dédiés au fondu et à la montre. Aperçus GPU PC et recette Android dans la livraison.
Aucun nouveau benchmark FPS. Les gambits enregistrés restent conservés.
APK normal 0.1.0-graphics010 (57), SHA-256
`593592a564cd8b5b2493875f799c4aed43aed77cd039395ad65c43eff2c4417d`.
APK laboratoire 0.1.0-graphics010-lab (57), SHA-256
`2f52538443d4f35d2a61c4ea01c1451522edc170d79a00116a14aa0032975eb9`.
F6 : `scenes/debug/booster_watch_lab.tscn` pour les essais visuels A/B/C, ou
`scenes/debug/booster_lab.tscn` pour les vrais gambits Mako → Anne avec la montre.
Détails : [GRAPHICS-010](docs/steps/GRAPHICS-010.md). Validation attendue avant commit et
sauvegarde de clôture. Prochain GO après clôture : UI-005, qualification intégrée Android,
puis STEP-029/030. Les descriptions précédentes sont historiques.

# BUFFS-002 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour Booster dans les compétences et les
Gambits de Mako : 20 mana, cast 1,5 s, ×1,30 pendant 60 s de combat normal, aucune
recharge dédiée, sans cumul ni renouvellement. Allié cible Mako puis Anne en ignorant
les porteurs du même buff ; mana insuffisante → gambit suivant. Débit au succès réel.
57 bancs / 3 849 contrôles et recette tactile Galaxy A16 déjà réussis. Seuls les documents
sont actualisés pour cette clôture : code, scènes, profils, configuration, assets et APK
restent identiques à la livraison validée. Aucun nouveau test moteur nécessaire.
Gambits du téléphone conservés ; laboratoire isolé disponible pour la séquence complète.
APK normal 0.1.0-buffs002 (56), SHA-256
`a53bc49cf29fc2f7e16a2331619055740863f56990c39f0b3a574302d9933ce5`.
APK laboratoire 0.1.0-buffs002-lab (56), SHA-256
`df954bbd424f0354d7a0396b7c7a697c42624173c5565360522cbb2ca5e9766f`.
Clôture par commit unique et sauvegarde restaurée/vérifiée. Prochain GO : GRAPHICS-010,
montre dorée procédurale et fondu partagé avec le soin, puis UI-005.
Les états précédents ci-dessous sont historiques.

# BUFFS-002 — Booster jouable via les gambits — en recette

GO reçu après clôture de BUFFS-001 `eac9a39eb14c040dde5d3fc4a3477809d8a4829b`
(sauvegarde restaurée, 727 fichiers vérifiés). Mako possède Attaque, Foudre et Booster ;
Anne conserve Attaque et Soin. Booster : 20 mana, cast 1,5 s, portée 4, récupération
habituelle et aucune recharge dédiée, ×1,30 pendant 60 s de combat normal.
Les critères classent les cibles ; le buff écarte celles qui portent déjà Booster, même
si elles sont ennemies. Toute indisponibilité ou mana insuffisante fait passer au gambit
suivant. Débit uniquement à la résolution réussie, jamais sur une annulation ou un doublon.

57 bancs / 3 849 contrôles réussis sans erreur ni avertissement moteur, dont 118 contrôles
dédiés à Booster. Aperçu GPU PC piloté : Duck, Mako puis Anne, 40 mana dépensés, fiche et
contrôles libérés sans nœud orphelin. Recette Android et preuves dans la livraison.
Aucun nouveau benchmark FPS. Pas de modification automatique des gambits sauvegardés.
APK normal 0.1.0-buffs002 (56), SHA-256
`a53bc49cf29fc2f7e16a2331619055740863f56990c39f0b3a574302d9933ce5`.
APK laboratoire 0.1.0-buffs002-lab (56), SHA-256
`df954bbd424f0354d7a0396b7c7a697c42624173c5565360522cbb2ca5e9766f`.
F6 : `scenes/debug/booster_lab.tscn` ; le preset isolé place Allié → Booster avant les
anciens ordres et journalise les vraies applications. Le jeu normal conserve les ordres
existants ; programmer Booster depuis la fiche de Mako. Détails :
[BUFFS-002](docs/steps/BUFFS-002.md). Validation utilisateur attendue avant commit et
sauvegarde de clôture. Prochain GO après clôture : GRAPHICS-010, montre dorée procédurale
et fondu partagé avec le soin ; puis UI-005. Les états précédents sont historiques.

# BUFFS-001 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour le socle des buffs et du temps personnel.
Attaques, incantations, récupération, recharges, déplacements et modèles utilisent le
pas propre à chaque acteur ; mana, durée des buffs et effets autonomes gardent le temps
normal. Laboratoire isolé conservé ; aucune nouvelle compétence dans le jeu à cette étape.
56 bancs / 3 719 contrôles et recette tactile Galaxy A16 déjà réussis. Seuls les documents
sont actualisés pour la clôture, sans relancer les tests : code, scènes, configuration,
assets et APK demeurent identiques à la livraison validée. Gambits Android conservés.
APK normal 0.1.0-buffs001 (55), SHA-256
`5a13e0b27641d448bd6a5ce7ffd4e3a54fe432cea0693a80f8c97c39c09c0851`.
APK laboratoire 0.1.0-buffs001-lab (55), SHA-256
`5efb3f08aeaf0cc3a314b08e2ab30ab6256173b2d5021a54e1c184e0af880d78`.
Clôture par commit unique et sauvegarde restaurée/vérifiée. Prochain GO : BUFFS-002,
Booster dans les compétences de Mako et les gambits, puis GRAPHICS-010 et UI-005.
Les états précédents ci-dessous sont historiques.

# BUFFS-001 — États de buffs et temps personnel — en recette

GO reçu après clôture de GAMBITS-003 `6b527253c086861f8d8108e75498487169230817`
(sauvegarde restaurée, 716 fichiers vérifiés). Buffs de combat séparés des définitions,
horloge propre à chaque participant, expiration sur le temps normal du combat.
Attaques, incantations, récupération, recharges, déplacement et animations suivent
le temps personnel ; mana, vagues, collisions et VFX autonomes gardent leur temps normal.
Aucun buff appliqué par défaut dans le jeu, aucune nouvelle compétence à cette étape.
Booster jouable et son filtrage des cibles appartiennent à BUFFS-002 ; montre à GRAPHICS-010.

56 bancs / 3 719 contrôles réussis sans erreur ni avertissement moteur, dont 75 nouveaux.
Aperçu GPU PC piloté et recette tactile Galaxy A16 : comparaison des casts, mana,
pause figée et reprise explicite au retour d'arrière-plan. Aucun benchmark FPS.
APK normal 0.1.0-buffs001 (55), SHA-256
`5a13e0b27641d448bd6a5ce7ffd4e3a54fe432cea0693a80f8c97c39c09c0851`.
APK laboratoire 0.1.0-buffs001-lab (55), SHA-256
`5efb3f08aeaf0cc3a314b08e2ab30ab6256173b2d5021a54e1c184e0af880d78`.
L'APK normal est remis sur le téléphone, gambits d'origine identiques octet pour octet.
F6 : `scenes/debug/personal_time_lab.tscn` ; recette et architecture détaillées dans
[BUFFS-001](docs/steps/BUFFS-001.md). Étape en attente de validation avant commit et
sauvegarde de clôture. Prochain GO après clôture : BUFFS-002, puis GRAPHICS-010 et UI-005.
Les descriptions précédentes ci-dessous sont historiques.

# GAMBITS-003 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » : critère Allié sans condition, ordre
Mako puis Anne parmi les vivants, lanceur compris, et candidats classés préparés
pour les buffs. Catalogue de onze critères, sauvegarde v3 immédiate conservée.
Résultats de la recette précédente : 55 bancs / 3 644 contrôles réussis et recette
tactile Android ; réglages d'origine restaurés. Aucun nouveau test moteur pour
cette clôture documentaire, aucune modification du code ou de la configuration.
APK validé : 0.1.0-gambits003 (54), SHA-256
`cbe4b7c0b65b9f305aab866c1d563b40f900b1a3902088d24294e3cfa5a086a5`.
Les fichiers temporaires de livraison et l'APK local de la recette précédente ne
sont plus disponibles ; leur empreinte ci-dessus est celle consignée à la livraison.
La clôture sauvegarde les sources et l'historique Git, sans recréer cet APK.
Prochain GO : BUFFS-001 (états de buffs et horloge personnelle), puis BUFFS-002,
GRAPHICS-010 et UI-005. Les descriptions antérieures ci-dessous sont historiques.

# GAMBITS-003 — Critère Allié et ordre d'équipe — en recette

Roadmap Allié / Booster validée par le GO du propriétaire. Première étape implémentée :
critère « Allié » sans condition, candidats ordonnés et rang d'équipe explicite. Mako précède
Anne, y compris si Anne est le lanceur. L'ordre de traitement Anne puis Mako ne change pas.
Catalogue de onze critères ; sauvegarde immédiate v3 et défaut Ennemi proche conservés.
55 bancs / 3 644 contrôles réussis sans erreur ni avertissement moteur ; captures GPU PC
et recette Android dans la livraison. Aucun nouveau benchmark FPS.
APK 0.1.0-gambits003 (54), SHA-256 `cbe4b7c0b65b9f305aab866c1d563b40f900b1a3902088d24294e3cfa5a086a5`.
Base clôturée : ARENA-001 `15bf1f5cc21c1334491f3fa43e2cc04edd9f30bc` (706 fichiers vérifiés).
Le plan préparé après cette clôture est inclus dans la livraison de GAMBITS-003.
Étape en attente de validation, commit et sauvegarde vérifiée. Prochain GO : BUFFS-001,
puis BUFFS-002, GRAPHICS-010, UI-005 et STEP-029/030. Booster et l'horloge personnelle
ne sont pas encore implémentés. Les états précédents ci-dessous sont historiques.

# ARENA-001 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour l'arène épurée : Pause, quatre panneaux
passifs Mako / Anne / Vide / Vide, portraits et barres, suppression des anciennes commandes
et de la sélection. Menu Reprendre / Rejouer / Abandonner, confirmation avant l'accueil.
APK 0.1.0-arena001 (53), SHA-256
`08b675affdafd61effb941737381e0458792705796807bf64978b1f921651293`.
Seuls les documents sont actualisés ; code, scènes, assets, configuration et APK restent
identiques à la livraison validée. Les 54 bancs / 3 592 contrôles déjà réussis ne sont pas
relancés. Recette tactile Android réussie, pause visuellement figée et gambits inchangés.
Clôture par commit unique et sauvegarde restaurée/vérifiée. Prochain GO : UI-005,
qualification intégrée prolongée Android, puis STEP-029/030. GAMEPLAY-003 reste annulée.
Les états précédents ci-dessous sont historiques.

# ARENA-001 — Arène épurée et menu Pause — en recette

GO reçu pour retirer les commandes et informations de combat, sauf Pause et quatre panneaux
passifs en haut. Grille Mako / Anne puis Vide / Vide, portraits fixes et barres PV rouges,
mana bleue et incantation dorée lorsqu'un sort est en cours. Barres au-dessus des acteurs
conservées, pastille jaune de sélection supprimée. Bas de l'écran dégagé.
Pause suspend le combat et propose Reprendre, Rejouer, Abandonner ; l'abandon exige une
confirmation avant l'accueil. Retour Android ouvre Pause, puis revient d'abord au menu
si une confirmation est affichée. Les gambits se programment depuis la fiche hors combat.
54 bancs / 3 592 contrôles réussis sans erreur ni avertissement moteur ; recette GPU PC et
native Android dans la livraison. Aucune nouvelle mesure FPS.
APK 0.1.0-arena001 (53), SHA-256 `08b675affdafd61effb941737381e0458792705796807bf64978b1f921651293`.
Base validée : HOME-001 `5d08abec22a8513c10447a6d5ec5b5233e76d7e8`, sauvegarde restaurée
et vérifiée (696 fichiers). ARENA-001 attend validation avant commit et sauvegarde de clôture.
Après clôture et prochain GO : UI-005, qualification intégrée, puis STEP-029/030.
Les états précédents ci-dessous sont historiques.

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

# GRAPHICS-004 — animations d'action et priorités en recette

Mort > attaque/sort > déplacement > HitReact > Idle. Sword frappe au moment logique,
Duck accompagne Soin/Foudre, et les morts terminent leur geste hors du combat.
F6 : [galerie des actions](scenes/debug/action_lab.tscn), C pour Duck ; F8 puis F5 : Main.
[Recette / APK actif code 35](docs/steps/GRAPHICS-004.md), [contrat visuel](docs/combat-presentation.md).
34 bancs / 2 154 contrôles passent. Les effets de soin/Foudre suivent dans GRAPHICS-005/006.

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

# GAMEPLAY-001 — équipe et incantations en recette

Anne et Mako combattent ensemble : Anne soigne un allié, Mako lance Foudre. Chaque héros a
ses compétences et trois gambits. Vie rouge, mana bleu, incantation jaune or au-dessus de
tous les acteurs ; Soin 1,5 s, Foudre 2 s. Sélection du héros dans le HUD, reprise explicite.
F6 : [équipe](scenes/party/party_application.tscn), puis F8/F5 : partie complète.
[Recette et APK](docs/steps/GAMEPLAY-001.md), [paramètres et architecture](docs/party-gameplay.md).
31 bancs / 1 921 contrôles passent ; APK installé sur Galaxy A16. Équilibrage provisoire.
Les anciennes compositions ci-dessous restent accessibles comme bancs de référence.

# GRAPHICS-003 — recette disponible

Anne, Mako et les deux squelettes pirates sont intégrés avec repos et marche.
Main utilise Anne et le squelette avec crâne. F6 : [galerie des personnages](scenes/debug/character_lab.tscn),
F8 puis F5 : combat. [Recette et APK](docs/steps/GRAPHICS-003.md),
[modifier une apparence](docs/character-presentation.md).
28 bancs / 1 803 contrôles passent. APK GRAPHICS-003 installé sur Galaxy A16.
L'équipe Anne/Mako, les nouvelles compétences, les barres et incantations sont prévues
ensuite dans [GAMEPLAY-001](docs/party-skills-plan.md). Étape en attente de validation.

# Gambit Arena

Prototype Godot Android portrait : héros autonome piloté par trois gambits, commandes
manuelles de compétences, trois vagues, pause et redémarrage. Personnages 3D procéduraux
sur arène dimétrique ; assets et équilibrage encore provisoires.

**STEP-028 est clôturée — 580ce64, poussée et sauvegarde vérifiée.**
La [roadmap graphique validée](docs/graphics-roadmap.md) prévoit des arènes interchangeables,
des personnages 3D et les animations d'attaque, de soin et de Foudre, avant STEP-029/030.
GRAPHICS-001 est validée, commit local f5a790d et sauvegarde vérifiée.
GRAPHICS-002 est validée : huit arènes sélectionnables via **GAMBIT / Mesures → Choisir
l'arène**, également disponibles dans la [galerie indépendante](scenes/debug/graphics_lab.tscn).
Le choix conserve la partie en pause ; Reprendre est explicite.
Base de travail : HANDOFF-001, cc91c79, main publiée sur GitHub et vérifiée le 26 octobre.
STEP-028 ajoute une collecte de performance bornée et un protocole Android. Les mesures Debug
n'atteignent pas l'ancien seuil de 30 FPS, mais les performances ont été explicitement acceptées
pour le périmètre prévu ; la fixture de 20 ennemis est un stress test. Voir
[les mesures](docs/performance.md).

## Reprendre le projet

Commencer par [HANDOFF.md](HANDOFF.md), puis [PROJECT_STATUS.md](PROJECT_STATUS.md).
La passation contient les décisions, l’architecture, l’historique, la méthode de travail,
les tests, les commandes GitHub et un prompt prêt à transmettre à une autre IA.

## Lancer

Environnement documenté : Godot 4.7.2 standard, rendu Compatibility, référence 540 × 960,
Android portrait. Importer project.godot avec les templates correspondant à la version
installée. F5 lance Main/ArenaApplicationLab, qui étend PerformanceLab puis ApplicationLab.
Le bouton GAMBIT / Mesures ouvre les diagnostics ; hors capture, le combat reste ordinaire.
Les scènes sous scenes/tests se lancent avec F6,
puis F8 entre bancs. Voir [les tests](docs/handoff/TESTING.md) et [Android](docs/android.md).

Version GRAPHICS-002 : 0.1.0-graphics002, code 30 ; sortie Android Debug :
../gambit-arena-builds/graphics-002-debug.apk. APK de référence mesuré pour STEP-028 :
`d2c710ef6fb1c935eb6afecbfe54e98b1a03d0a03266753c5c8b537cce1a23b9`.
Pour STEP-027, F6, tests manuels et fluidité ont été confirmés par l’utilisateur.
Pour STEP-028, voir les [résultats et limites](docs/steps/STEP-028.md) : l'utilisateur a
validé F6, F5, tactile Android et pause/reprise ; le commit reste en attente.

## Documentation

- [Architecture](ARCHITECTURE.md) et [décisions à préserver](docs/handoff/STATE_AND_DECISIONS.md).
- [Roadmap complète](ROADMAP.md) et [étapes restantes](docs/handoff/NEXT_STEPS.md).
- [Méthode de livraison](docs/handoff/DEVELOPMENT_GUIDE.md).
- [Historique](docs/handoff/HISTORY.md), [sauvegardes](docs/backup.md).
- [Commit/push/restauration](docs/handoff/GITHUB.md).
- [Assets et provenance](docs/assets.md).
- [Présentation des arènes et remplacement du fond](docs/arena-presentation.md).

STEP-028 clôturée ; GRAPHICS-002 validée, commit autorisé ; GRAPHICS-003 attend les modèles 3D.
STEP-029 : reproductibilité clone/export ; STEP-030 : recette finale.
La licence publique globale reste à choisir par le propriétaire.
