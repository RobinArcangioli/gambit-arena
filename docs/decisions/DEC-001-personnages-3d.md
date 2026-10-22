# DEC-001 — Personnages 3D sur fond 2D isométrique

Date : 22 octobre 2026. Direction produit décidée explicitement par l’utilisateur.

## Décision

Le jeu utilisera des personnages 3D se déplaçant sur un fond 2D isométrique.
Les personnages en sprites ne sont plus la cible de production. Android portrait,
le Galaxy A16, le déplacement automatique, le combat et les gambits restent
les objectifs du MVP. Aucun déplacement manuel n’est ajouté par cette décision.

## État réel

STEP-005 est validée pour son laboratoire de sprites, mais n’est pas encore
commitée. Cette livraison de validation ne change aucun code fonctionnel.
Les scènes 2D sont conservées comme référence reproductible. Il n’existe encore
ni personnage 3D, ni rig, ni rendu hybride dans le projet. Aucun modèle choisi
ou possédé par l’utilisateur n’est présumé.

## Jalon suivant : TRANSITION-001

Après commit et sauvegarde STEP-005, puis GO, préparer un prototype minimal
avec deux volumes/personnages 3D temporaires sur un fond 2D de diagnostic.
Il doit permettre de choisir et de vérifier concrètement le mode de composition,
la caméra et le raccord entre coordonnées au sol et image du fond.
La technique précise n’est pas figée par cette décision produit.

Critères avant de poursuivre l’arène STEP-006 :

- Alignement stable des pieds et des déplacements avec le fond isométrique.
- Croisement et profondeur corrects entre les personnages 3D.
- Test explicite devant/derrière un élément 2D de décor : ne pas supposer que
  le tri 2D existant résout l’occultation d’un personnage 3D.
- Échelle apparente lisible ; les 48 px de STEP-004 servent de point de comparaison.
- Portrait, zones sûres, tactile et pause/retour Android conservés.
- APK exportable et rendu correct sur le Galaxy A16 ; coût du rendu à mesurer,
  sans déduire les performances des tests précédents en 2D.

La cible Compatibility est conservée comme point de départ, pas comme résultat
3D déjà qualifié. La production des modèles, rigs et cinq animations sera cadrée
après ce prototype. Le mouvement visuel ne devra toujours pas piloter les dégâts.

## Conséquences sur le suivi

Conserver les IDs et résultats des étapes clôturées. Insérer TRANSITION-001
avant STEP-006, puis actualiser les détails concernés du plan suivant ses résultats.
Chaque livraison reste complète ; chaque étape validée reçoit un commit et
une sauvegarde contenant le nouvel historique. Ne pas réinitialiser le dépôt.
