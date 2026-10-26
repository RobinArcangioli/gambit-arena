# STEP-028 — Mesures reproductibles, validée par l'utilisateur

GO reçu le 26 octobre 2026 après vérification de cc91c79, main et GitHub synchronisés.
Dernière étape fonctionnelle validée : STEP-027 / 665c0c8. Aucun commit ni push STEP-028.
L'objectif initial de 30 FPS soutenues n'est pas observé dans l'APK Debug mesuré. Le
26 octobre 2026, après présentation des résultats, le propriétaire a toutefois confirmé que les
performances sont acceptables pour le périmètre réel et qu'il n'y aura jamais 20 ennemis visibles.
La fixture à 20 ennemis reste donc une marge de diagnostic, pas un critère de livraison. Cette
décision produit n'efface ni ne transforme rétroactivement les seuils et résultats ci-dessous ;
elle écarte seulement une optimisation de ce prototype sans besoin produit identifié.

**Validation utilisateur reçue le 26 octobre 2026 : « Tout est ok. F6, F5, tactile Android,
pause/reprise OK. Step validée. »** Aucun nombre de bancs, durée de session, FPS supplémentaire
ni nouveau SHA n'est déduit de ce retour. Commit, push et sauvegarde STEP-028 restent à faire.

## Changement livré

PerformanceCapture sépare intervalles réels de frames, coût CPU du tick, coût CPU de la
simulation et progression bornée de GameClock. Il garde les données brutes et calcule
médiane/p95/p99, maximum, frames longues et fenêtres d'une seconde. Buffers et fichiers
sont plafonnés ; export JSON après arrêt, captures interrompues explicitement signalées.

PerformanceLab ajoute le bouton GAMBIT / Mesures à Main et délègue le jeu ordinaire à
ApplicationLab. Le menu suit les zones sûres, garde le scroll tactile et l'ordre d'ApplicationGuard.
Normal, fixture de 20 ennemis durables et dix resets utilisent le même exécuteur et la même
simulation. Le banc laisse la pause et Rejouer retrouve les trois vagues ordinaires.

BattleLab reçoit seulement un chronométrage optionnel autour de simulation.advance.
Aucun changement dans CombatSimulation, GameClock, SkillExecutor, ciblage, animations,
routeur tactile, vagues ou garde Android. project.godot est octet pour octet identique.
Preset : version 0.1.0-step028, code 28, chemin explicite ../gambit-arena-builds/step-028-debug.apk.
Protocole, seuils fixés avant mesure et limites : [performance.md](../performance.md).

## Validation exécutée chez l'assistant

- Import Godot 4.7.2.stable.official.ed1daf0bf dans une copie isolée.
- Les 24 bancs historiques en headless : 1 594 contrôles, zéro échec, aucune erreur ou
  avertissement Godot relevé. Harnais temporaire, pas de runner global livré préexistant.
- Nouveau banc performance_tests.tscn : 32 contrôles, zéro échec, en headless et en fenêtre
  X11/Compatibility. Horloges, quantiles, bornes, saturation réelle, dix resets, interruption
  de focus/pause, export JSON, retour aux vagues et refus de gambits hors protocole.
- Huit contrôles supplémentaires en fenêtre avec événements injectés au viewport : ouverture du
  menu, zones sûres, dernier bouton, swipe depuis carte sans capture, appui unique sans commande
  de compétence, interruption par Pause et export du résultat interrompu. Zéro échec.
- Vérification visuelle en fenêtre du HUD portrait et du menu ; aucune mesure PC utilisée
  pour qualifier Android. Le pilote de bureau signale une tentative NVIDIA/DRI puis utilise
  correctement l'AMD Radeon/Mesa disponible. Aucun warning GDScript final.
- Export signé Debug et installation sur Samsung Galaxy A16 SM-A165F Android 16.
- Références res:// existantes, UID uniques, diff --check et invariants de configuration vérifiés.

Ces lancements ne sont pas une confirmation utilisateur F6 ni une recette tactile manuelle.

## APK de référence mesuré

Nom : step-028-debug.apk. SHA-256 :
`d2c710ef6fb1c935eb6afecbfe54e98b1a03d0a03266753c5c8b537cce1a23b9`.
Le script a récupéré le base.apk installé et vérifié la même empreinte avant mesure.
Godot/templates 4.7.2 ; GL Compatibility ; Mali-G57 MC2 ; écran logique 540 × 1170,
SubViewport 516 × 540 ; VSync 1 ; physique 60 Hz ; Debug standalone, sans éditeur distant.
Conditions : USB, batterie 100 %, luminosité 84/mode manuel, économie d'énergie activée.
Température batterie relevée avant/après chaque essai. Aucun réglage système modifié.

Les résultats complets et données brutes sont fournis avec la livraison, séparés du dossier
projet pour ne pas ajouter les captures JSON aux ressources de l'APK.

## Campagne Android effectivement exécutée

Sept captures complètes, chacune 30 s de chauffe + au moins 60 s de mesure murale.
Les critères ont été écrits avant mesure dans performance.md. **Les six essais Normal/20
échouent aux critères de 30 FPS soutenues dans ces conditions.**

| Essai | FPS moyens | p95 ms | p99 ms | Frames > 100 ms | Minimum par seconde |
|---|---:|---:|---:|---:|---:|
| normal-1 | 12.82 | 106.73 | 116.62 | 90 | 9 |
| normal-2 | 12.38 | 103.73 | 114.02 | 68 | 10 |
| normal-3 | 12.33 | 104.66 | 113.29 | 69 | 10 |
| saturated20-1 | 9.90 | 120.61 | 130.28 | 359 | 8 |
| saturated20-2 | 9.92 | 122.66 | 129.90 | 385 | 8 |
| saturated20-3 | 10.22 | 114.60 | 125.94 | 349 | 8 |
| resets10-1 | 13.51 | 96.04 | 104.49 | 21 | 11 |

Simulation moyenne : 0,677–0,694 ms/tick en Normal, 2,248–2,285 ms à 20 ennemis.
Callback physique complet, HUD inclus : 1,681–1,729 ms en Normal, 3,795–3,864 ms à 20.
Ces coûts ne suffisent pas à expliquer/attribuer les intervalles entre frames. Aucune
conclusion GPU ou aucun goulot Crowd/snapshots/HUD n'est démontré par ces seuls compteurs.
Les 20 ennemis sont présents dans toutes les lignes de télémétrie des trois fixtures saturées.
Les logs Godot des sept captures ne contiennent aucune erreur ou avertissement.

La campagne resets10 a réellement exécuté dix resets programmés et un replay de fin naturelle :
11 événements, compteur programmé final 10. Ressources à 43 et orphelins à zéro sur tous ses
échantillons ; mémoire statique 75 099 271 octets au début et 75 054 023 à la dernière ligne.
Ce résultat ne prouve pas une absence générale de fuite ; acteurs variables, allocations du moteur
et buffers de collecte influencent la mémoire. Les captures fixes à 20 restent vers 73,18–73,37 Mio.

L'économie d'énergie est restée activée (`low_power=1`) et la luminosité à 84/manuelle ;
USB et batterie 100 %. Ne pas extrapoler ces nombres à un essai sans économie d'énergie,
en Release ou sans USB. Aucun gain avant/après ni conformité générale n'est revendiqué.

## Comparaison demandée sans économie d'énergie

À la demande du propriétaire, une seconde campagne complète a été lancée avec la même APK de
référence et les autres réglages conservés. L'économie d'énergie a été désactivée manuellement
avant le lancement (`low_power=0` relevé avant/après chaque essai), puis rétablie à
`low_power=1` après la campagne. USB, batterie à 100 %, luminosité manuelle 84, même écran
logique et même protocole Debug ont été conservés. Température batterie au départ : 28,0 à
28,4 °C selon l'essai.

| Essai | FPS moyens | p95 ms | p99 ms | Frames > 100 ms | Minimum par seconde |
|---|---:|---:|---:|---:|---:|
| normal-1 | 20,86 | 77,25 | 85,21 | 1 | 13 |
| normal-2 | 18,36 | 79,93 | 89,19 | 4 | 12 |
| normal-3 | 18,40 | 80,85 | 87,00 | 3 | 12 |
| saturated20-1 | 13,63 | 92,68 | 99,57 | 8 | 11 |
| saturated20-2 | 13,23 | 94,69 | 104,46 | 17 | 10 |
| saturated20-3 | 14,15 | 92,12 | 100,29 | 10 | 11 |
| resets10-1 | 21,03 | 75,92 | 85,54 | 1 | 13 |

Le scénario Normal reste sous l'ancien objectif chiffré et la fixture saturée est logiquement
plus lente. Le coût CPU de simulation reste bas (0,668–0,680 ms/tick en Normal ;
2,081–2,105 ms/tick à 20 ennemis) tandis que les intervalles de frame mesurés restent élevés.
La sonde de layout déjà décrite ne justifie pas de lui attribuer ces écarts. Une sonde de rendu
préparée n'a pas été installée : la décision produit retire le besoin d'une optimisation ou d'un
diagnostic plus invasif. Aucun changement de gameplay ou de rendu n'a été intégré en réponse à
cette mesure.

**Décision performance : acceptée explicitement par le propriétaire pour le contenu prévu.**
Les données servent de référence Debug/USB et non de garantie de FPS universelle, de mesure
Release ou de certification à 20 ennemis.

## Diagnostic ciblé de mise en page

Un APK de diagnostic distinct (SHA
`db9ca8b7d01e44a59150767d266ae359ba72940457cb15d2813627e7d22c9b48`)
a mesuré les appels à la méthode de mise en page sans changer sa logique. Même scénario
Normal, chauffe/capture 30+60 s, économie active. Résultat : 13,19 FPS ; environ 13,79 appels
par seconde et 8,56 ms de méthode de mise en page par seconde murale pendant la capture.
Cette mesure ne justifie pas de traiter cette méthode comme le poste dominant des frames de
75–100 ms. Aucun correctif spéculatif de layout n'a donc été intégré. Ce diagnostic ne mesure
pas tout le travail natif du moteur ou le GPU. Données, patch de la sonde et SHA séparés
sont conservés avec les preuves. L'APK de référence livré a ensuite été réinstallé.

## Validation utilisateur

Le propriétaire a explicitement validé F6, F5, le tactile Android et pause/reprise le
26 octobre 2026. La validation porte sur l'étape courante, avec la décision performance
consignée plus haut. Les contrôles automatisés et matériels effectivement exécutés par
l'assistant restent distingués dans les sections précédentes ; ce retour global ne permet pas
d'inventer un découpage par banc, une durée, une série de gestes ou une nouvelle empreinte APK.

La suite de clôture est administrative : archive de validation, commit STEP-028 réalisé par le
propriétaire, puis sauvegarde incluant ce commit et vérification de celle-ci. STEP-029 n'est pas
démarrée par cette validation seule.
