# Mesures STEP-028 — protocole v1

Protocole fixé avant la campagne du 26 octobre 2026. Objectif provisoire de la roadmap :
30 images/s soutenues sur Galaxy A16. Aucun poste dominant ni gain n'est présumé.
L'instrumentation est optionnelle ; hors capture, le chemin de simulation reste celui de STEP-027.

## Conditions et déroulement

Godot/templates 4.7.2 standard, Android Debug arm64, Compatibility. Noter SHA de l'APK,
appareil/OS, rendu, résolution effective, VSync, fréquence physique, batterie, alimentation,
luminosité et mode automatique, économie d'énergie, température batterie et contexte externe.
La température batterie ne mesure pas la température CPU/GPU. Ne changer aucun réglage entre essais.
Écran déverrouillé, application au premier plan ; pas de manipulations pendant une capture.

Chaque essai commence par une remise à zéro, 30 s de chauffe puis 60 s de capture murale.
Les trois gambits standards sont requis, tous actifs : soin soi PV < 50 %, spéciale ennemi
Toujours, attaque ennemi Toujours. Onglet Compétences visible, repères désactivés, mêmes fenêtres.

1. Normal : partie ordinaire de trois vagues, quota 12/cap 6. Fin de partie : Rejouer automatique
   pendant le banc, enregistré ; aucun soin ou rééquilibrage ajouté au gameplay.
2. saturated20 : fixture distincte, 20 ennemis dès le départ, sans arrivées ni transitions.
   Profils locaux à 1 000 000 PV pour héros et ennemis ; compétences, coûts, déplacements,
   collisions et animations existants. L'effectif doit rester exactement 20. Ce n'est pas une
   mesure d'une partie Charge naturelle et il faut comparer des captures de la même fixture.
3. resets10 : partie normale, dix Rejouer programmés toutes les 5,5 s pendant les 60 s de capture.
   Les éventuels Rejouer après fin naturelle sont enregistrés séparément et peuvent s'y ajouter.

Alterner Normal et saturated20 trois fois, puis un resets10 : sept essais, environ onze minutes.
Ne pas mélanger Debug/Release, USB/sans USB, éditeur/standalone ou états thermiques sans les identifier.
Une pause, perte de focus, commande, changement d'onglet/règle/scénario/repères ou redimensionnement
invalide l'essai. L'export porte alors `interrupted` et son motif, jamais une conformité implicite.
La fin du banc laisse le jeu en pause. Rejouer sort de la fixture et retrouve les trois vagues.

## Critères de lecture fixés avant mesure

Pour chaque capture complète Normal/saturated20 : moyenne >= 30 FPS, p95 <= 33,333 ms,
p99 <= 50 ms, aucune frame > 100 ms et au moins 30 fins de frames dans chacune des fenêtres
murales complètes d'une seconde. Ce sont les critères opérationnels retenus pour cette recette,
pas des résultats déjà obtenus ni une certification de présentation à l'écran. Les trois répétitions
doivent être examinées séparément, sans masquer un essai défavorable par leur moyenne.

### Décision produit après mesure

Les critères précédents ont bien été appliqués aux campagnes du 26 octobre 2026 et ne sont pas
atteints par l'APK Debug mesuré. Après examen des données, le propriétaire a accepté les
performances pour le périmètre réel du prototype et précisé que vingt ennemis simultanés ne
feront pas partie de l'expérience prévue. La fixture `saturated20` conserve sa valeur de test
de marge et de régression, mais ne bloque plus la livraison au titre d'un budget produit. Cela
ne réécrit pas les résultats, ne transforme pas un échec chiffré en réussite, et n'autorise pas
à déduire une performance Release ou matérielle générale. Voir le tableau et les conditions dans
`docs/steps/STEP-028.md`.

Publier aussi maximum, nombres > 33,333/50/100 ms, temps de jeu avancé, coûts CPU, effectif,
mémoire statique, objets, nœuds, orphelins et ressources. Après resets, chercher une dérive qui ne
s'explique pas par le nombre d'acteurs ; une différence isolée n'est pas une preuve de fuite.
Les buffers de capture grandissent intentionnellement jusqu'à leur plafond ; la mémoire relevée
inclut cet effet. Orphelins/objets et répétitions comparables complètent ce compteur.

## Compteurs et limites

- `frame_interval_ms` : intervalles monotones `Time.get_ticks_usec()` entre callbacks `_process`.
  Toutes les frames sont gardées, y compris les longues, sans plafonnement par GameClock.
  Ce compteur inclut attente/scheduling/VSync ; il n'est ni un chronométrage GPU ni une mesure
  des présentations physiques de l'écran. CPU de rendu/GPU/Android compositor non séparés ici.
- `simulation_cpu_ms` : temps mural CPU autour de `CombatSimulation.advance`, présentation des
  acteurs incluse. `tick_cpu_ms` : callback physique complet, HUD et éventuels resets inclus.
  Les deux séries ne sont pas des temps d'image ; il peut y avoir plusieurs ticks par image.
- `game_step_ms` : progression effective de GameClock par tick (plafond 1/30 s inchangé).
  `game_seconds` est une somme des pas, y compris au travers des resets, pas un calcul de FPS.
- Télémétrie une fois/s : moniteurs moteur, effectif, run_id, resets. Les moniteurs moteur
  sont des indications globales, non une attribution précise à un sous-système.
  Mémoire statique disponible en Debug ; `-1` en Release indique indisponible, pas zéro.
- Quantiles : rang supérieur `ceil(p * n)`. Compteurs de frames longues : seuils stricts.
  Fenêtres d'une seconde fixes à partir du début de capture, dernière fraction exclue.

Plafonds : 32 768 intervalles, 16 384 ticks, 128 lignes de télémétrie, 64 événements et
128 fenêtres d'une seconde. Un buffer plein interrompt la capture, sans sélection/écrasement
silencieux des samples. Une seule session mémoire. Pas d'écriture disque pendant la capture.
Export JSON après arrêt : valeurs brutes, métadonnées, résumé ; 12 fichiers circulaires au maximum
sous `user://performance/capture-NN.json`, plus un petit index. Copier les données à conserver
avant de lancer plus de 12 exports. Aucun snapshot ou acteur vivant n'est conservé.

## Utilisation manuelle

F5, bouton **GAMBIT / Mesures**. Facultativement saisir les conditions, choisir le scénario ;
le menu se ferme pendant les 90 s et le compteur Chauffe/Mesure apparaît dans l'en-tête.
Au terme, consulter le résultat et le chemin d'export, puis fermer (pause conservée).
Sur PC, les fichiers sont dans le dossier utilisateur Godot indiqué. Scène directe F6 :
`scenes/performance/performance_lab.tscn`. Banc synthétique : `scenes/tests/performance_tests.tscn`.
Les tests synthétiques accélérés ne sont jamais des mesures matérielles.

## Campagne Android reproductible

Exporter Debug vers `~/gambit-arena-builds/step-028-debug.apk`, installer explicitement puis :

```bash
~/Android/Sdk/platform-tools/adb devices -l &&
~/Android/Sdk/platform-tools/adb -d install -r ~/gambit-arena-builds/step-028-debug.apk &&
sha256sum ~/gambit-arena-builds/step-028-debug.apk
```

Choisir le serial de l'appareil affiché, un dossier de sortie neuf et lancer :

```bash
python3 tools/capture_android_performance.py \
  --adb ~/Android/Sdk/platform-tools/adb --serial SERIAL_APPAREIL \
  --apk ~/gambit-arena-builds/step-028-debug.apk \
  --output /tmp/gambit-step028-mesures \
  --note 'USB, contexte externe et luminosite a consigner'
```

Le script vérifie le SHA de l'APK réellement installé via son chemin `pm path`, lit les conditions
avant/après chaque essai, force l'arrêt de cette application seulement, écrit une demande
`files/performance-request.txt` à usage unique via `run-as`, relance son activité et récupère
le bon export circulaire. Il n'installe pas l'APK, ne déverrouille pas l'écran et ne change
aucun réglage système. Polling toutes les 3 s pendant 115 s au plus par essai, logs Godot
du seul PID limités à 1 000 lignes. Manifest + sept captures et leurs logs, pas de boucle infinie.
Le Debug et `run-as` sont nécessaires. `--scenario normal` (ou saturated20/resets10),
avec `--repeats 1`, permet un diagnostic ciblé de 90 s, distinct de la campagne complète. Un export interrompu arrête la campagne pour examen.

Sur PC, `-- --performance=normal` (ou saturated20/resets10) après la commande Godot lance
le même protocole ; ces résultats ne qualifient pas le Galaxy A16.

## Références

[Time : horloge monotone](https://docs.godotengine.org/en/stable/classes/class_time.html),
[Performance : compteurs et disponibilité](https://docs.godotengine.org/en/stable/classes/class_performance.html).
