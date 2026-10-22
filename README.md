# Gambit Arena

Jeu Android portrait sous Godot 4.7.2 standard, Compatibility : personnages 3D
sur fond 2D dimétrique. Le gameplay visé est automatique et piloté par gambits.

## État actuel

TRANSITION-001 validée et sauvegardée dans 056a464. STEP-006 est validée
par l’utilisateur le 22 octobre 2026, commit en attente : arène fixe et
réservations pour l’interface. Installation Android réussie.
Deux mannequins 3D immobiles, à la taille de référence 48 px retenue sur A16.
Aucun combat, ciblage ou déplacement automatique n’est encore implémenté.

## Lancer

Ouvrir project.godot, attendre l’import puis F5. En-tête : STEP-006 / ARENE.
L’arène est entièrement visible entre les panneaux supérieur et inférieur.
F8 arrête depuis l’éditeur. Les anciens diagnostics peuvent être ouverts avec F6 :
scenes/hybrid/hybrid_lab.tscn et scenes/debug/animation_lab.tscn.

| Commande | Clavier | Effet |
|---|---|---|
| Position : 1/5 à 5/5 | P | Centre puis quatre coins, placements bornés |
| Repères | G | Affiche la limite intérieure, les axes et les croix au sol |
| Pause / Reprendre | Espace | Suspend les changements de position |

Pause désactive Position ; Repères reste utilisable. La perte de focus ou
l’arrière-plan Android impose une reprise explicite. Il n’y a pas de temps de
combat à suspendre dans cette arène statique.
Les six cases « À venir » sont volontairement inactives. Les textes du HUD
annoncent des zones réservées, pas des statistiques ou gambits fonctionnels.

## Tests et Android

Procédure complète : docs/steps/STEP-006.md. APK Android Debug avec débogage,
version 0.1.0-step006 code 5, même paquet et signature locale.
Exporter impérativement dans ~/gambit-arena-builds/step-006-debug.apk,
pas à la racine du dépôt. Voir docs/android.md.

Godot n’est pas disponible chez l’assistant : les contrôles statiques ne
remplacent pas l’import, le lancement et les essais sur téléphone.
Conserver les nouveaux .gd.uid générés par l’import pour le futur commit.

## Sources et sauvegardes

Les anciennes scènes, assets et métadonnées reçus sont conservés.
Le fond de l’arène est un dessin 2D produit par code ; les mannequins sont ceux
du prototype hybride. Aucun modèle ou pack externe n’est nécessaire.
L’archive complète contient, séparément, le bundle Git de la base 056a464.
Il ne contient pas les changements STEP-006 avant leur commit.
Après validation et commit, dépôt propre : bash tools/create_backup.sh,
puis transmettre la sauvegarde. Ne jamais réinitialiser le dépôt pour une livraison.

## Documents

- PROJECT_STATUS.md : état exact et prochaine action.
- ROADMAP.md et ARCHITECTURE.md : plan et composants existants.
- docs/arena.md : dimensions, limites et réservations.
- docs/hybrid-rendering.md : contrat de composition 3D/2D.
- docs/steps/STEP-006.md : recette et critères de validation.
- docs/assets.md, docs/android.md, docs/backup.md : sources, export et sauvegarde.
