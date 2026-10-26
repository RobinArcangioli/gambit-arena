# GRAPHICS-003 validée — clôture autorisée

Le propriétaire valide GRAPHICS-003 et donne GO pour GAMEPLAY-001.
Les fichiers non documentaires sont identiques à la livraison validée.

# Actualisation GRAPHICS-003 — livrée en recette

Base GRAPHICS-002 : commit local 1e427560a9d2884ce1d3e339a093d576192fc22f,
sauvegarde restaurée et vérifiée. GRAPHICS-003 ajoute les quatre modèles pirates, Idle/Walk,
les vues remplaçables et la galerie character_lab. 28 bancs / 1 803 contrôles sans échec.
APK 0.1.0-graphics003 (code 31) installé et lancé sur Galaxy A16 ; rendu capturé.
Voir [la recette](docs/steps/GRAPHICS-003.md). Validation utilisateur et commit en attente.
GAMEPLAY-001 vient ensuite : équipe Anne/Mako, soin allié, Foudre, mana et barres.
Les sections ci-dessous décrivent les états historiques.

# État du projet — 26 octobre 2026

## GRAPHICS-002 — validée, commit autorisé

GRAPHICS-001 validée, commit local `f5a790d38ed12cd3ccc3bac85162308986a5f894`.
Sauvegarde `gambit-arena-20261026-055618-f5a790d38ed1.tar.gz` restaurée et vérifiée :
bundle, intégrité Git et 354 fichiers identiques. Ce checkpoint est local ; origin/main
reste à STEP-028 tant qu'aucun push supplémentaire n'a été effectué.

GO reçu pour GRAPHICS-002 : les huit arènes sont intégrées, avec vignettes et sélecteur commun
au jeu et à la galerie. Ouverture en pause, choix sans reset ni mutation du combat, reprise
explicite, Rejouer conserve le décor dans la session. 27 bancs headless : 1 728 contrôles,
zéro échec et aucun warning/erreur Godot ; 14 contrôles en fenêtre passent également.
Voir [docs/steps/GRAPHICS-002.md](docs/steps/GRAPHICS-002.md).

GRAPHICS-002 est explicitement validée par le propriétaire, qui demande son commit.
La sauvegarde sera créée et vérifiée après ce commit. GRAPHICS-003 attend les modèles 3D
de personnages/ennemis annoncés par le propriétaire. GRAPHICS-003 à GRAPHICS-007, puis
STEP-029/030 restent à réaliser. Les sections suivantes sont historiques.

## GRAPHICS-001 — validée par le propriétaire

Roadmap graphique validée par le propriétaire, GO reçu. Base commitée : STEP-028 / 580ce64.
Le Colisée fourni est intégré dans Main via une Resource de présentation ; la référence
procédurale reste le défaut des anciens laboratoires. Galerie indépendante et test de contrat
ajoutés. Les huit thèmes sont fixés par l'archive reçue ; sept restent pour GRAPHICS-002.
Voir [docs/steps/GRAPHICS-001.md](docs/steps/GRAPHICS-001.md) et
[docs/arena-presentation.md](docs/arena-presentation.md).

Les 26 bancs headless passent 1 649 contrôles ; sept contrôles graphiques supplémentaires
passent en fenêtre. Le propriétaire a validé GRAPHICS-001 et donné le GO pour GRAPHICS-002.
Checkpoint et sauvegarde de la première étape à réaliser avant l'intégration du catalogue.

## Actualisation — clôture STEP-028 et proposition graphique

STEP-028 est clôturée au commit `580ce641390f30667133cec0a580ee3d64f0c51a`, poussé sur main.
Sauvegarde `gambit-arena-20261026-044515-580ce641390f.tar.gz` restaurée et vérifiée : bundle
valide, contrôle d'intégrité Git et 327 fichiers identiques au commit. Les mentions de commit
en attente dans la section suivante décrivent la validation avant cette clôture.

Le propriétaire demande maintenant une roadmap d'évolutions graphiques isolées du gameplay.
Plan dans [docs/graphics-roadmap.md](docs/graphics-roadmap.md) : GRAPHICS-001 à GRAPHICS-007,
arènes puis modèles 3D, attaque, soin et Foudre. Le plan est maintenant validé et GRAPHICS-001
est en recette ; STEP-029 et STEP-030 restent à faire après le chantier graphique.

## STEP-028 — validée par l'utilisateur, commit et sauvegarde en attente

Base réelle vérifiée : cc91c79b0bcf82df6fb852d9b792fce63aa32148, main propre et identique
à GitHub au démarrage. Aucun changement utilisateur à écraser. HANDOFF-001 a bien été
commitée et publiée ; les sections historiques ci-dessous décrivent sa rédaction antérieure.

Instrumentation optionnelle, captures bornées, menu de mesures et export JSON implémentés.
Protocole fixé dans docs/performance.md : chauffe 30 s, capture 60 s, trois répétitions
Normal/20 ennemis et dix resets. Tests et mesures effectifs : docs/steps/STEP-028.md.
L'objectif initial de 30 FPS n'est pas atteint par cet APK Debug, avec ou sans économie
d'énergie ; le propriétaire a explicitement accepté la performance pour le contenu prévu et a
retiré 20 ennemis simultanés des critères de livraison. Aucun correctif de rendu spéculatif n'a
été intégré. Le propriétaire a explicitement validé F6, F5, tactile Android et pause/reprise.
STEP-028 est donc validée par l'utilisateur ; aucun commit/push ni sauvegarde STEP-028 n'a été
effectué.

## Dernière étape fonctionnelle clôturée

STEP-027 : validée et commitée, sauvegarde reçue et vérifiée.
Commit : 665c0c8d86a6400f88c77773295ed06b1a518206 ; branche main propre au checkpoint.
Parent : 344a584ec680ba7b45fb648b3a2eceb8937a97ae.
Backup : gambit-arena-20261026-011155-665c0c8d86a6.tar.gz.
Bundle complet, fsck OK, 307 fichiers identiques entre commit/backup/livraison validée.
APK : step-027-debug.apk ; version 0.1.0-step027, code 27.
SHA-256 : 07467efcfb7e663e363e6f6fc61644fd2bf2889e7ee3a3001d42589e0c6cf611.
Retour utilisateur : F6 OK, tests manuels OK, fluidité OK. Aucun résultat détaillé par banc
ou mesure chiffrée fourni. Aucune nouvelle réserve signalée à cette clôture.

## HANDOFF-001 — Documents préparés, commit/push à effectuer

Demande utilisateur : documenter le projet pour une prochaine IA, créer une archive et
fournir les commandes de push GitHub. Livrable : gambit-arena-complet-handoff-001.tar.gz.
Documents d’entrée actualisés et dossier docs/handoff ajouté. Aucun changement de code,
scène, test, asset, preset ou project.godot ; aucun nouvel APK requis.
Le bundle inclus reste celui de 665c0c8 ; les documents sont dans les sources mais pas encore
commités. Aucun hash documentaire ni URL GitHub ne sont inventés. Aucun push effectué ici.
La prochaine IA doit vérifier si le commit/push a été réalisé après rédaction de cet état.

## Suite

Préparer le commit STEP-028, créer la sauvegarde après le commit et vérifier celle-ci.
Transmettre le hash, le statut et la nouvelle sauvegarde pour vérification. STEP-029 et
STEP-030 restent à faire et nécessitent leur propre GO ; aucun push n'est implicite.

## Limites de preuve

Les limites « Godot non disponible » des sections historiques décrivent HANDOFF-001, non le
travail STEP-028 effectivement exécuté. Le clone propre final et la recette MVP finale restent
à réaliser. Voir HANDOFF.md et docs/handoff/NEXT_STEPS.md.
