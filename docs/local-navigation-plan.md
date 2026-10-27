# Déplacement : décisions actuelles au 27 octobre 2026

GAMEPLAY-002 est validée et clôturée au commit d3ff7df9125bf3acd9511b6c10d51a4a531739f7.
Le contournement local commun aux héros et ennemis est conservé : voir local-navigation.md.

GAMEPLAY-003 est complètement annulée à la demande du propriétaire, qui confirme que les
tailles et contournements sont satisfaisants. Il n'y aura pas de réduction des dimensions :
rayon 0,35, diamètre 0,70, échelle artistique 0,65. Les valeurs candidates 0,27 / 0,50 sont abandonnées.
Aucun allègement géométrique n'est ajouté. Le plan initial reste consultable dans l'historique Git.

GRAPHICS-008 ajoute des disques d'ombre sobres et translucides, correspondant à l'emprise
logique au sol ; la présentation reçoit le rayon du corps. Aucun paramètre du mouvement,
de la navigation, du spawn ou des compétences n'est changé.

Ordre actuel : GRAPHICS-008 → STEP-029 → STEP-030.
