# GRAPHICS-003 — recette actuelle

28 bancs, 1 803 contrôles, zéro échec. Nouveau banc character_presentation_tests.tscn.
F6 character_lab.tscn puis F8/F5 ; Android installé, contrôle visuel effectué, recette
utilisateur attendue. Voir docs/steps/GRAPHICS-003.md pour APK et limites.

# Tests, environnement et preuves de validation

## Actualisation GRAPHICS-002

Validation globale explicite reçue du propriétaire le 26 octobre 2026 ; commit demandé.
Ce retour n'ajoute pas de mesure ni de détail par banc aux preuves suivantes.

27 bancs headless : 1 728 contrôles, zéro échec, aucun warning/erreur Godot dans cette campagne.
Le nouveau `arena_catalog_tests.tscn` ajoute 79 contrôles, dont gestes tactiles réels au
viewport, sélection des neuf profils, calage, états conservés, cycle de vie et nettoyage.
14 contrôles supplémentaires passent en fenêtre, avec captures des huit fonds et du sélecteur.
Preset actuel : `graphics-002-debug.apk`, version `0.1.0-graphics002`, code 30.
Recette et empreinte : [GRAPHICS-002](../steps/GRAPHICS-002.md).
Les actualisations suivantes décrivent les versions précédentes.

## Actualisation GRAPHICS-001

26 bancs headless : 1 649 contrôles, zéro échec, aucun warning/erreur Godot dans cette campagne.
Le nouveau `arena_presentation_tests.tscn` couvre les vues, replis, calage et équivalence du jeu
sur 900 ticks avec trois présentations de terrain. Sept contrôles supplémentaires en fenêtre
X11 passent via le viewport réel. Contrôle d'affichage réalisé sur Galaxy A16 après installation.
Recette utilisateur et APK identifié : [GRAPHICS-001](../steps/GRAPHICS-001.md).
F6 sur `scenes/debug/graphics_lab.tscn` ouvre la galerie sans combat. Le preset actuel est
`graphics-001-debug.apk`, version `0.1.0-graphics001`, code 29 ; les sections STEP-028 suivantes
décrivent la base précédente.

## Actualisation STEP-028 — 26 octobre 2026

Environnement effectif vérifié : Ubuntu 24.04.5, Godot 4.7.2.stable.official.ed1daf0bf,
templates 4.7.2.stable, OpenJDK 21.0.12.1, SDK Android et ADB 37.0.1 présents.
Galaxy A16 SM-A165F Android 16 connecté ; les anciennes limites « Godot absent » ci-dessous
décrivent la passation historique. STEP-028 dispose maintenant de 25 scènes, avec
`performance_tests.tscn` en plus des 24 bancs de base.

Les 24 bancs historiques ont été réellement exécutés en headless dans une copie isolée :
1 594 contrôles, zéro échec, aucune erreur/avertissement Godot relevé. Un harnais temporaire
arrête chaque scène après son bilan ; ce n'est pas un runner global versionné ni une équivalence
aux recettes manuelles F6/tactile. Le nouveau banc passe 32 contrôles en headless et en fenêtre
X11/Compatibility. Il valide horloges, buffers, quantiles, profils de fixture, interruptions,
export, retour au jeu ordinaire et dix resets synthétiques. Aucun de ces tests accélérés
n'est un benchmark. Résultats matériels et SHA : ../steps/STEP-028.md.

Commande autonome du nouveau banc, avec dossier de données de test isolé :

```bash
XDG_DATA_HOME=/tmp/gambit-performance-tests Godot_v4.7.2-stable_linux.x86_64 \
  --headless --path . scenes/tests/performance_tests.tscn -- --test-exit
```

Adapter le chemin du binaire. En F6 le banc reste affiché jusqu'à F8.
Le 26 octobre 2026, le propriétaire a validé STEP-028 avec le retour global : F6, F5,
tactile Android et pause/reprise OK. Aucun détail par banc, durée ou FPS n'est ajouté à ce retour.

## Environnement rapporté par l’utilisateur

Poste Ubuntu 24.04.5 LTS x86_64 ; Godot 4.7.2 standard, templates installés ; OpenJDK
21.0.12.1 ; SDK ~/Android/Sdk ; téléphone Samsung Galaxy A16 SM-A165F, Android 16.
Détails historiques dans ../android.md. Ces versions sont celles consignées par le projet,
pas un inventaire refait sur le poste pendant HANDOFF-001. Sur une nouvelle machine,
vérifier la version réellement installée et utiliser les templates correspondants.
Le projet déclare 4.7 et GL Compatibility ; référence 540 × 960, portrait, arm64-v8a.

Godot 4.7.2 et le Galaxy A16 ont été disponibles pour STEP-028 : les exécutions et mesures
effectivement réalisées sont consignées en tête de ce fichier et dans ../steps/STEP-028.md.
Les restrictions mentionnées dans les textes historiques de HANDOFF-001 ne décrivent plus
l'environnement de cette étape.

## Procédure

Ouvrir project.godot, laisser terminer l’import. F5 lance Main/PerformanceLab, qui délègue
le jeu courant à ApplicationLab hors capture. Pour chaque
banc ci-dessous, ouvrir sa scène sous scenes/tests, F6, attendre le bilan, consulter Sortie/
Débogueur puis F8 avant la scène suivante. Attendu : OK, zéro échec, aucun nouvel avertissement.
Les longues boucles de simulation peuvent nécessiter quelques frames avant le bilan.
Les tests UI interagissent avec le viewport réel ; ne pas présumer qu’un lancement headless
constitue une recette équivalente. Aucun lanceur global headless fiable n’est livré.

## Bancs disponibles

| Scène sous scenes/tests | Couverture principale |
|---|---|
| application_lifecycle_tests.tscn | Dix cycles de notifications, temps figé, reprise explicite, anciens gestes, modal et défaite |
| run_lifecycle_tests.tscn | Dix resets + dix clics Rejouer, anciens acteurs/actions, bilan, signaux et compteurs |
| target_lock_tests.tscn | Cible vivante à portée conservée, soin, manuel, sortie de portée, mort et identité |
| wave_sequence_tests.tscn | Trois vagues, transitions et comptes globaux/locaux, pas de quatrième vague |
| wave_schedule_tests.tscn | Cadence, quota, saturation, apparition bloquée, plafond et fins |
| touch_scroll_tests.tscn | Vrais événements tactiles/souris, swipe depuis carte/espace, annulation et clic unique |
| attack_stationary_tests.tscn | Position/vitesse/jambes stables à portée, approche hors portée |
| manual_commands_tests.tscn | Attente unique/remplacement, priorité, échéance, revalidation et coûts |
| lifecycle_tests.tscn | Pause, mort, actions anciennes et absence d’effet tardif |
| gambit_controller_tests.tscn | Plan/engagement, règles, revalidation et combat automatique |
| gambit_diagnostics_tests.tscn | Journal borné, scénarios et nettoyage |
| gambit_tests.tscn | Évaluateur pur, priorités, conditions et déterminisme |
| gambit_editor_tests.tscn | Activation, réordre et conservation des règles |
| gambit_fields_tests.tscn | Cible/condition/seuil/action, validation atomique et modal |
| portrait_hud_tests.tscn | Zones sûres, géométrie et dernière règle atteignable |
| skill_slots_tests.tscn | Six emplacements et états de disponibilité sans effet |
| skills_tests.tscn | Soin/spéciale/récupération |
| skill_executor_tests.tscn | Exécuteur commun, coût et cooldown uniques |
| combat_simulation_tests.tscn | Ordonnancement, résultats et interactions de combat |
| attack_action_tests.tscn | Identité d’action, impact unique, portée et annulation |
| actor_state_tests.tscn | États indépendants, PV et statistiques |
| ground_crowd_tests.tscn | Séparation, limites et mouvements bornés |
| enemy_director_tests.tscn | Apparitions et poursuite des premiers laboratoires |
| ground_mover_tests.tscn | Approche, cible invalide, vitesse et limites |

La recette de chaque étape précise ses régressions prioritaires. Avant une modification
transversale du coordinateur, des entrées ou des exécuteurs, choisir les bancs couvrant les
comportements affectés, sans supprimer les assertions pour obtenir un résultat vert.

## Recette manuelle actuelle

Observer plusieurs attaques sur une même cible : aucun changement tant qu’elle vit et reste
à portée, aucun petit pas parasite. Vérifier soin/spéciale et commandes en attente, trois
vagues et compteurs, défaite, dix Rejouer (règles/pause conservées), swipe et appuis courts.
Sur Android : au moins dix allers-retours combinant Accueil, applications récentes et
verrouillage, pendant action, commande, geste et formulaire. Retour toujours en pause,
nouveau geste fonctionnel, pas de coût/effet doublé ou rattrapage. Le processus tué relance
une session neuve : pas de sauvegarde persistante revendiquée.
Voir ../steps/STEP-025-fix1.md, ../steps/STEP-026.md et ../steps/STEP-027.md.

## Export et identité APK

Le preset actuel Android Debug utilise ../gambit-arena-builds/step-028-debug.apk,
version 0.1.0-step028, code 28, paquet org.gambitarena.prototype. L'APK de référence
mesuré porte le SHA-256 `d2c710ef6fb1c935eb6afecbfe54e98b1a03d0a03266753c5c8b537cce1a23b9`.
Exporter en mode Debug explicitement ; le nom du preset ne suffit pas à prouver le mode utilisé.

```bash
~/Android/Sdk/platform-tools/adb devices -l &&
~/Android/Sdk/platform-tools/adb -d install -r ~/gambit-arena-builds/step-028-debug.apk &&
sha256sum ~/gambit-arena-builds/step-028-debug.apk
```

Le SHA réellement installé/testé doit être communiqué, pas une ancienne empreinte copiée.
STEP-028 modifie le code, les scènes et le preset ; HANDOFF-001 seul était documentaire.

## Dernières preuves reçues

| Étape | Commit | SHA-256 APK final validé |
|---|---|---|
| STEP-024 v2 | 89ae0f6 | d367d52fb3a3e6857d90c19f333d819a0b6e28d888fcab92c5a38a8dc46fcb09 |
| STEP-025 fix1 | f62162d | a05863ca35183215d53c270652a0a1927da4e74c8547fcf32112f6a42e97544a |
| STEP-026 | 344a584 | 1c6e699d3acf44a6f3e5ce6e85d333ac9bb60c14e946a548992bd5eb099a47a2 |
| STEP-027 | 665c0c8 | 07467efcfb7e663e363e6f6fc61644fd2bf2889e7ee3a3001d42589e0c6cf611 |

Ces retours sont globaux « F6 OK, tests manuels OK, fluidité OK ». Ne pas leur attribuer
un nombre de contrôles exécutés, une durée de session ou des FPS qui n’ont pas été fournis.
