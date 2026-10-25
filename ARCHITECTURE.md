# Architecture réelle — STEP-021 validée, commit en attente

Main conserve son UID et ouvre scenes/ui/portrait_hud_lab.tscn.
PortraitHudLab étend GambitFieldsLab sans modifier les fichiers de STEP-020.
Les signaux existants sont conservés : boutons de règles déplacés dans un ScrollContainer,
champs du formulaire dans un second ScrollContainer. Pas de double raccordement.
Appliquer/Annuler restent hors du défilement ; la modalité et la pause sont héritées.
Les résumés ont trois lignes pour rester lisibles aux largeurs réduites.

HudLayout est un calcul de rectangles sans état de jeu. Il intersecte la zone sûre avec
le viewport et retombe sur ce dernier si la zone reçue est vide, non finie ou disjointe.
Sur Android, la zone physique est convertie par l'inverse du screen_transform avant
intersection. HUD et arène appliquent l'offset sûr une seule fois. Le voile modal couvre
le viewport entier, son panneau reste dans la zone sûre. Un override logique est réservé
au banc F6 ; aucun bouton utilisateur n'active ce mode diagnostic.

Le HUD comporte en-tête, état chiffré, arène et pied de page sans superposition. La
hauteur de liste varie ; ses trois règles restent atteignables par défilement. Le panneau
modal est limité à 616 px et à la hauteur sûre moins 24 px. Ses champs peuvent défiler,
ses commandes restent fixes. Recette sur zones utiles de 360 × 640 à 768 × 1024 et
formats allongés ; les tailles inférieures ne constituent pas une cible validée.

La projection orthographique ajuste uniquement son cadrage : au plus 48 px par unité,
largeur visible minimale 10.2 unités et hauteur minimale 6.8 unités. Cela réserve de la
place au sol et aux mannequins quand la zone d'arène se réduit. Les positions physiques,
rotations et poses ne sont pas modifiées par le HUD.

L'affichage lit PV/max PV, énergie/60, action réellement engagée (ou intention courante),
cooldowns, ennemis vivants et vaincus. Il n'invente pas un compteur de vagues. Les barres
ont aussi des valeurs numériques. Les délais et états restent figés par la même horloge.
Le résultat terminal est visible dans l'en-tête. L'affichage n'émet aucune action de jeu.

La disposition est recalculée sur resize et reprise ; une vérification toutes les 0.25 s
réagit aussi aux changements de zone sûre sans resize. Ce temps UI ne fait pas avancer
GameClock. Les six emplacements manuels restent masqués, en attente de STEP-022.

Simulation, actions, compétences, déplacements, mannequin, contrôleur, évaluateur,
modèle d'éditeur et anciens tests sont identiques à STEP-020, correctif d'immobilité inclus.
Le banc HUD compare aussi la chronologie d'un combat avec celle du laboratoire STEP-020.
Godot non exécuté chez l'assistant. Version 0.1.0-step021, code 20.

FIX-STEP-021-001 : les hauteurs des lignes et du contenu défilable sont calculées
depuis les minimums réels des boutons, avec marge finale. Voir la recette du correctif.
