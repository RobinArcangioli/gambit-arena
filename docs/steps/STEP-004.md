# STEP-004 — Premier prototype visuel Android

## Statut et dépendances

Phase 2 : Prototype. Statut : Validée, commit en attente.
Base réelle : RECOVERY-001, 6282d81d18b8b013046821ee8bcafe459553c8b0.
STEP-003 corrigée et restauration validées. Feu vert STEP-004 reçu.
Livraison initiale testée : gambit-arena-complet-step-004-v1.tar.gz.
Livraison documentaire de validation : gambit-arena-complet-step-004-validation.tar.gz.
Validation explicite reçue le 22 octobre 2026. Aucun hash STEP-004 encore confirmé.

## Objectif et périmètre

Exporter, installer et lancer le premier APK sur Samsung Galaxy A16 Android 16.
Vérifier déplacements automatiques, tri aux pieds, taille apparente et commandes
tactiles. Choisir une préférence parmi 48/64/80 pixels de référence avant STEP-005.
Ajouter un premier contrôle des zones sûres et du retour d'arrière-plan.
Pas de héros jouable, combat, collision, gambit, animation finale ou benchmark.

## Changements livrés

- Quatre boutons : Pause/Reprendre, Taille, Repartir, Silhouette.
- Équivalents clavier : Espace, S, R, T.
- Échelle des visuels 1, 4/3 ou 5/3 ; racines et repères des pieds inchangés.
- Zone sûre Android convertie vers le viewport ; HUD positionné à l'intérieur.
- Pause de l'horloge sur perte de focus/arrière-plan ; reprise manuelle.
- FPS instantanés indicatifs, sans preuve de performance soutenue.
- Trajets ±45 unités sur huit secondes ; décor recentré à (130,130).
- APK version 0.1.0-step004, code 2. Compression ETC2/ASTC conservée.

Fichiers fonctionnels : project.godot, export_presets.cfg,
scenes/debug/projection_lab.tscn, scripts/debug/projection_lab.gd.
Documentation : README, ARCHITECTURE, ROADMAP, PROJECT_STATUS,
docs/android.md, coordinates.md, assets.md, backup.md, recovery.md et cette fiche.
Les conversions pures, les assets et leurs métadonnées d'import sont conservés.

## Installation de la livraison

Fermer Godot. Vérifier que main est propre et que HEAD est 6282d81 :

```bash
cd ~/gambit-arena
git status --short --branch
git log -1 --format="%h %s"
```

Si des changements locaux inattendus existent, les signaler avant extraction.
Sinon extraire l'archive complète depuis Downloads vers le dossier personnel :

```bash
tar -xzf ~/Downloads/gambit-arena-complet-step-004-v1.tar.gz -C ~
cd ~/gambit-arena
git diff --check
git status --short --branch
```

Le .git existant reste en place. Le bundle livré est celui de la base et se
trouve à côté du projet. Ne pas initialiser de nouveau dépôt.

## Recette Linux

1. Ouvrir Godot, attendre l'import, F5 : écran STEP-004 sans erreur du débogueur.
2. Observer deux cycles : cyan/orange puis violet/pilier passent devant et derrière.
3. Pause : positions et temps figés ; Taille fonctionne encore en pause.
4. Cliquer Taille trois fois : 64, 80, 48 ; une seule transition par clic.
5. Repartir en pause : temps 0, reste en pause. Reprendre relance le cycle.
6. Silhouette : alternance normale/haute toutes les deux secondes pendant la marche.
   Les pieds ne sautent pas ; le tri ne dépend pas du haut du sprite.
7. Vérifier Espace, S, R, T ; changer de fenêtre puis revenir : état PAUSE.
8. Projection/inverse affiche OK, erreur < 0,01. F8 arrête correctement.

En cas d'erreur GDScript, transmettre le texte et ne pas poursuivre l'export.

## Export et installation Android

Suivre docs/android.md. Sortie : ~/gambit-arena-builds/step-004-debug.apk,
Export With Debug coché. Installation ADB attendue : Success.
Transmettre le SHA-256 de l'APK, puis ouvrir Gambit Arena sur le téléphone.

## Recette sur Galaxy A16

1. L'application démarre en portrait et affiche STEP-004, sans écran noir persistant.
2. Tous les textes et boutons restent visibles, hors encoche et zone de navigation.
3. Observer au moins deux cycles à chacune des tailles 48, 64 et 80, silhouette
   désactivée. Noter la lisibilité, les occultations et la taille préférée.
4. Tester chaque bouton dix fois : une pression = une action, pas de déclenchement
   double. Taille boucle 48/64/80 ; Repartir conserve l'état pause/marche.
5. Activer Silhouette et tester les croisements : ancrages stables, ordre sans ambiguïté.
6. En marche, relever le temps affiché, revenir à l'accueil Android pendant dix
   secondes, puis rouvrir depuis les applications récentes : état PAUSE,
   pas de cycle poursuivi pendant l'absence. Reprendre doit relancer normalement.
7. Verrouiller puis déverrouiller le téléphone : même reprise explicite attendue.
8. Observer deux minutes : signaler blocage, fermeture ou saccades visibles.
   Relever les FPS approximatifs en précisant la taille choisie ; ce n'est pas
   encore une qualification à 30 FPS soutenus en charge réelle.
9. Fournir une capture à la taille préférée avec interface complète, et signaler
   navigation par gestes ou par boutons. Aucun identifiant personnel n'est requis.

## Critères d'acceptation

APK identifié, export et installation réussis ; démarrage stable ; tri lisible
aux pieds ; boutons tactiles utilisables sans doubles actions ; taille préférée
consignée ; zone sûre correcte ; pause/reprise initiale cohérente ; aucune erreur
bloquante observée. Le choix de taille reste ajustable avec les vrais assets.

## Vérifications de livraison et limites

L'assistant a vérifié les références locales et chemins de nœuds, conservé les
32 fichiers de base, contrôlé les calculs de projection et les dimensions du
placement de référence. Le bundle correspond à 6282d81.
Godot n'est pas installé dans l'environnement de préparation : compilation,
import, rendu, export et essais tactiles n'ont pas été exécutés ici.

Le HUD de diagnostic cible le portrait 540 × 960 et le Galaxy A16 ; les formats
étroits, paysage et très petites fenêtres ne sont pas qualifiés. La zone sûre
native peut différer suivant le mode de navigation : la capture matérielle fait
partie de la recette. Ce diagnostic ne persiste pas après destruction du
processus Android ; sa relance réinitialise le cycle. La robustesse complète
reste à STEP-027. Les FPS affichés ne couvrent pas la future charge de combat.

## Résultats reçus — 22 octobre 2026

L'utilisateur confirme : « Tout est ok côté tests manuels, Sur Godot comme
sur mon téléphone. Step validée. » Cette confirmation est globale ; aucun
relevé chiffré par test ni capture n'a été transmis.

- Linux / Godot : tests manuels déclarés réussis.
- Téléphone Galaxy A16 Android 16 : tests manuels déclarés réussis.
- Export : APK généré et utilisé pour les essais.
- ADB : téléphone en état device ; installation : Success.
- APK : step-004-debug.apk, version livrée 0.1.0-step004, code 2.
- SHA-256 communiqué :

```text
c554729004c142a67223176b5c24dd86a28accb6cb6606001339aeeed2f3475b
```

Taille préférée confirmée le 22 octobre 2026 : 48 px de référence.
Cette valeur est retenue pour la suite et pourra être réévaluée avec les vrais assets.
Aucun FPS mesuré ni qualification de performance soutenue n'est déduit.
La validation explicite est acceptée ; aucun changement fonctionnel n'est
apporté à la livraison testée. Cette archive actualise seulement les documents.

## Clôture — validation reçue

Message proposé : feat: [STEP-004] valider le prototype visuel sur Android.
Cette livraison complète consigne les résultats reçus.
Appliquer les documents, vérifier le diff préparé puis commiter. Confirmer le hash et le statut propre,
exécuter bash tools/create_backup.sh et transmettre la nouvelle sauvegarde.
STEP-005 attend ensuite un nouveau feu vert.

## Références officielles

- https://docs.godotengine.org/en/4.7/tutorials/export/exporting_for_android.html
- https://docs.godotengine.org/en/4.7/classes/class_displayserver.html#class-displayserver-method-get-display-safe-area
- https://docs.godotengine.org/en/4.7/classes/class_viewport.html#class-viewport-method-get-screen-transform
- https://docs.godotengine.org/en/4.7/classes/class_node.html
- https://docs.godotengine.org/en/4.7/classes/class_projectsettings.html

## Clôture effective

Commit confirmé : 491cde8ecc276dac6728e06a579e3788ab423dda, branche main propre.
Sauvegarde reçue : gambit-arena-20261022-011216-491cde8ecc27.tar.gz.
Restauration du bundle vérifiée par l'assistant ; 33 fichiers identiques.
Cette clôture remplace le statut historique « commit en attente » ci-dessus.
