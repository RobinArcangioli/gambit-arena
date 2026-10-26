# Tests, environnement et preuves de validation

## Environnement rapporté par l’utilisateur

Poste Ubuntu 24.04.5 LTS x86_64 ; Godot 4.7.2 standard, templates installés ; OpenJDK
21.0.12.1 ; SDK ~/Android/Sdk ; téléphone Samsung Galaxy A16 SM-A165F, Android 16.
Détails historiques dans ../android.md. Ces versions sont celles consignées par le projet,
pas un inventaire refait sur le poste pendant HANDOFF-001. Sur une nouvelle machine,
vérifier la version réellement installée et utiliser les templates correspondants.
Le projet déclare 4.7 et GL Compatibility ; référence 540 × 960, portrait, arm64-v8a.

L’environnement de l’assistant ne possède pas Godot. Jusqu’ici : vérifications statiques
chez l’assistant, exécution F6 et recette matérielle chez l’utilisateur. Aucun banc CI,
benchmark matériel ou seuil de performance mesuré n’a été confirmé.

## Procédure

Ouvrir project.godot, laisser terminer l’import. F5 lance Main/ApplicationLab. Pour chaque
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

Le preset actuel Android Debug utilise ../gambit-arena-builds/step-027-debug.apk,
version 0.1.0-step027, code 27, paquet org.gambitarena.prototype. Exporter en mode Debug
explicitement ; le nom du preset ne suffit pas à prouver le mode utilisé.

```bash
~/Android/Sdk/platform-tools/adb devices -l &&
~/Android/Sdk/platform-tools/adb -d install -r ~/gambit-arena-builds/step-027-debug.apk &&
sha256sum ~/gambit-arena-builds/step-027-debug.apk
```

Le SHA réellement installé/testé doit être communiqué, pas une ancienne empreinte copiée.
HANDOFF-001 ne change pas le code/configuration et ne nécessite pas un nouvel APK.

## Dernières preuves reçues

| Étape | Commit | SHA-256 APK final validé |
|---|---|---|
| STEP-024 v2 | 89ae0f6 | d367d52fb3a3e6857d90c19f333d819a0b6e28d888fcab92c5a38a8dc46fcb09 |
| STEP-025 fix1 | f62162d | a05863ca35183215d53c270652a0a1927da4e74c8547fcf32112f6a42e97544a |
| STEP-026 | 344a584 | 1c6e699d3acf44a6f3e5ce6e85d333ac9bb60c14e946a548992bd5eb099a47a2 |
| STEP-027 | 665c0c8 | 07467efcfb7e663e363e6f6fc61644fd2bf2889e7ee3a3001d42589e0c6cf611 |

Ces retours sont globaux « F6 OK, tests manuels OK, fluidité OK ». Ne pas leur attribuer
un nombre de contrôles exécutés, une durée de session ou des FPS qui n’ont pas été fournis.
