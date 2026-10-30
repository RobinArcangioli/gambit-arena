# LOGO-001 — Icône Beherit et démarrage de l’application

## État

Base STYLE-002 `557cb52`, demande du 30 octobre 2026.
Le propriétaire retient ses deux illustrations et précise :
« Icône et démarrage uniquement ». L’accueil garde son illustration et son titre.
Aperçu Godot, import et capture GPU vérifiés ; ressources réelles de l’APK inspectées.
APK v92 installé et validé sur Galaxy A16 : « Oui, LOGO-001 validée ». Fond noir pur
confirmé sur la capture de lancement et dans les ressources natives de l’APK.
Gambits, équipe, réglages et style conservés, vérifiés par empreinte. Clôture
documentaire uniquement : code et APK inchangés ; commit local et sauvegarde
complète restaurée/vérifiée. Aucun push automatique.

## Intégration

Les deux originaux 1254 × 1254 sont copiés sans modification dans assets/art/branding.
Le carré est préparé en192 pour l’icône de projet et l’icône Android classique.
La version ronde est préparée en288 et centrée dans le calque transparent432 ; un
calque de fond noir #000000 complète l’icône adaptative. Le dessin et ses couleurs
sont conservés ; seules les dimensions de livraison et marges sont adaptées.

Le démarrage système Android utilise le même logo. Le second écran de démarrage
Godot est désactivé sur Android pour conserver le démarrage système jusqu’au jeu.
Sur PC, un PNG rond320 centré sur fond noir remplace l’image Godot par défaut.
Aucun délai artificiel ajouté. Identifiant Android et nom de l’application inchangés.

Aucune modification des pages, du thème, de la navigation ni du combat. Les données
d’équipe, de gambits, de réglages et de préférence de style doivent être conservées.
Les fichiers préexistants non suivis dans output/ sont laissés intacts et ne font pas
partie du changement ; leurs empreintes sont conservées séparément pendant le travail.

## Vérifications

Préparation déterministe dans Godot : tools/prepare_branding.gd.
F6 : scenes/debug/branding_lab.tscn présente les sources carrée/ronde, petits formats
et une représentation du démarrage, sans donnée joueur ni nouveau combat.
81 contrôles existants de navigation réussis ; aucune nouvelle suite miroir pour des
paramètres graphiques et des fichiers PNG. Le gameplay n’a pas été modifié.
Les ressources réelles de l’APK sont inspectées après export :192 classique,432 pour
les calques adaptatifs, alpha de l’avant-plan limité à la région centrale288.
Le manifeste et l’icône adaptative pointent sur ces ressources personnalisées.
La version monochrome facultative n’est pas activée.

Références : documentation officielle Godot, export Android et ProjectSettings
(https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html ;
https://docs.godotengine.org/en/stable/classes/class_projectsettings.html).

Icône vérifiée dans la fiche système Android ; logo observé au lancement sur fond
noir RGB(0,0,0), puis accueil habituel. Validation du propriétaire obtenue après
correction du fond gris initial. Aucun nouveau relevé de performances.

## Fond noir système Android

Retour du propriétaire : fond de lancement noir pur, pas gris.
L’option de couleur du démarrage n’étant appliquée qu’en export Gradle,
`tools/prepare_android_branding.py` prépare une copie locale des templates officiels
Godot 4.7.2 dans `.godot/branding/`. Deux valeurs existantes de thème sont fixées à
ARGB `#ff000000` : fond de SplashScreen AndroidX et fond natif Android31+.
Aucune disposition de ressources, permission ou bibliothèque native n’est modifiée.
Les templates installés d’origine restent intacts et Godot effectue la signature.
Le script vérifie les rôles et leur occurrence avant de produire debug/release ;
un template incompatible provoque un arrêt explicite.

Avant le premier export Android après un clonage ou une suppression de `.godot`,
exécuter `python3 tools/prepare_android_branding.py`. Les paramètres `--templates`
et `--aapt2` permettent d’utiliser d’autres emplacements d’installation. Les fichiers
de template générés sont du cache et ne sont pas versionnés. F5/F6 ne les nécessitent pas.
Le fond de l’icône et le fond de démarrage PC sont également noir pur.

## APK validé

- logo-001-debug.apk (v92) : `891dc0f02273a7cda70d2b094a5f502a3f293294f7f8603582c9766538ccb103`
