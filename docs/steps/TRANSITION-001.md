# TRANSITION-001 — Prototype personnages 3D / fond 2D

## Statut et dépendance

Validée, commit en attente. Base STEP-005 clôturée :
44f81d5597e061d47df59cf376908a71d1a904cb. Sauvegarde reçue et vérifiée.
Décision utilisateur DEC-001 et GO reçus. Jalon inséré avant STEP-006.
Livraison : gambit-arena-complet-transition-001-v1.tar.gz. Aucun nouveau commit.

## Objectif

Vérifier le raccord entre personnages 3D et sol 2D dimétrique, leur profondeur,
l’occultation par un élément 2D, le fonctionnement tactile et le rendu sur A16.
Prendre une première mesure indicative avec vingt mannequins simples.
Le prototype doit éclairer la prochaine production d’assets, pas la remplacer.

## Livré

Deux mannequins 3D procéduraux et dix-huit copies pour le test de charge ; fond
2D en damier ; caméra orthographique fixe 2:1 ; décor 2D vertical à alpha découpé.
Un seul SubViewport transparent, six boutons, pause et contrôle projection/inverse.
Version Android 0.1.0-transition001 code 4. Les anciens laboratoires sont conservés.

Nouveaux fichiers : scenes/hybrid/hybrid_lab.tscn, scripts/hybrid/*.gd,
assets/hybrid/occluder.svg, docs/hybrid-rendering.md et cette fiche.
Scène principale, preset et documentation actualisés. Aucun modèle externe requis.

## Appliquer

Fermer Godot et vérifier un dépôt propre au commit 44f81d5 :

```bash
cd ~/gambit-arena
git status --short --branch
git log -1 --format="%h %s"
```

En cas de modifications inattendues, les signaler avant extraction. Sinon :

```bash
tar -xzf ~/Downloads/gambit-arena-complet-transition-001-v1.tar.gz -C ~
cd ~/gambit-arena
git diff --check
git status --short --branch
```

Ne pas réinitialiser Git. Importer dans Godot ; conserver les nouvelles
métadonnées .gd.uid et .svg.import générées, sans ajouter .godot/.

## Commandes

Mode/M : Croisement, Décor 2D, Charge 20. Échelle/S : 48,64,80.
Pause/Espace : suspend/reprend. Repartir/R : cycle et mesures à zéro, conserve pause.
Repères/G : grille, axes et croix. Marche/W : pose animée ou debout.
Marche ne supprime pas le trajet ; la pose debout qui glisse est volontaire.

## Recette Godot

1. F5 : en-tête TRANSITION-001, damier 2D visible sous deux mannequins 3D colorés.
   Aucun rectangle opaque ne doit masquer le damier, aucune erreur du débogueur.
2. Projection affiche 2.000:1 et erreur <= 0,001. Observer les pieds avec Repères,
   Marche désactivée, aux échelles 48/64/80 : les racines restent sur le sol.
3. Croisement : observer deux cycles de huit secondes. Les volumes passent devant
   puis derrière suivant leur position. Aucun ordre global y_sort n’est attendu.
4. Décor 2D : le cyan passe derrière le panneau puis devant. Les parties nettement
   derrière sont cachées quand elles sont couvertes par ses pixels opaques.
   Le contour transparent ne doit pas masquer un rectangle autour du panneau.
   À la traversée exacte, le corps peut couper le plan : intersection volontaire.
5. Pause fige positions et pose ; Repartir ne quitte pas la pause. Une pression
   sur un bouton correspond à une action. Vérifier les six touches équivalentes.
6. Charge 20 : vingt mannequins visibles au total, qui se déplacent sur deux cercles.
   Pas de fuite apparente ni erreur lors de dix changements successifs de mode.
7. Perte de focus puis retour : pause conservée. F8 arrête correctement.
8. Ancien animation_lab.tscn lancé avec F6 : fonctionnement historique conservé.

En cas d’erreur, transmettre le texte avant export Android. Les compilations et
le rendu Godot ne peuvent pas être testés dans l’environnement de l’assistant.

## Recette Galaxy A16

Exporter puis installer selon docs/android.md. Relever SHA-256 et vérifier
l’en-tête TRANSITION-001. Refaire les tests visuels de projection, ancrage,
croisement et panneau aux trois échelles, en commençant par 48.
Vérifier les six boutons, le texte hors encoche/navigation et la pause après
accueil dix secondes, puis verrouillage/déverrouillage. Retour = reprise explicite.

Pour un premier relevé comparable :

1. Rester en Charge 20, échelle 48, marche active, pendant une minute.
2. Appuyer sur Repartir, laisser tourner sans toucher ni changer de fenêtre deux minutes.
3. Noter moyenne FPS, pire image (ms), durée de mesure, saccades et chauffe ressentie.
4. Noter si le téléphone est en charge et si un mode économie d’énergie est actif.
5. Fournir une capture en mode Décor 2D et une capture du relevé si possible.

Les métriques sont indicatives, basées sur delta et les frames traitées ; elles
ne constituent pas un profil GPU ni la qualification du futur jeu avec combat.
L’objectif provisoire de 30 FPS soutenus reste à vérifier sur une charge représentative.
Le test de vingt mannequins au total n’équivaut pas à vingt ennemis plus un héros.

## Critères de validation

Fond 2D et volumes 3D composés correctement ; projection/inverse cohérentes ;
ancrages stables ; occultation correcte hors intersection ; tactile et pause OK ;
APK lancé sans erreur bloquante sur A16. Lisibilité et taille préférée requalifiées.
Relevé de cadence documenté pour décider de la suite, sans inventer de budget GPU.

## Vérifications de préparation et limites

Références, scènes, ancrages, calculs mathématiques et archive contrôlés.
Godot absent : pas de compilation, rendu, export ni essai matériel ici.
Pas de modèles riggés, d’Attack/Hit/Death 3D, de collisions, d’ombres sur le fond,
de combat ou de gambits. Les cartes verticales ne règlent pas tous les futurs
cas de décors ; voir docs/hybrid-rendering.md. Portrait du téléphone ciblé.
Pas de persistance après destruction du processus Android.

## Résultats

Validation explicite utilisateur reçue le 22 octobre 2026.
- Damier 2D sous les mannequins : OK.
- Projection 2.000:1, erreur < 0,001 : OK.
- Ancrages et profondeur entre personnages : OK.
- Passage derrière/devant le décor 2D : OK.
- Boutons, pause et F8 : OK ; validation globale de l’étape reçue.
- Taille préférée en 3D : 48 px de référence.
- Relevé utilisateur : moyenne 60 FPS, pire image 16,7 ms, aucune saccade.
- Installation ADB : Success sur Galaxy A16 Android 16.
- SHA-256 APK : 124654de74db47ac162a9f925d7f4f3844aa7504a316f43a559c4a3d86635f10.

Ces mesures concernent le diagnostic livré et sont rapportées par l’utilisateur.
Elles ne qualifient pas les futurs modèles riggés, animations, combat ou effets.
Durée exacte du relevé, charge batterie/secteur et économie d’énergie non précisées
séparément dans le retour ; aucun profil GPU ni capture n’a été transmis.

## Clôture

Après validation, recevoir l’archive documentaire complète puis commiter :
feat: [TRANSITION-001] prototyper les personnages 3D sur fond 2D.
Inclure les nouvelles métadonnées Godot, confirmer le hash et le statut propre,
exécuter bash tools/create_backup.sh et transmettre l’archive. Ne pas démarrer
STEP-006 ou produire des modèles définitifs avant le prochain cadrage et GO.

## Livraison de validation

Archive : gambit-arena-complet-transition-001-validation.tar.gz.
Seule la documentation évolue depuis la v1 testée ; aucun code fonctionnel modifié.
Le bundle fourni reste celui de la base 44f81d5 jusqu’au prochain commit confirmé.
Les métadonnées nouvelles générées localement par Godot seront incluses dans
le commit et la sauvegarde utilisateur. Aucun hash de clôture n’est inventé.

## Clôture effective

Commit confirmé : 056a464b82869529b844571827b1aa01788bc2a6 ; main propre.
L’APK et son .idsig présents à la racine ont été déplacés hors du dépôt avant
la sauvegarde. Archive reçue : gambit-arena-20261022-154651-056a464b8286.tar.gz.
Bundle cloné et 59 fichiers suivis comparés avec succès. Cette clôture remplace
les mentions historiques « commit en attente » ci-dessus.
