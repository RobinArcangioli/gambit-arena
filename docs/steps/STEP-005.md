# STEP-005 — Deux acteurs temporaires et animations

## Statut

Phase 3 : Assets. Validée, commit en attente.
Base : 491cde8ecc276dac6728e06a579e3788ab423dda (STEP-004 clôturée).
Feu vert utilisateur reçu. Taille retenue : 48 px de référence.
Livraison : gambit-arena-complet-step-005-v1.tar.gz. Aucun commit STEP-005.

## Objectif et périmètre

Deux acteurs lisibles, chacun avec Idle, Move, Attack, Hit et Death dans
quatre directions temporaires. Vérifier ancrage au sol, séquences, arrêt des
animations ponctuelles, tri et lisibilité sur téléphone. Documenter provenance,
conditions d'utilisation, import et coût brut des textures.
Pas de combat, déplacement de héros, collision, IA ou système de PV.

## Décisions et fichiers

Deux SVG vectoriels originaux, générateur Python standard reproductible,
cellules 80 × 80, ancrage (40,68), corps debout proche de 48 px.
Quatre images par animation ; détails des lignes, FPS et boucles dans docs/assets.md.

Nouveaux : assets/actors/ (deux atlas et provenance), scenes/actors/ (deux scènes),
scripts/actors/actor_visual.gd, scenes/debug/animation_lab.tscn,
scripts/debug/animation_lab.gd, tools/generate_actor_atlases.py et cette fiche.
Modifiés : scène principale, version du preset Android, documents de suivi.
Ancien laboratoire, projections et assets de diagnostic conservés.

## Appliquer

Fermer Godot. Vérifier un dépôt propre sur main au commit 491cde8 :

```bash
cd ~/gambit-arena
git status --short --branch
git log -1 --format="%h %s"
```

Si des modifications inattendues existent, les signaler avant l'extraction.
Sinon :

```bash
tar -xzf ~/Downloads/gambit-arena-complet-step-005-v1.tar.gz -C ~
cd ~/gambit-arena
git diff --check
git status --short --branch
```

Ne pas réinitialiser Git. Ouvrir Godot et attendre la fin de l'import.
Les nouveaux .gd.uid et .svg.import générés doivent être conservés pour le commit.
Les fichiers fonctionnels sont déjà livrés ; ne pas recopier la documentation.

## Recette Linux

1. F5 ouvre STEP-005 : héros cyan et ennemi rouge à taille 48 px, pas d'erreur.
2. Idle respire en boucle ; Move alterne les jambes en boucle sans déplacer les
   racines lorsque Croisement est désactivé. Les croix restent aux pieds.
3. Parcourir chaque état avec État et chaque direction avec Direction : vingt
   combinaisons, visibles simultanément sur les deux acteurs. Distinguer face/dos.
4. Attack montre préparation, extension de l'arme et retour ; Hit montre le recul ;
   Death s'affaisse puis reste au sol. Ces trois états jouent une fois, sans boucle.
5. Rejouer relance une animation terminée. Changer de direction ou d'état repart
   à l'image 1. Aucune arme ni silhouette coupée au bord d'une cellule.
6. Pause fige les deux animations. Image suivante avance d'une image et reste
   en pause ; quatre pressions reviennent à la même image. Rejouer en pause
   revient à l'image 1. Reprendre reprend la lecture si elle n'était pas terminée ;
   sur une animation terminée, utiliser Rejouer pour lancer un nouveau cycle.
7. Croisement active deux trajets opposés : observer au moins deux cycles de huit
   secondes, en Move puis Attack/Death. Le tri suit les croix, pas le haut du sprite.
   Une pose de mort qui se déplace ici est volontaire : diagnostic, pas gameplay.
8. Vérifier les touches A/D/Espace/R/C/N et l'absence de doubles actions.
9. Changer de fenêtre puis revenir : pause conservée. F8 arrête sans erreur.
10. Ouvrir l'ancienne scène projection_lab.tscn et F6 : son diagnostic fonctionne
    encore. F5 revient au nouveau laboratoire.

En cas d'erreur d'import ou GDScript, transmettre le texte et ne pas exporter.

## Android

Exporter un APK Debug avec le même preset et la signature locale, vers
~/gambit-arena-builds/step-005-debug.apk ; version 0.1.0-step005, code 3.
Procédure et commandes : docs/android.md, section STEP-005.
Après installation Success, relever le SHA-256 et ouvrir l'application.

1. Vérifier l'en-tête STEP-005, les six boutons et les textes hors encoche/navigation.
2. Parcourir les cinq états et quatre directions sur les deux acteurs à taille réelle.
3. Confirmer que héros/ennemi, face/dos et les cinq états sont reconnaissables à 48 px.
4. Tester chaque bouton au toucher : une pression = une action. Vérifier pause,
   image par image, fin de Death, Rejouer et croisements sans décalage des ancrages.
5. Accueil Android dix secondes puis retour, et verrouillage/déverrouillage :
   reprise uniquement sur commande. Pas de progression pendant la pause.
6. Observer deux minutes : pas de fermeture ni saccade bloquante. Les FPS
   instantanés restent un indicateur, sans qualification de performance en combat.
7. Transmettre résultats, SHA-256 et, si possible, capture d'une pose lisible.

## Acceptation

Import et lancement sans erreur ; deux acteurs distincts ; vingt combinaisons
par acteur présentes ; boucles et poses finales correctes ; origines stables ;
tri correct ; boutons utilisables ; lisibilité à 48 px confirmée sur Galaxy A16.
Provenance et contrat des assets documentés. Validation explicite requise.

## Vérifications de préparation

SVG générés puis rendus avec librsvg pour inspection visuelle hors Godot.
Dimensions, contenu des cellules, marges et références locales contrôlés.
Source Python déterministe ; archive complète et bundle de base vérifiés.
Godot absent : aucun import, test GDScript, lancement ou export exécuté ici.
Les assertions statiques ne remplacent pas la recette utilisateur.

## Limites

Assets de travail à quatre images : transitions simples, aucun art final.
Miroir gauche/droite assumé ; directions visuelles choisies manuellement.
Les animations ne pilotent jamais le combat. La mort n'est qu'une pose visuelle.
Portrait et Galaxy A16 ciblés ; paysage et petites fenêtres non qualifiés.
Aucune persistance après destruction du processus ; relance = état initial.
La mémoire brute calculée n'est pas une mesure sur appareil.

## Résultats

Le 22 octobre 2026, l’utilisateur confirme : « Tout est OK. Les croisements,
les actions et les boutons fonctionnent correctement. Je valide cette step. »
Validation globale reçue ; aucun relevé de FPS ni capture détaillée transmis.
Téléphone autorisé en état device ; installation ADB : Success.
APK testé : step-005-debug.apk. SHA-256 :

```text
86459ba2a752ecd83e7d179d637a40f9c950b14293ebad88914b94fbdfe8d652
```

La même demande décide le passage aux personnages 3D sur fond 2D isométrique.
Cette validation concerne le laboratoire 2D livré, pas une implémentation 3D.
Le repère 48 px reste historique ; la lisibilité du rendu 3D sera requalifiée.

## Clôture après validation

L'assistant fournit une archive complète de validation avec les résultats réels.
Message proposé : feat: [STEP-005] ajouter les acteurs temporaires animes.
Inclure les nouveaux scripts, scènes, SVG et métadonnées générées à l'import,
ainsi que la documentation. Confirmer le hash et le dépôt propre, puis lancer
bash tools/create_backup.sh et transmettre l’archive. Le prochain GO ouvrira
TRANSITION-001 avant STEP-006, conformément à la nouvelle direction utilisateur.

## Références officielles

- https://docs.godotengine.org/en/4.7/classes/class_animatedsprite2d.html
- https://docs.godotengine.org/en/4.7/classes/class_spriteframes.html

## Clôture effective

Commit confirmé : 44f81d5597e061d47df59cf376908a71d1a904cb, main propre.
Sauvegarde reçue : gambit-arena-20261022-152338-44f81d5597e0.tar.gz.
Bundle cloné et sources comparées : 48 fichiers identiques.
Cette clôture remplace les mentions historiques « commit en attente » de la fiche.
