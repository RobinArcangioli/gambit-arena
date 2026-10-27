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

# GRAPHICS-012 — Textes, segments et contraste des panneaux héros

Statut : rendu Godot approuvé après ajustement ; étape en recette avant clôture.
Base : GRAPHICS-011 `fdf9f6e3e5086861794bf1d546e4abcaee1e6f76`, sauvegarde vérifiée de 766 fichiers.
Nouvelle demande directement autorisée par le propriétaire ; cette étape précède UI-005.

## Résultat livré

Chaque panneau de héros en arène affiche en blanc :

- PV : « 130 / 180 », valeurs actuelles et maximums de l'acteur.
- Mana : « 36 / 60 », mana actuelle entière et capacité réelle. La fraction régénérée reste
  dans le modèle ; l'affichage entier utilise le plancher pour ne pas annoncer un coût disponible trop tôt.
- Incantation : « Booster : 0,8s », nom français du sort et secondes réellement restantes.
  Le texte et la barre disparaissent dès la résolution, l'annulation ou la fin du cast.

Les textes sont placés au-dessus des traits néon, avec une ombre discrète pour leur lisibilité.
Panneaux de 106 au lieu de 76 de hauteur, pas vertical 114 au lieu de 84 dans la grille 2×2.
Les valeurs de ligne sont espacées d'environ 20 unités de viewport, sans chevauchement.
Longueur des barres et placement horizontal inchangés ; slots Vide sans faux compteurs.
Police 11 sur le viewport 540, réduite à 9 sur les panneaux étroits, sans capter le tactile.

Choix final explicite du propriétaire : style Lumineux seulement dans les panneaux ; les
barres au-dessus des modèles restent B — Fin et lisible, sans textes ni segmentation.
Panneaux : cœur 2,2, glow force 0,30 / rayon 1,15. Monde : cœur 1,25, force 0,22 / rayon 1,
largeur 29,4 comme dans GRAPHICS-011. Aucune augmentation globale du glow.

PV et mana sont divisés en dix segments de 10 %. Le remplissage reste proportionnel au
ratio exact, avec un segment partiel si nécessaire : aucun arrondi de la vie ou de la mana.
Séparateurs de 1,2 unité de viewport. La barre d'incantation reste continue, conformément
à l'ajustement demandé par le propriétaire. Les zones vides des trois barres emploient
leur propre teinte assombrie (facteur 0,40, opacité 0,92), plus visible que le fond neutre.
La valeur pleine reste nettement plus lumineuse ; le noir n'est plus le seul indicateur de perte.

## Compte à rebours

Les panneaux lisent la durée de référence et la progression réelle de l'exécuteur. Le temps
restant affiché est en secondes de combat : il tient compte du taux personnel de Booster,
y compris de son expiration éventuelle avant la fin du cast. La fonction passive
remaining_cast_seconds inverse les portions de temps à partir d'un instantané de valeurs
copiées, sans faire avancer ou modifier le buff, le sort ou sa cible.

Exemples pour 1,5 s personnelles restantes : 1,5 s sans buff ; environ 1,154 s avec Booster
durable ; 1,35 s si Booster expire après 0,5 s de combat. Affichage arrondi au dixième supérieur
pour éviter d'annoncer zéro avant la libération du sort, virgule décimale française.
Soin, Foudre et Booster ont leurs noms de présentation ; le temps est figé en pause.
Le remplissage jaune continue de suivre la progression réelle du cast, sans segmentation.

## Séparation des responsabilités

HeroStatusPanel ajoute uniquement les labels et la lecture des valeurs de l'acteur. Le
shader de barres applique la segmentation aux lignes PV/mana des panneaux seulement et
compose correctement les couleurs avec transparence. OverheadBars transmet les paramètres
visuels par instance. Le profil commun distingue explicitement le glow des panneaux et
du monde, permettant ce mélange sans changer les barres flottantes.

Le layout d'ArenaPage adapte la hauteur et l'espacement des cartes. Les quatre panneaux,
portraits, bouton Pause et parcours restent en place. Aucune commande de combat supplémentaire.
Exécuteurs, coûts, mana, stats, ciblage, animations, buffs et navigation sont identiques à
la base validée. Les sauvegardes de gambits et l'UID de Main sont conservés.

## Aperçu et validation Godot

Le propriétaire demande un aperçu rapide. Après un premier rendu, il demande davantage de
contraste, les panneaux Lumineux en gardant le monde B, et une incantation non segmentée.
Le nouvel aperçu est ouvert et il répond « Oui, ce rendu me convient ».
Cette réponse approuve le rendu ; la validation finale de l'étape reste attendue après livraison.

F6 `scenes/debug/neon_bars_lab.tscn`, F8 depuis l'éditeur : instantané de démonstration avec
PV/mana partiels et casts en cours. Clair / sombre compare le contraste ; Animer / figer
montre les textes et barres évoluer dans le vrai combat puis rétablit la fixture.
Le laboratoire utilise des données et un chemin utilisateur isolés ; aucun réglage du joueur
n'est réécrit. Les capacités temporaires de squelettes de la fixture n'entrent pas dans les profils du jeu.
Export isolé : `python3 tools/export_neon_bars_lab.py --godot <binaire> --output <chemin.apk>`.

## Vérifications

59 bancs / 4 030 contrôles réussis, zéro erreur/avertissement moteur. Le nouveau banc
`scenes/tests/hero_status_labels_tests.tscn` comporte 29 contrôles : textes réels blancs,
PV/mana, nom et temps, styles distincts, largeurs conservées, espacement, disparition à
l'annulation, compte à rebours accéléré et expiration pendant le cast, lecture sans débit
ni progression de l'action, nettoyage sans nœud orphelin. Les 58 bancs précédents passent.
Captures GPU du rendu final sur arènes claire et sombre ; aucun benchmark FPS supplémentaire.
Sur le Galaxy, les textes et segments sont vérifiés en vue figée, sur arène claire puis
en combat réel (Foudre et temps restant, mana conservée pendant le cast). La pause tactile
est figée et le retour au premier plan garde la pause. APK normal remis, deux empreintes
installées vérifiées et gambits d'origine identiques octet pour octet. Rapports et captures
joints à la livraison complète.

APK normal 0.1.0-graphics012 (59), SHA-256 :
`9aaa8c30283c291c8c7d8ca53fb68156b810bfe997dc83a3fc4be869dfe7d858`.
APK laboratoire 0.1.0-graphics012-lab (59), SHA-256 :
`5c43e9ed890ac77d61d6863a5c59719f505a485d5899614a7d946973a298e525`.
Après validation globale : commit unique et sauvegarde restaurée/vérifiée, puis GO UI-005.
