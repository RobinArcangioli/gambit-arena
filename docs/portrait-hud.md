# HUD portrait — STEP-021

En-tête : état du combat et scénario, Pause/Reprendre toujours accessible hors formulaire.
État : PV et énergie chiffrés avec barres, action engagée ou intention, délais de soin et
spéciale, ennemis vivants et nombre de vaincus sur le budget du scénario. Pas de vagues
inventées : leur logique reste une étape ultérieure. L'action engagée est indépendante
des modifications ultérieures des règles ; le HUD affiche celle de l'exécuteur.

L'arène reste séparée des informations. Son cadrage peut dézoomer lorsque la hauteur
ou la largeur utile diminue, pour garder le sol et les mannequins visibles. Cela ne
modifie ni déplacement ni animation ; l'échelle apparente peut diminuer sur petit espace.

En bas : Rejouer, scénario et trois règles. Toucher un résumé ouvre l'éditeur, Oui/Non
change son activation, Haut/Bas sa priorité. Les résumés sont répartis sur trois lignes.
Lorsque nécessaire, faire défiler la liste verticalement pour atteindre la dernière règle.
Les commandes Rejouer/scénario restent hors de la liste. Les six cases futures sont masquées.

Le formulaire conserve le fonctionnement STEP-020 : mise en pause, brouillon, validation
atomique, annulation et reprise explicite. Ses champs peuvent défiler ; Appliquer/Annuler
restent en bas du panneau, toujours accessibles. Ouvrir une nouvelle règle remet le
formulaire en haut ; un simple relayout ne réinitialise ni brouillon ni configuration.
L'erreur de validation reste explicite et bloque Appliquer, comme avant.

Les marges Android sont lues dans les coordonnées physiques, converties dans celles du
viewport, puis intersectées avec ce dernier. Valeur absente/invalide : viewport utilisé.
La disposition suit les redimensionnements, retours d'arrière-plan et changements de
barres système. Le HUD laisse des marges supplémentaires de 12 px logiques.
Les dimensions de recette commencent à une zone utile de 360 × 640 ; ce n'est pas une
promesse de confort sur toute taille arbitraire. Les cibles tactiles y font au moins 48 px.

Tests : portrait_hud_tests.tscn. Les assertions géométriques et la comparaison de combat
ne remplacent pas l'inspection des textes, des bords et des gestes sur téléphone.
Recette complète : docs/steps/STEP-021.md. F6, tests manuels et fluidité confirmés OK par l’utilisateur ; commit en attente.

FIX-STEP-021-001 : les hauteurs des lignes et du contenu défilable sont calculées
depuis les minimums réels des boutons, avec marge finale. Voir la recette du correctif.

## Propagation tactile — FIX-STEP-023-001 / STEP-024

Contenus intermédiaires et boutons défilants en MOUSE_FILTER_PASS ; seuil natif de 12 px
logiques. Correction du swipe incluse, validation Android en attente. Voir la recette
docs/steps/FIX-STEP-023-001.md. Layout et zones sûres ne changent pas.

### Révision v2 de FIX-STEP-023-001

La propagation native de v1 a échoué au banc utilisateur. La v2 utilise un routeur tactile
local aux listes/formulaire : swipe direct sans inertie et appui court unique au relâchement,
avec suppression de la copie souris du geste. Validation F6 et Android en attente.

STEP-024 v2 validée le 25 octobre 2026 : retour global F6, tests manuels et fluidité OK,
correctifs tactiles inclus. Aucun détail séparé par geste fourni ; commit en attente.
