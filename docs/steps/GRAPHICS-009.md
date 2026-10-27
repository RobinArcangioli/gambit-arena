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

# GRAPHICS-009 — soin vert fluo à deux anneaux

Demande du 27 octobre 2026 : glow vert fluo et deux cercles blanc/vert clair translucides,
concentriques, de tailles différentes, tournant sur eux-mêmes selon deux axes distincts.
Animation brève d'une seconde, terminée dans un fondu.

Base GRAPHICS-008 clôturée : e6885c698041b3f89cf5a734bc858e1f97cf07c3,
parent d3ff7df9125bf3acd9511b6c10d51a4a531739f7. Sauvegarde
`gambit-arena-20261027-015553-e6885c698041.tar.gz`, SHA-256
66b4eb9f33f3df7a1a6ce27320ffae19b31b9ca77dfce927c3aefa83792f2d4c,
restaurée/vérifiée : 580 fichiers conformes, arbres propres, clone et fsck valides.
Travail isolé : /tmp/gambit-graphics009-work-o4tjsqfe.

## Réalisation

Gyroscope à deux anneaux de cœur translucides et coques de glow additif. Centres identiques,
à hauteur de corps, rayons 0,62 / 0,4464, axes distincts et sens opposés. Lueur verte diffuse
orientée vers la caméra. Durée 1,0 s : attaque visuelle douce sur 0,06 s, fondu à partir de
0,36 s, transparence complète à 1,0 s, y compris le contour du nombre soigné. Le +PV réel
est conservé, les anciens quatre « + » décoratifs retirés. Voir ../heal-presentation.md.

Configuration exclusivement artistique : scène/profil, couleurs, rayons, hauteur, axes,
nombres de tours et durée. Ni bloom global ni lumière dynamique requis ; shader compatible
avec le rendu Android Compatibility. Aucun Timer/Tween ni temps autonome dans le shader.
Le présentateur existant fournit la position de la vraie cible et le temps accepté.

Règles et présentateur inchangés : soin effectif, coût, incantation 1,5 s, annulation, cible,
mouvement, navigation, compétences et priorités d'animation identiques à la base.
GAMEPLAY-003 reste annulée. Les gabarits, modèles et ombres de GRAPHICS-008 sont conservés.

## Vérifications

Godot 4.7.2.stable.official.ed1daf0bf / Compatibility.
41 bancs / 2 574 contrôles réussis, aucune erreur/avertissement moteur dans la campagne finale.
Les 40 bancs / 2 541 contrôles antérieurs passent. 33 contrôles supplémentaires : durée,
rotations réellement visibles, axes distincts, rayons emboîtés, centrage au fil de l'animation,
transparence intermédiaire/finale des anneaux/glow/texte/contour, gel du temps, style et nettoyage.
Les tests de soin existants conservent les parcours auto/manuels, soi/allié, échecs et pause.

Inspection GPU PC : 24 captures (Anne/Mako, deux fonds clair/sombre, six instants), plus
un aperçu animé de 31 images à 30 Hz et pause de lecture entre les répétitions. Ces images
montrent le graphisme échantillonné ; ce ne sont pas de nouvelles mesures de performance.
Zéro orphelin à la fermeture des galeries. Import et exports finaux vérifiés séparément.

## Android et APK

Aperçu décoratif natif exporté dans une copie temporaire, code 42 / 0.1.0-graphics009-lab,
SHA-256 0d98acd6f220375fb642d11a78c43f42d15e355e56072d8eba0a78434dc9aa3c.
Il fige le visuel vers 0,3 seconde sur Anne et affiche un exemple +30, sans changer les PV
ni la mana. Capture native et rapport de centrage/axes conservés ; inspection du glow en
Compatibility sur Galaxy A16. Cet aperçu n'est pas un soin réel ni une mesure FPS.
Le script de cet export et la capture sont joints à la livraison pour reproduction.

APK normal /tmp/graphics-009-debug.apk, 0.1.0-graphics009 (43), 37 501 831 octets,
SHA-256 fc84f63d53b40a9246b3d7466a32833026545ef8c4968b668fbe16881be16fc9.
Installé en mise à jour, lancé et version vérifiée par ADB sur Galaxy A16. Le point d'entrée
reste Main ; la partie est laissée en pause pour la recette du vrai soin par l'utilisateur.
Aucune nouvelle mesure de performance ni campagne exhaustive des huit fonds sur Android.

## État

En recette, sans commit/push. Après validation/clôture : STEP-029 puis STEP-030.
