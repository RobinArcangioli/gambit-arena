# STEP-009 — Séparation bornée et blocage

## Statut et dépendance

Validée, commit en attente. GO reçu après clôture STEP-008 dans
46dfaa77ac79fccccebe165973a1bdbfb1000cf4. Sauvegarde avec bundle restaurée et
vérifiée : 90 fichiers identiques, historique complet, dépôt propre.
Livraison : gambit-arena-complet-step-009-v1.tar.gz.

## Objectif

Empêcher les traversées entre acteurs, corriger progressivement une pénétration
initiale, respecter les limites et laisser un acteur bloqué attendre une ouverture.
Encerclement et reprise sans téléportation ; contrôle du pas de déplacement.
Ni pathfinding, statistiques, PV ni combat. Les modèles restent les mannequins 48 px.

## Installation

Fermer Godot. Le dépôt doit être propre sur 46dfaa7 avant extraction :

```bash
cd ~/gambit-arena
git status --short --branch
git log -1 --format="%h %s"
tar -xzf ~/Downloads/gambit-arena-complet-step-009-v1.tar.gz -C ~
git diff --check
git status --short --branch
```

L’archive contient tout le projet et le bundle de base séparé ; elle ne touche
pas .git. Ne pas supprimer le dossier existant. Rouvrir project.godot, attendre
l’import et conserver les nouveaux .gd.uid générés par Godot.

## Banc F6

Ouvrir scenes/tests/ground_crowd_tests.tscn et lancer F6. Patienter quelques
secondes. Attendu : OK, zéro échec. Transmettre ce résultat séparément des tests
manuels. F8 pour arrêter, F5 pour le laboratoire. En cas d’erreur, transmettre
le texte intégral ; ne pas commiter une étape encore en correction.

## Recette manuelle Godot puis Galaxy A16

1. Encerclement : laisser arriver les ennemis pendant au moins 25 secondes actives.
   Attendre 20/20 ; des ennemis se répartissent autour du héros, les suivants
   s’arrêtent derrière les voisins. Aucun acteur ne traverse un autre. Les disques
   au sol restent distincts ; l’occultation des silhouettes est normale.
2. Poursuite : le héros vise successivement les coins d’un carré. Les ennemis
   suivent sa position, se gênent et peuvent le bloquer. Il attend alors sans
   sauter au prochain point. Aucun tremblement prolongé ou saut de position.
3. Blocage : six gardiens fixes ; le héros avance un peu puis affiche BLOQUE.
   Attendre cinq secondes : il ne s’échappe pas et ne traverse pas la couronne.
   Ouvrir passage : un seul gardien disparaît, le héros reprend et atteint sa
   destination. Les cinq autres restent fixes. Rejouer referme la couronne.
4. Bordure : deux ennemis volontairement superposés dans le coin opposé au héros
   se séparent progressivement. Ils restent dans l’arène, même pendant la correction.
   L’afflux suivant ne crée pas de nouvelle pile à son point d’apparition.
5. Le « pas max » reste au plus 0,050 u environ (tolérance d’affichage 0,001).
   À 60 pas/s il doit généralement rester au plus 0,025 u. Le compteur repart
   de zéro avec Rejouer. Il ne mesure ni FPS ni durée d’image.
6. Pause pendant la séparation ou les apparitions : positions, poses, temps et
   compteurs figés. Repères reste utilisable ; mode et action sont bloqués.
   Rejouer en pause réinitialise mais reste figé. Reprendre sans saut ni rafale.
7. Apparitions non suspend les créations seulement. Rejouer plusieurs fois :
   aucun mannequin résiduel et compteur remis à zéro. Six cases toujours inactives.
8. Aucun message d’erreur ; F8 fonctionne. Sur téléphone : réduction/accueil et
   verrouillage puis retour restent en pause jusqu’à Reprendre.

Signaler les saccades, oscillations ou blocages incohérents. Un blocage stable
sans trajet direct est attendu ; aucune garantie de détour n’est revendiquée.

## Export Android

Version 0.1.0-step009, code 8. Exporter Android Debug avec débogage activé
vers ~/gambit-arena-builds/step-009-debug.apk, jamais dans le dépôt.

```bash
mkdir -p ~/gambit-arena-builds
~/Android/Sdk/platform-tools/adb devices -l
~/Android/Sdk/platform-tools/adb -d install -r ~/gambit-arena-builds/step-009-debug.apk
sha256sum ~/gambit-arena-builds/step-009-debug.apk
```

Tests manuels et F6 OK, fluidité confirmée ; empreinte APK consignée ci-dessous.
Aucun relevé chiffré de FPS ou de temps d’image fourni.

## Fichiers et vérifications de livraison

Nouveaux scripts dans scripts/crowd : ground_crowd, crowd_simulation,
crowd_marks, crowd_lab. Nouvelle scène scenes/crowd/crowd_lab.tscn,
banc scenes/tests/ground_crowd_tests.tscn et tests/test_ground_crowd.gd.
Main, version Android et documentation actualisés ; aucun ancien script ni asset
modifié. Détails techniques et limites : docs/crowd.md et ARCHITECTURE.md.

Références, préservation des fichiers antérieurs, espaces de fin de ligne et
archive contrôlés. Vérification numérique indépendante des budgets, du coin,
de la couronne et de groupes de 20 effectuée. Godot absent chez l’assistant :
aucun test moteur, compilation GDScript, rendu ou export exécuté ici.

## Clôture prévue

Après validation explicite : archive complète de validation avec résultats,
puis commit feat: [STEP-009] ajouter la separation bornee des acteurs.
Sauvegarde propre via bash tools/create_backup.sh et transmission pour vérification.
STEP-010 (statistiques et PV isolés) attend la clôture et un nouveau GO.

## Validation utilisateur reçue

STEP-009 explicitement validée par l’utilisateur : tous les tests manuels OK,
banc F6 OK, fluidité OK. Installation ADB Success sur Samsung Galaxy A16
SM-A165F, Android 16. Aucun chiffre FPS ni temps d’image fourni.
APK testé : step-009-debug.apk, version 0.1.0-step009, code 8.
SHA-256 : ff61292efe28c5688fd537982efe2f5ff03672c7934f2edeab19b5e7bf8bb24f.

Archive de validation : gambit-arena-complet-step-009-validation.tar.gz.
Code et configuration identiques à la livraison v1 testée ; seule la documentation
est actualisée. Aucun lancement Godot exécuté chez l’assistant.
Statut : Validée, commit en attente. Hash et sauvegarde après commit à recevoir.
