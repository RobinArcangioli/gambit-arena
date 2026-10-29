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

# ARENA-002 — Réglages de combat et décors sans grille

Statut : en recette, validation utilisateur attendue.
Base GRAPHICS-014 clôturée : `62cc34bfc23249b96c5e1cc38684dabc9e8326e0`.

## Comportement produit

Zone tactile de 48 × 48 px avec un unique engrenage de 30 px : contour or,
intérieur bleu nuit #10182f et extérieur transparent. Aucun fond ou cadre autour du
bouton, y compris au focus. Il reste dans le coin supérieur droit du rectangle central
de combat, sans marge supplémentaire à droite, distinct de Pause. Infobulle « Réglages de combat ». Titre du menu en or #ffd16a, comme le compteur. Le menu est un panneau bleu nuit à opacité
0,72, bordure or, rayon 8 px et marges communes aux panneaux héros. Largeur plafonnée
à 304 px, placé sous le bouton puis contenu dans la zone centrale sur petits formats.
Pas de voile global ni de pause : combat, buffs, incantations et vagues continuent.

Deux cases : « Afficher les barres des héros » et « Afficher les barres des ennemis »,
sous-texte PV / PM / Incantation. Toutes deux actives par défaut. Chaque groupe est
indépendant ; masquer un groupe affecte uniquement ses barres flottantes. Les quatre
panneaux bas et leurs barres ne sont pas affectés. Les ennemis sans mana restent sans
barre de mana, conformément à leurs caractéristiques.
Leurs valeurs continuent d’être mises à jour quand les barres flottantes sont masquées.
OK, centré et ajusté au texte (minimum 56 × 44 px, padding hérité 14/8 px), ferme le menu sans modifier l’état de pause. Retour Android ferme d’abord le menu.
Le bouton Pause peut fermer les réglages et ouvrir sa pause habituelle. Une mise en
arrière-plan ferme le menu et maintient les protections de reprise explicite existantes.

Le compteur affiche uniquement « Vague N », dans une police agrandie de 17 à 22 px.
La défaite reste annoncée dans le menu de pause, sans préfixe ou suffixe sur ce compteur.

## Données et séparation

`combat_settings.gd` conserve les booléens `hero_bars` et `enemy_bars` dans le ConfigFile
`user://combat_settings.cfg`. Une case cochée/décochée produit un effet immédiat et une
sauvegarde immédiate, sans commande Appliquer/Annuler. Aucun changement des gambits.
Valeur absente, fichier absent/invalide ou type non booléen : valeur par défaut true.
Les préférences survivent à Rejouer, à un retour accueil et à un nouveau lancement.
L’ancienne clé de grille des APK d’essai est ignorée, puis disparaît à l’écriture.

`app_root.gd` fournit le chemin persistant ; les laboratoires et bancs d’ArenaPage
utilisent un chemin vide ou leur fichier isolé. `combat_settings_menu.gd` émet seulement
les changements et la fermeture ; `arena_page.gd` adapte la visibilité des vues.
Aucun coût, état d’acteur, ciblage, mouvement, horloge ou contrat de simulation modifié.

## Arènes

À la demande finale, le réglage de grille est retiré entièrement. Les huit PNG aux
chemins existants et leurs miniatures sont remplacés par des variantes sans lignes
blanches tactiques. Les joints naturels restent. Pas de deuxième version du décor
chargée ni de bascule de texture en combat. Les originaux fournis sont récupérables
dans les sauvegardes et l’historique Git antérieurs.

Retouche par outil intégré image_gen.imagegen, compétence imagegen, puis normalisation
ImageMagick au canevas 540 × 960 sans recadrage et miniatures 108 × 192 via l’outil du
dépôt. Consignes exactes, noms des sorties et SHA : `assets/art/arenas/generation.json` ;
provenance dans `assets/art/arenas/PROVENANCE.md`. De petites différences de texture dues
à la reconstruction peuvent exister. Les coordonnées de sol et caméra restent celles
des scènes calibrées. Les outils historiques de calibration restent techniques et
ne constituent pas une option du produit ; aucune grille n’est dessinée dans l’arène.

## Vérification

- 64 bancs / 4 321 contrôles réussis, dont 104 spécifiques, zéro erreur ou warning moteur.
- Tactile réel injecté avec sa copie souris sur 540×960, 540×1170 et 360×640 : un seul
  changement par tap, engrenage sans texte, panneau contenu dans la zone centrale.
- Combat qui continue menu ouvert, masques héros/ennemis indépendants et panneaux conservés,
  écriture immédiate, conservation sur replay/nouveau combat, retour, arrière-plan,
  reprise explicite, types invalides et absence d’orphelins.
- Chaque fond chargé correspond au SHA de la variante propre et conserve 540×960 ;
  les bancs existants de calibration, navigation, combat et infini sont conservés.
- Recette Android et empreinte installée enregistrées dans la livraison complète.
  Gambits préservés octet pour octet. Validation utilisateur de l’étape attendue.

## APK

`arena-002-layout-debug.apk`, version `0.1.0-arena002-layout` (66).
SHA-256 : `4e3f7734f3135fa32210e318b0dcb46efdaa66854626512c082f8b39364a5ef8`.
Une seule version normale livrée ; aucune variante de laboratoire Android nécessaire.
Le SHA d’archive complète est distinct de celui de l’APK.
