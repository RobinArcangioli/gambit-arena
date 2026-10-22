# État du projet

## Référence confirmée

STEP-005 clôturée : 44f81d5597e061d47df59cf376908a71d1a904cb, branche main propre.
Message : feat: [STEP-005] ajouter les acteurs temporaires animes.
Sauvegarde reçue : gambit-arena-20261022-152338-44f81d5597e0.tar.gz.
Bundle cloné : HEAD exact confirmé ; 48 fichiers identiques aux sources archivées.
Historique disponible : RECOVERY-001, STEP-004 et STEP-005.
Les nouveaux .svg.import et .gd.uid reçus sont conservés.

STEP-005 a été validée par l’utilisateur : croisements, actions et boutons OK.
APK testé : 86459ba2a752ecd83e7d179d637a40f9c950b14293ebad88914b94fbdfe8d652.
Nouvelle direction confirmée : personnages 3D sur fond 2D isométrique.

## TRANSITION-001 — Validée, commit en attente

GO reçu après la sauvegarde STEP-005. Livraison complète :
gambit-arena-complet-transition-001-validation.tar.gz.
Version fonctionnelle testée : gambit-arena-complet-transition-001-v1.tar.gz.
Aucun commit TRANSITION-001. Base 44f81d5 inchangée dans le bundle fourni.

Prototype livré : sol dessiné en 2D, mannequins 3D dans un SubViewport transparent,
caméra orthographique fixe, repérage 2:1, décor 2D participant à la profondeur.
Trois modes : croisement, décor 2D, charge de 20 mannequins au total.
Commandes tactiles, échelles comparatives 48/64/80, pause et reprise explicite.
APK prévu : 0.1.0-transition001, code 4, même identifiant de paquet.

## Vérifications et limites

L’assistant contrôle les références, les calculs de projection et l’archive.
Godot n’est pas disponible ici : aucune compilation, exécution, image du rendu
Godot, mesure matérielle ni export de cette transition n’a été réalisé.
Le 22 octobre 2026, l’utilisateur valide aussi ce nouveau rendu hybride sur son poste
et son téléphone : damier, projection, ancrages, profondeur, décor et commandes OK.
Les mannequins sont des primitives avec marche procédurale, pas les futurs
modèles riggés et cinq animations. Aucun combat, collision ou IA n’est ajouté.

## Prochaine action

Appliquer la livraison de validation, vérifier le diff préparé et commiter
TRANSITION-001. Confirmer le hash réel et le dépôt propre, puis exécuter
bash tools/create_backup.sh et transmettre l’archive complète.
STEP-006 attend cette clôture et un nouveau GO ; la production des assets 3D
sera cadrée en fonction du résultat du prototype, sans être présumée acquise.

## Résultats reçus

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
