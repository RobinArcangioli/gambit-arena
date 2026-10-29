# ARENA-004 validée — 29 octobre 2026

Le propriétaire confirme sur Galaxy A16 : « Oui, step validée » pour les dégâts
flottants blancs sur les ennemis, rouges sur les héros et les soins verts inchangés.
Animation commune du soin, trois options indépendantes et mémorisées, encart compact
« Textes flottants » avec fond noir à 25 % d’opacité. Le combat continue dans les réglages.
Les 66 scènes / 4 501 contrôles et la recette Android avaient déjà réussi ; les deux
bancs initialement en dépassement de délai ont réussi leur relance isolée.
Clôture documentaire uniquement : code, ressources, configuration et APK identiques
à la livraison validée. Aucune nouvelle exécution des tests ni mesure de performances.
APK installé : `0.1.0-arena004-layout` (74), SHA-256
`8f4231a9e1b35767b1be019b622516014db95068272c0f2043310abccf8a1d2a`.
Gambits conservés octet pour octet ; préférences initiales rétablies après la recette.
Clôture par commit et sauvegarde complète restaurée/vérifiée. Aucun push automatique.
Prochain GO : UI-005, qualification intégrée Android, puis STEP-029/030.
Les états précédents ci-dessous sont historiques.

# ARENA-004 — Dégâts et soins flottants

Statut : en recette, validation utilisateur attendue.
Base ARENA-003 : `6799b58dc47381601dc4dafbf16bfeb243dafeae`.

## Affichage

Chaque impact réussi affiche les PV réellement perdus, sans surplus : nombre blanc
au-dessus d’un ennemi, rouge #e44949 au-dessus d’un héros. Le camp de la cible détermine
la couleur, y compris si un gambit vise exceptionnellement un allié. Les soins gardent
leur vert #b8ffcc et le préfixe +. Un résultat nul n’ajoute pas de nombre de dégâts.

Les trois catégories utilisent le même composant passif, extrait du nombre de soin
existant : durée 1 s, montée de 0,24 unité, hauteur de référence 1,55, police 48,
pixel_size 0,006, contour 5 et ressource common_fade.tres. Le nombre et son contour
atteignent tous deux une opacité nulle. Les anneaux et le glow de soin sont conservés.
Leurs valeurs restent des paramètres de présentation, indépendants de la simulation.
Les temps visuels acceptés gèlent les textes en pause et en arrière-plan.

Les impacts successifs sur une même cible ont un léger décalage pour les distinguer.
Les nombres suivent la position graphique tant que la cible existe ; un coup fatal
termine son animation au dernier emplacement, même si l’ennemi quitte la simulation.
Les événements sont dédoublonnés par combat/source/séquence. Nouveau combat, replay ou
désactivation du présentateur nettoient les textes. Le plafond de 48 nombres de dégâts
simultanés borne les rafales extrêmes ; les huit acteurs ordinaires restent dans ce
budget. Aucun impact supplémentaire ni coût de compétence n’est produit par l’affichage.

## Réglages

Sous les deux options de barres existantes, l’encart « Textes flottants » a un fond
noir à 25 % d’opacité (RGBA 0 / 0 / 0 / 0,25), coins arrondis et padding
8 px. Les trois cases sont rapprochées : hauteur 32 px et séparation 2 px. Leur titre
reste or et leur style de cases reprend celui des options existantes.

Dégâts infligés = nombres sur les ennemis ; Dégâts reçus = nombres sur les héros ;
Soins = nombres verts. Les trois options sont actives par défaut et indépendantes.
Le choix prend effet et est enregistré immédiatement, sans Appliquer/Annuler.
Masquer Soins masque seulement le nombre : les anneaux et le glow restent visibles.
Le réglage des barres flottantes est également indépendant de celui des nombres.

Les nouvelles clés damage_dealt_text, damage_received_text et healing_text sont dans
la section floating_text de user://combat_settings.cfg. Les anciennes préférences de
barres sont conservées ; clés absentes ou types invalides reviennent à true. Les
choix survivent au replay, au nouveau combat et au relancement de l’application.
Aucune modification du fichier de gambits. Les labels déjà actifs deviennent cachés
ou visibles selon leur catégorie, sans réafficher d’anciens impacts expirés.

Le menu continue de laisser combattre. Sur petit portrait, ses options défilent au
doigt, tandis que le titre et OK restent disponibles ; il reste dans le rectangle
central et ne déborde pas sur les panneaux héros. Les gestes annulés, glissements et
copies souris ne doivent pas cocher une option. Retour et cycle de vie restent inchangés.

## Vérification

66 scènes / 4 501 contrôles réussis, dont 50 nouveaux contrôles : couleurs, quantités,
parité de l’animation avec le soin, gel du temps, fondu, coup fatal, doublons, limite,
reset et absence d’orphelins ; cases indépendantes et sauvegarde immédiate, ancien
fichier, types invalides, replay et retour accueil. Injection tactile avec copie souris,
scroll et swipe sans cocher sur 540×960 et 360×640. Les 65 bancs antérieurs restent
réussis, dont ceux du soin, des réglages, de la pause, du journal et des combats.
Deux bancs ont dépassé le délai pendant une exécution concurrente de l’export et des
aperçus ; relance isolée avant livraison. Journaux initiaux et résultats de relance
sont conservés dans la vérification. Aucune mesure FPS ou gain de performances annoncé.

Rendu GPU contrôlé ; APK installé sur Galaxy A16, options testées et préférences
initiales rétablies. Empreinte installée, conservation des gambits et recette Android
consignées dans la livraison complète. Validation visuelle du propriétaire attendue.
Laboratoire F6 isolé : scenes/debug/floating_text_lab.tscn (ne lit/écrit pas les
préférences ni gambits du joueur). F5 et scènes historiques conservent leurs entrées.

## Livraison

APK : arena-004-layout-debug.apk, version 0.1.0-arena004-layout (74).
SHA-256 : `8f4231a9e1b35767b1be019b622516014db95068272c0f2043310abccf8a1d2a`.
Sources complètes sans .git/.godot, APK, vérification, bundle d’historique de base et
notice dans une archive restaurée/vérifiée. Aucun fichier privé du joueur livré.
Validation attendue avant commit et sauvegarde de clôture ; aucun push automatique.
