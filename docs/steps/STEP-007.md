# STEP-007 — Approche automatique et intention de cible

## Statut

Validée, commit en attente. Phase 5 : Déplacement.
Base STEP-006 : 1cc7f05947322fb34049f2fc12a8de37756d872b, sauvegarde vérifiée.
GO utilisateur reçu. Livraison : gambit-arena-complet-step-007-v1.tar.gz.
Aucun commit STEP-007. Version Android 0.1.0-step007, code 6.

## Périmètre

Approcher A puis B, réorienter une approche en cours, s’arrêter sans cible ou
si elle disparaît. Vitesse au sol indépendante de la direction, arrivée sans
oscillation, limites respectées. La sélection temporaire reste hors du mover.
Pas de déplacement au toucher, d’IA ennemie, d’évitement, de collision ou de combat.

Nouveaux : scripts/movement/ground_mover.gd, movement_lab.gd,
scenes/movement/movement_lab.tscn, tests/test_ground_mover.gd,
scenes/tests/ground_mover_tests.tscn, docs/movement.md et cette fiche.
Scène principale/preset/docs actualisés. Ancienne arène et mannequins inchangés.

## Appliquer

Fermer Godot. Vérifier un dépôt propre sur main, HEAD 1cc7f05 :

```bash
cd ~/gambit-arena
git status --short --branch
git log -1 --format="%h %s"
```

Si une modification inattendue existe, la signaler avant extraction. Sinon :

```bash
tar -xzf ~/Downloads/gambit-arena-complet-step-007-v1.tar.gz -C ~
cd ~/gambit-arena
git diff --check
git status --short --branch
```

Ouvrir Godot, attendre l’import ; conserver les nouveaux .gd.uid générés.
Ne pas réinitialiser Git. Aucun document à éditer manuellement.

## Tests du contrôleur

Ouvrir scenes/tests/ground_mover_tests.tscn et F6. Attendu : OK, zéro échec.
Le résultat est affiché à l’écran et dans Sortie ; détails d’échecs au débogueur.
F8 pour arrêter. Transmettre tout échec avant de continuer.
Les tests exécutent le vrai mover : cadence, axes, arrivée, retargetage,
annulation, borne et trois formes d’invalidation de cible.

## Recette Godot F5

1. En-tête STEP-007 / APPROCHE, héros cyan, cibles A/B orange, aucun message d’erreur.
2. Scénario 1 : approche A jusqu’à 0,8 unité, attente 0,5 s, approche B, attente,
   puis SANS CIBLE. Aucun dépassement ni tremblement persistant à l’arrivée.
3. Rejouer, puis presser Cible B pendant le trajet vers A : réorientation au prochain
   pas, sans téléportation. Aucune en mouvement : arrêt. Cible A relance l’approche.
   Ces commandes passent en TEST CIBLE ; Rejouer réactive AUTO.
4. Scénario 2 Axes : vitesse nominale affichée proche de 1,20 u/s en déplacement,
   comme dans le scénario 1. Le dernier pas et la bordure peuvent la réduire.
5. Scénario 3 Bordure : A est volontairement hors arène ; le héros reste sur
   la limite intérieure et affiche LIMITE. Choisir B le ramène à l’intérieur.
6. Scénario 4 Disparition : A disparaît après 0,75 s ; le héros s’arrête sans
   erreur. Choisir B fonctionne. Rejouer recrée A et reproduit le test.
7. Pause pendant l’approche : position, pose et temps figés ; choix A/B/Aucune
   et scénario bloqués. Reprendre reprend sans saut. Rejouer en pause remet le
   scénario à zéro mais ne reprend pas. Repères reste utilisable.
8. Clavier A/B/N/R/P/G/Espace et boutons : pas de doubles actions. Toucher le sol
   ne déplace rien ; les six cases À venir restent inactives.
9. Perte de focus puis retour : pause conservée. F8 arrête. L’arène statique
   scenes/arena/arena.tscn reste lançable avec F6.

## Android

Après recette PC réussie, exporter vers ~/gambit-arena-builds/step-007-debug.apk,
avec débogage coché, puis installer et relever le SHA-256 (docs/android.md).

1. Vérifier l’en-tête et les quatre scénarios au toucher : mêmes résultats que sur PC.
2. Contrôler la lisibilité des cibles A/B et du héros à 48 px, les boutons hors
   encoche/navigation, et l’absence de recouvrement gênant du terrain par le texte.
3. Accueil dix secondes puis retour pendant une approche : pause, pas de déplacement
   rattrapé, reprise uniquement sur Reprendre. Refaire après verrouillage/déverrouillage.
4. Répéter cinq fois scénario Disparition/Rejouer ; aucune erreur, fermeture ou cible
   fantôme. Tester A absente : arrêt sans erreur ; B doit rester sélectionnable.
5. Transmettre résultat du banc F6, observations PC/téléphone, SHA-256 et validation.

## Vérifications de préparation et limites

Références et géométrie du layout contrôlées, contrats numériques examinés,
archive complète vérifiée. Godot absent : compilation GDScript et tests fournis
non exécutés chez l’assistant ; aucune simulation Python n’est un test du moteur.
La marge et distance d’arrêt sont des paramètres de diagnostic, pas la portée
finale du combat. Ni cibles avec PV ni cinq animations de production implémentées.
La source de cibles est temporaire ; elle sera remplacée par les décideurs prévus.
Pas de pathfinding, collision ou persistance après destruction du processus.

## Résultats

Validation explicite utilisateur reçue le 22 octobre 2026.
- Banc de tests Godot F6 : OK, zéro échec, confirmé par l’utilisateur.
- Approche A puis B puis arrêt sans cible : OK.
- Changement de cible en mouvement sans téléportation et annulation : OK.
- Vitesse nominale proche de 1,20 u/s, hors dernier pas et bordure : OK.
- Respect de la limite avec une cible extérieure : OK.
- Disparition de A après 0,75 s, arrêt sans erreur : OK.
- Pause : position et pose figées, reprise sans saut : OK.
- ADB : téléphone en état device, installation Success sur Galaxy A16.

APK testé : step-007-debug.apk. SHA-256 :

```text
fa80fcb980db86072b1c8237540b7170d845fd266324ea287f4c4b9f90ade610
```

Ces résultats proviennent de l’utilisateur ; l’assistant n’a pas exécuté Godot.
Aucune mesure de performance ni capture n’a été transmise pour cette étape.
Les essais spécifiques accueil/verrouillage ne sont pas détaillés séparément
dans ce retour ; la validation globale est reçue sans inventer un relevé par test.

## Clôture

Après validation, recevoir les documents complets puis commiter avec les nouveaux
scripts, scènes, tests et .gd.uid générés :
feat: [STEP-007] ajouter le deplacement automatique vers une cible.
Confirmer le hash et le statut propre, lancer bash tools/create_backup.sh et
transmettre l’archive. STEP-008 attend la clôture et un nouveau GO.

## Livraison de validation

Archive : gambit-arena-complet-step-007-validation.tar.gz.
Seule la documentation évolue depuis la v1 testée. Le bundle fourni contient
la base 1cc7f05, pas encore STEP-007. Les nouveaux .gd.uid générés localement
sont conservés à l’extraction et doivent être inclus dans le prochain commit.

## Clôture confirmée

Commit 9b3240c16632e89afa6354cda2eecbe5077e57ba, main propre. Sauvegarde
reçue gambit-arena-20261022-203734-9b3240c16632.tar.gz : bundle complet
cloné, HEAD confirmé, 78 fichiers identiques. STEP-008 autorisée par GO.
Les mentions « commit en attente » ci-dessus décrivent la livraison de validation.
