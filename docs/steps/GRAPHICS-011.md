# GRAPHICS-011 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » après le choix B — Fin et lisible : barres
néon fines, largeur monde 42 → 29,4 (−30 %), panneaux à longueur inchangée avec un trait
légèrement plus épais. Profil visuel commun et glow discret, sans scintillement.
58 bancs / 4 001 contrôles et recette tactile Galaxy A16 déjà réussis. Seuls les documents
sont actualisés pour cette clôture : code, scènes, ressources, shader, configuration et
les deux APK restent identiques à la livraison validée. Les tests ne sont pas relancés.
Gambits conservés ; rendu clair/sombre et combat vérifiés sur le Galaxy, APK normal remis.
APK normal 0.1.0-graphics011 (58), SHA-256
`937951eb510873159c201e43eed516e4dc88d59793e914e32c23b06bc571f887`.
APK essais 0.1.0-graphics011-lab (58), SHA-256
`8ead02ad9e147bd7afe99d5845e53f3f56bc3076dab76459b3196fb10c4d8e49`.
Clôture par commit unique et sauvegarde restaurée/vérifiée. Prochain GO : UI-005,
qualification intégrée Android, puis STEP-029/030.
Les états précédents ci-dessous sont historiques.

# GRAPHICS-011 — Barres de combat fines et néon — en recette

Nouvelle demande du propriétaire après GRAPHICS-010 clôturée `eec1310a599051e5391740efcedd733c575e3078`.
Base sauvegardée et vérifiée : 756 fichiers. Cette évolution visuelle s'insère avant UI-005.
Le propriétaire choisit B — Fin et lisible dans Godot ; validation finale de l'étape attendue.

## Rendu livré

Toutes les barres au-dessus des héros et des ennemis sont raccourcies de 30 % : largeur
nominale 42 → 29,4. Le cœur du trait mesure désormais 1,25 unité de viewport au lieu de 3,5,
avec un léger halo fluo. Les bordures rectangulaires épaisses sont retirées. Le fond non
rempli reste une ligne discrète, et les extrémités sont arrondies et anti-crénelées.
Le halo peut dépasser légèrement le cœur : la réduction porte sur la longueur de la barre.

Les panneaux Mako / Anne emploient le même style, avec un cœur légèrement plus épais de
1,9 au lieu de 5. Leur longueur reste strictement calculée par le layout existant :
max(25, largeur du panneau − 83). Aucun changement de taille ou de placement des panneaux,
portraits, titres ou bouton Pause. Les emplacements Vide restent vides.
Ordre inchangé : PV rouges, mana bleue et incantation jaune or uniquement pendant un cast.
Les barres de référence de la fiche hors combat ne sont pas dans le périmètre de cette demande.

Réglage B : hauteur monde 1,25 ; hauteur panneau 1,9 ; espacement monde 2,25 et panneaux 3 ;
rayon de glow 1 et force 0,22. Couleurs rouge #ff4545, bleu #399fff et or #ffd24a.
Le glow est local et statique, sans pulsation, lumière 3D ni post-traitement global.
Il reste indépendant du renderer 3D et des animations du personnage.

## Architecture

`status_bar_style.gd` et `resources/presentation/status_bars/neon.tres` portent les valeurs
visuelles communes. `overhead_bars.gd` reste une vue passive : ratios PV/mana/cast reçus,
ordre, visibilité d'incantation et palette. `apply_style(profile, panel_mode)` règle hauteur,
espacement, couleurs et glow, sans modifier la largeur ni aucune donnée de combat.
Le mode panneau choisit simplement la variante d'épaisseur du même profil. La largeur
monde par défaut vaut 42 × 0,70 ; HeroStatusPanel conserve son calcul de largeur existant.

Le shader 2D `neon_status_bars.gdshader` dessine une seule surface par groupe de barres,
avec contours arrondis, lissage à l'échelle du pixel, cœur lumineux et halo doux borné.
Chaque groupe possède son propre ShaderMaterial : les ratios et un essai de style ne
modifient pas les autres personnages. Le shader n'utilise pas TIME et n'émet aucun signal.
Le marqueur historique de sélection reste disponible dans les anciens diagnostics ;
la page d'arène produit continue de le désactiver et n'introduit aucune cible manuelle.

Aucun changement de stats, de ciblage, d'exécuteur, de mana, de buffs, de durée d'incantation,
de navigation ou d'animations. Les barres des panneaux et du monde lisent les mêmes valeurs
réelles ; les anciennes scènes et l'UID de Main sont conservés.

## Essais Godot

F6 `scenes/debug/neon_bars_lab.tscn`, F8 dans l'éditeur pour fermer.
A Discret : hauteurs 1 / 1,6, force 0,14, rayon 0,85.
B Fin et lisible : 1,25 / 1,9, force 0,22, rayon 1 (choix du propriétaire).
C Lumineux : 1,5 / 2,2, force 0,30, rayon 1,15.
Dans les trois essais, monde raccourci de 30 % et panneaux à longueur conservée.

La vue figée utilise un instantané de démonstration avec deux héros et deux squelettes,
PV/mana partiels et incantations en cours pour comparer simultanément les trois lignes.
Les sorts de fixture ne sont pas résolus. Clair / sombre change d'arène ; Animer / figer
bascule vers un combat normal et reconstruit la fixture au retour. L'essai sélectionné
s'applique aussi aux nouveaux ennemis. Les données de fixture et capacités temporaires
d'ennemis restent strictement dans le laboratoire, pas dans les profils du jeu.
Chemin isolé `user://graphics011_bars_lab.json` ; aucune sauvegarde du joueur modifiée.

Export isolé : `python3 tools/export_neon_bars_lab.py --godot <binaire> --output <chemin.apk>`.
Même package que le produit ; remettre ensuite l'APK normal pour le jeu F5 et ses parcours.

## Vérifications

58 bancs existants / 4 001 contrôles réussis, zéro erreur/avertissement moteur.
Les bancs d'arène et d'application couvrent notamment ratios réels, cohérence des barres,
incantations facultatives, pause, navigation et nettoyage. Aucune nouvelle suite de tests
pour ce changement de style ; captures GPU et recette matérielle contrôlent son rendu.

Six captures GPU des trois essais sur arènes claire et sombre, compilation réelle du shader,
largeurs relevées : quatre groupes au-dessus des acteurs à 29,4 ; deux panneaux à 171 sur
viewport 540×960, comme avec le layout précédent. Zéro nœud orphelin après fermeture.
B choisi par le propriétaire après comparaison Godot. Aucun nouveau benchmark FPS.
Sur le Galaxy A16, les trois lignes fines sont lisibles dans les panneaux et au-dessus
des quatre acteurs, sur arènes claire et sombre, puis en combat animé. La pause tactile
est figée sur deux captures identiques et le retour au premier plan garde la pause.
L'APK normal est remis, les deux empreintes installées sont vérifiées et les gambits
d'origine sont conservés octet pour octet. Rapports et captures dans la livraison complète.

APK normal 0.1.0-graphics011 (58), SHA-256 :
`937951eb510873159c201e43eed516e4dc88d59793e914e32c23b06bc571f887`.
APK essais 0.1.0-graphics011-lab (58), SHA-256 :
`8ead02ad9e147bd7afe99d5845e53f3f56bc3076dab76459b3196fb10c4d8e49`.
Validation utilisateur, commit unique et sauvegarde restaurée/vérifiée attendus avant UI-005.
